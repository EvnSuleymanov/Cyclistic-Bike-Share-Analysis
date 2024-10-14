#set the folder path
folder_path <- "D:/data_practice/case_study_cyclistic/01_raw_data_cyclistic"

#Use list.files() to get a list of all .csv files in the folder
csv_files <- list.files(path = folder_path, pattern = "*.csv", full.names = TRUE)

#use *lapply()* to read all *.csv* files into a list of data frames
list_of_dataframe <- lapply(csv_files, read.csv)

#finally I use *rbind()* to combine al 12 files
combined_dataframe <- do.call(rbind, list_of_dataframe)

#check created dataframe
summary(combined_dataframe)