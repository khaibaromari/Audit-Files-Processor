# Audit-Files-Processor
Audit File Processor is an R module built to process the audit (media) files of data collected via the KoBo Toolbox or ODK Collect.
The input for this function is the path to the directory where audit (.csv) files are stored inside their specific UUID folder.
What exactly does it do? It calculates the amount of time spent on answering each question in miliseconds, seconds, and minutes.
The result will be a .csv file with the respective UUID name.
