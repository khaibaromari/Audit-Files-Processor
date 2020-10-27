library(dplyr)
calculate_audit <- function(input_folder = "input", output_folder = "output"){
  
  path_read <- dir("input", full.names = T)
  path_write <- dir("input")
  output_folder <- "output"
  
  overall_df <- data.frame("uuid"=path_write, "elapsed_time_sec_byQuestion" = NA, "elapsed_time_sec_byStartEnd" = NA, "time_diff" = NA )
  
  for (i in 1:length(path_read)) {
    audit_file <- read.csv(paste0(path_read[i], "/audit.csv"))
    audit_file$diff_in_ms <- audit_file$end -  audit_file$start
    audit_file$diff_in_sec <- (audit_file$end - audit_file$start) / 1000
    audit_file$diff_in_min <- (audit_file$end - audit_file$start) / 60000
    
    audit_file.sub<- audit_file[-c(1:4)]
    col_sum <- colSums(audit_file.sub, na.rm = T)
    
    audit_file <- bind_rows(audit_file, col_sum)
    audit_file[nrow(audit_file),1] <- "elapsed time by each question"
    
    audit_file[nrow(audit_file)+1,1] <- "elapsed time by form start and form finalize"
    audit_file[nrow(audit_file),"diff_in_ms"] <- audit_file[nrow(audit_file)-2, "start"] - audit_file[audit_file$event=="form start", "start"]
    audit_file[nrow(audit_file),"diff_in_sec"] <- (audit_file[nrow(audit_file)-2, "start"] - audit_file[audit_file$event=="form start", "start"]) / 1000
    audit_file[nrow(audit_file),"diff_in_min"] <- (audit_file[nrow(audit_file)-2, "start"] - audit_file[audit_file$event=="form start", "start"]) / 60000
    
    audit_file[nrow(audit_file)+1,1] <- "difference in calculation"
    audit_file[nrow(audit_file),"diff_in_ms"] <- audit_file[audit_file$event=="elapsed time by form start and form finalize", "diff_in_ms"] - audit_file[audit_file$event=="elapsed time by each question", "diff_in_ms"]
    audit_file[nrow(audit_file),"diff_in_sec"] <- audit_file[audit_file$event=="elapsed time by form start and form finalize", "diff_in_sec"] - audit_file[audit_file$event=="elapsed time by each question", "diff_in_sec"]
    audit_file[nrow(audit_file),"diff_in_min"] <- audit_file[audit_file$event=="elapsed time by form start and form finalize", "diff_in_min"] - audit_file[audit_file$event=="elapsed time by each question", "diff_in_min"]
    
    overall_df$elapsed_time_sec_byQuestion[i] <- audit_file[audit_file$event == "elapsed time by each question", "diff_in_sec"]
    overall_df$elapsed_time_sec_byStartEnd[i] <- audit_file[audit_file$event == "elapsed time by form start and form finalize", "diff_in_sec"]
    
    write.csv(audit_file, paste0(output_folder,"/",path_write[i],".csv"), row.names = F, na = "")
    print(paste0("calculating ", i ,  " of ", length(path_read)))
  
    rm(list = c("audit_file", "audit_file.sub","col_sum"))
  }
    overall_df$time_diff <- overall_df$elapsed_time_sec_byQuestion - overall_df$elapsed_time_sec_byStartEnd
    write.csv(overall_df, paste0(output_folder,"/Overall_df.csv"), row.names = F, na = "")
    print(paste("Note: a copy of overall audit time checks was created as 'Overall_df.csv' in ", output_folder, " folder"))
}

