args <- commandArgs(trailingOnly=TRUE)
stopifnot(length(args)==1L)
root <- normalizePath(args[[1]], mustWork=TRUE)
num17 <- function(x) if(length(x)==1) sprintf('%.17g',x) else NA_character_
numhex <- function(x) if(length(x)==1) sprintf('%a',x) else NA_character_
rows <- list(); record_rows <- list(); family_rows <- list()
for (run in c('run-1','run-2')) {
  file <- file.path(root,run,'Native_Raw_Results.rds')
  if (!file.exists(file)) next
  result <- readRDS(file)
  for (id in names(result)) {
    r <- result[[id]]; pieces <- strsplit(id,'__',fixed=TRUE)[[1]]
    base <- data.frame(run=run,id=id,family=pieces[1],variant=pieces[2],status=r$status,error=if(is.null(r$error)) '' else r$error,warnings=paste(r$warnings,collapse=' | '),stringsAsFactors=FALSE)
    if (r$status=='evaluated') {
      a <- r$raw; f <- r$oracle_frequency; n <- length(f)
      # Exact class count follows direct equality frequencies: sum(1/f) is integer G.
      # For this small finite fixture set, round extracts that integer; Python independently verifies it.
      G <- as.integer(round(sum(1/f)))
      exact_flag <- 10L*G <= n
      base$n <- n; base$classes_oracle <- G
      base$oracle_risk_numerator <- G; base$oracle_risk_denominator <- n
      base$actual_prosecutor_17 <- num17(a$global_risk$prosecutor)
      base$actual_prosecutor_hex <- numhex(a$global_risk$prosecutor)
      base$actual_marketer_17 <- num17(a$global_risk$marketer)
      base$actual_marketer_hex <- numhex(a$global_risk$marketer)
      base$actual_journalist_17 <- num17(a$global_risk$journalist)
      base$actual_journalist_hex <- numhex(a$global_risk$journalist)
      base$oracle_risk_double_17 <- num17(G/n)
      base$oracle_journalist_double_17 <- num17(G/(100*n))
      base$actual_privacy_pass <- a$privacy_pass
      base$exact_oracle_privacy_pass <- exact_flag
      base$actual_flag_equals_exact_oracle <- identical(a$privacy_pass,exact_flag)
      base$actual_flag_equals_native_threshold <- identical(a$privacy_pass,a$global_risk$prosecutor<=0.1)
      base$actual_frequency_agrees <- r$frequency_agrees
      base$prosecutor_agrees_tolerance_1e12 <- r$prosecutor_agrees
      base$marketer_agrees_tolerance_1e12 <- r$marketer_agrees
      base$journalist_agrees_tolerance_1e12 <- r$journalist_agrees
      base$runner_flag_agrees <- r$flag_agrees
      base$actual_n_uniques <- a$n_uniques; base$actual_pct_uniques_17 <- num17(a$pct_uniques)
      record_rows[[length(record_rows)+1]] <- data.frame(run=run,id=id,row=seq_len(n),oracle_frequency=f,actual_frequency=a$risk_per_record$freq,actual_prosecutor_17=vapply(a$risk_per_record$prosecutor,num17,character(1)),actual_prosecutor_hex=vapply(a$risk_per_record$prosecutor,numhex,character(1)),actual_journalist_17=vapply(a$risk_per_record$journalist,num17,character(1)),actual_journalist_hex=vapply(a$risk_per_record$journalist,numhex,character(1)))
    }
    rows[[length(rows)+1]] <- base
  }
}
# Preserve errors even if returned rows have different fields.
allnames <- unique(unlist(lapply(rows,names)))
rows <- lapply(rows,function(r){for(k in setdiff(allnames,names(r)))r[[k]]<-NA;r[allnames]})
dataset <- do.call(rbind,rows)
write.csv(dataset,file.path(root,'Dataset_Summary.csv'),row.names=FALSE,na='')
if(length(record_rows))write.csv(do.call(rbind,record_rows),file.path(root,'Per_Record_Native_And_Oracle.csv'),row.names=FALSE,na='')
for(run in unique(dataset$run))for(family in unique(dataset$family)){
 d<-dataset[dataset$run==run & dataset$family==family,,drop=FALSE]
 evaluated<-d[d$status=='evaluated',,drop=FALSE]
 family_rows[[length(family_rows)+1]]<-data.frame(run=run,family=family,datasets=nrow(d),native_success=sum(d$status=='evaluated'),native_errors=sum(d$status=='error'),frequency_disagreements=sum(!evaluated$actual_frequency_agrees),prosecutor_disagreements=sum(!evaluated$prosecutor_agrees_tolerance_1e12),marketer_disagreements=sum(!evaluated$marketer_agrees_tolerance_1e12),journalist_disagreements=sum(!evaluated$journalist_agrees_tolerance_1e12),flag_disagreements_exact=sum(!evaluated$actual_flag_equals_exact_oracle),actual_privacy_passes=sum(evaluated$actual_privacy_pass),oracle_privacy_passes=sum(evaluated$exact_oracle_privacy_pass),warning_datasets=sum(nzchar(d$warnings)))
}
write.csv(do.call(rbind,family_rows),file.path(root,'Family_Summary.csv'),row.names=FALSE)
a<-readRDS(file.path(root,'run-1/Native_Raw_Results.rds'));b<-readRDS(file.path(root,'run-2/Native_Raw_Results.rds'))
repeat_check<-list(dataset_order_identical=identical(names(a),names(b)),entire_raw_results_identical=identical(a,b),dataset_identical=setNames(vapply(names(a),function(id)identical(a[[id]],b[[id]]),logical(1)),names(a)))
dput(repeat_check,file=file.path(root,'Repeat_Comparison.txt'));saveRDS(repeat_check,file.path(root,'Repeat_Comparison.rds'))
u<-readRDS(file.path(root,'uniqueness-run/Uniqueness_Probe_Results.rds'))
uniqueness<-data.frame(n=u$reference$n,classes=u$reference$classes,singleton_records=u$reference$singleton_records,actual_pct_uniques_17=num17(u$actual$pct_uniques),actual_pct_uniques_hex=numhex(u$actual$pct_uniques),record_fraction_17=num17(u$reference$fraction_singleton_records),class_fraction_17=num17(u$reference$fraction_singleton_classes),agrees_record_denominator=u$comparison$agrees_record_denominator,agrees_class_denominator=u$comparison$agrees_class_denominator,frequency_correct=u$comparison$correct_row_frequency,actual_prosecutor_17=num17(u$actual$global_risk$prosecutor),actual_privacy_pass=u$actual$privacy_pass)
write.csv(uniqueness,file.path(root,'Uniqueness_Summary.csv'),row.names=FALSE)
print(aggregate(cbind(native_success,native_errors,frequency_disagreements,flag_disagreements_exact)~run,data=do.call(rbind,family_rows),FUN=sum))
print(repeat_check[c('dataset_order_identical','entire_raw_results_identical')]);print(uniqueness)
