stopifnot(as.character(packageVersion('riskutility')) == '0.2.0')
x <- data.frame(key=c('singleton', rep('repeated', 9)), stringsAsFactors=FALSE)
f <- vapply(seq_len(nrow(x)), function(i) sum(x$key == x$key[i]), integer(1))
n <- nrow(x)
G <- length(unique(x$key))
u <- sum(f == 1L)
reference <- list(n=n, classes=G, singleton_records=u,
  fraction_singleton_records=u/n, fraction_singleton_classes=u/G,
  row_frequency=f, prosecutor_score=mean(1/f))
stopifnot(n==10L, G==2L, u==1L,
          reference$fraction_singleton_records==0.1,
          reference$fraction_singleton_classes==0.5)
out <- riskutility::attacker_risk(x, key_vars='key', model='all',
                                 sampling_fraction=0.01, na.rm=TRUE)
comparison <- list(actual_pct_uniques=out$pct_uniques,
  agrees_record_denominator=isTRUE(all.equal(out$pct_uniques,u/n)),
  agrees_class_denominator=isTRUE(all.equal(out$pct_uniques,u/G)),
  correct_row_frequency=identical(as.numeric(out$risk_per_record$freq),as.numeric(f)))
saveRDS(list(input=x,reference=reference,actual=out,comparison=comparison),
        'Uniqueness_Probe_Results.rds')
dput(list(reference=reference,actual=out,comparison=comparison),
     file='Uniqueness_Probe_Results.txt')
writeLines(capture.output(print(out)), 'Uniqueness_Print.txt')
writeLines(capture.output(print(summary(out))), 'Uniqueness_Summary.txt')
writeLines(capture.output(sessionInfo()), 'Uniqueness_Session_Info.txt')
# No assertion chooses record/class interpretation: preserve both for adjudication.
