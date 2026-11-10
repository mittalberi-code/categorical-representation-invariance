stopifnot(getRversion() >= '4.1.0')
if (!requireNamespace('riskutility', quietly=TRUE)) stop('Install pinned riskutility 0.2.0 through an approved setup first.')
stopifnot(as.character(packageVersion('riskutility')) == '0.2.0')
# Preserve the actual installed implementation for comparison with the pinned archive.
dput(get('attacker_risk.default', envir=asNamespace('riskutility')),
     file='Native_Installed_Function.txt')
writeLines(capture.output(packageDescription('riskutility')), 'Native_Package_Description.txt')
# Version equality alone is not sufficient provenance; review this function against the
# archive's unmodified source before accepting findings.
expected <- read.csv('expected.csv', stringsAsFactors=FALSE)
writeLines(capture.output(sessionInfo()), 'Native_Session_Info.txt')
records <- list()
for (id in unique(expected$id)) {
  e <- expected[expected$id == id, ]
  x <- read.csv(file.path('fixtures', paste0(id, '.csv')), colClasses='character',
                na.strings=NULL, check.names=FALSE, strip.white=FALSE, fileEncoding='UTF-8')
  stopifnot(nrow(x)==e$n[1], !anyNA(x))
  # Independent direct, elementwise equality oracle; no composite string keys.
  f <- vapply(seq_len(nrow(x)), function(i) sum(vapply(seq_len(nrow(x)),
    function(j) all(x[i, ] == x[j, ]), logical(1))), integer(1))
  stopifnot(all(f == e$freq), abs(mean(1/f)-e$score[1])<=1e-12)
  warnings <- character()
  out <- tryCatch(withCallingHandlers(riskutility::attacker_risk(x,
      key_vars=names(x), model='all', sampling_fraction=0.01, na.rm=TRUE),
      warning=function(w) {warnings <<- c(warnings,conditionMessage(w)); invokeRestart('muffleWarning')}),
      error=function(e) e)
  if (inherits(out,'error')) {
    records[[id]] <- list(status='error',error=conditionMessage(out),warnings=warnings)
  } else {
    records[[id]] <- list(status='evaluated',raw=out,oracle_frequency=f,
      frequency_agrees=identical(as.numeric(out$risk_per_record$freq),as.numeric(f)),
      prosecutor_agrees=abs(out$global_risk$prosecutor-mean(1/f))<=1e-12,
      marketer_agrees=abs(out$global_risk$marketer-mean(1/f))<=1e-12,
      journalist_agrees=abs(out$global_risk$journalist-mean(0.01/f))<=1e-12,
      flag_agrees=identical(out$privacy_pass,mean(1/f)<=0.1), warnings=warnings)
  }
}
saveRDS(records,'Native_Raw_Results.rds')
dput(records, file='Native_Raw_Results.txt')
cat('Native runs recorded:', length(records), '\n')
