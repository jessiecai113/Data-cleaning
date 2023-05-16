# 设置输入文件夹和输出文件路径
input_folder <- "D:/2009DL"
output_file <- "D:/DL2009/2009-DL-OTP.csv"

# 判断文件是否存在
if (file.exists(output_file)) {
  # 如果存在，删除文件
  file.remove(output_file)
}

# 获取指定文件夹中所有 csv 文件的路径
csv_files <- sort(list.files(input_folder, pattern = ".csv$", full.names = TRUE))

# 定义过滤函数
my_filter <- function(file_path) {
  # 读取 csv 文件并进行过滤
  flight_table <- read.csv(file_path, header = TRUE)
  filter_airline = flight_table[
    flight_table$OP_UNIQUE_CARRIER %in% c("DL")
    & flight_table$ARR_DELAY_NEW > 15 & complete.cases(flight_table$ARR_DELAY_NEW) &
      (
        (flight_table$ORIGIN == "ATL" & flight_table$DEST %in% c("MCO", "FLL", "LGA"))
        | (flight_table$ORIGIN == "CLT" & flight_table$DEST %in% c("MCO"))
        | (flight_table$ORIGIN == "JFK" & flight_table$DEST %in% c("LAX"))
        | (flight_table$ORIGIN == "LAS" & flight_table$DEST %in% c("LAX"))
        | (flight_table$ORIGIN == "LAX" & flight_table$DEST %in% c("SFO", "ORD", "SEA", "ATL","DFW", "JFK"))
        | (flight_table$ORIGIN == "LGA" & flight_table$DEST %in% c("ORD"))
        | (flight_table$ORIGIN == "MCO" & flight_table$DEST %in% c("ATL"))
      ),
  ]
  
  # 将结果写入到输出文件
  write.table(filter_airline, file = output_file, sep = ",", append = TRUE,
              row.names = FALSE, col.names = !file.exists(output_file), na = "")
}

# 对每个 csv 文件依次进行过滤操作
lapply(csv_files, my_filter)