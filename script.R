source("functions/audit_time_calculator.R")

# path of audit files/folder
audit_files_folder = "input"

# path of the folder to save the calculated audit files in
output_folder = "output"

# start the process of calculation
calculate_audit(audit_files_folder, output_folder)
