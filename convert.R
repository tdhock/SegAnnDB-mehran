works_with_R("3.1.2",
             dplyr="0.4.0",
             "Rdatatable/data.table@84ba1151299ba49e833e68a2436630216b653306")

bg.file <-
  "SE_Merged.duprm.unmp.rmvd.addrdgrp.sorted.indlralgn.bam_ratio.BedGraph"
cmd <- paste("grep -v '^track'", bg.file, "> no-tracklines.bedGraph")
system(cmd)
wc(bg.file)
wc("no-tracklines.bedGraph")
bg.data <- fread("no-tracklines.bedGraph")
setnames(bg.data, c("chrom", "chromStart", "chromEnd", "logratio"))
chroms <- paste0("chr", c(1:22, "X", "Y"))
only.chroms <- bg.data %>%
  filter(chrom %in% chroms) %>%
  arrange(chrom, chromStart, chromEnd)
header.tmp <-
  paste('track',
        'type=bedGraph',
        'db=hg38',
        'export=yes',
        'visibility=full',
        'maxSegments=20',
        'alwaysZero=on',
        'share=mcgill.ca',
        'graphType=points',
        'yLineMark=0',
        'yLineOnOff=on',
        'name=MehranTest1',
        'description="Mehran test hg38 freec"')
header <- sprintf(header.tmp)
out.file <- paste0("MehranTest1.bedGraph.gz")
one <- only.chroms %>%
  mutate(chromStart=sprintf("%d", chromStart),
         chromEnd=sprintf("%d", chromEnd))
con <- gzfile(out.file, "w")
writeLines(header, con)
write.table(one, con, quote=FALSE, row.names=FALSE, col.names=FALSE)
close(con)
