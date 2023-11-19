hdfs dfs -mkdir -p /user/bigdatapedia/project/har_stg/
hdfs dfs -mkdir -p /user/bigdatapedia/project/har_landing/
hdfs dfs -mkdir -p /user/bigdatapedia/project/final/


echo "******************************** HDFS Folder Structure Created Successfully *********************************"

cd ../files

# # Local file folder where files are present
# LOCAL_CSV_FOLDER = "./"

# # HDFS File path
# HDFS_DESTINATION = "/user/bigdatapedia/project/har_stg/"



local_folder="/home/bigdatapedia/00MyOwn/assignments/hive_tables_shell_scripts/files/"
hdfs_path="/user/bigdatapedia/project/har_stg/"

for file in "$local_folder"/*; do
    if [ -f "$file" ]; then
        file_name=$(basename "$file")
        hdfs_file="$hdfs_path/$file_name"

        if hadoop fs -test -e "$hdfs_file"; then
            echo "File $file_name already exists in HDFS. Skipping..."
        else
            hadoop fs -put "$file" "$hdfs_path"
            echo "File $file_name copied to HDFS successfully."
        fi
    fi
done



# # Find minimum and maximum CSV file numbers
# MIN_CSV=$(ls -v "${LOCAL_CSV_FOLDER}"*.csv | awk -F/ '{print $NF}' | sed 's/.csv//' | sort -n | head -n 1)
# MAX_CSV=$(ls -v "${LOCAL_CSV_FOLDER}"*.csv | awk -F/ '{print $NF}' | sed 's/.csv//' | sort -n | tail -n 1)

# # Loop through CSV files and load them into HDFS Path
# for ((i=MIN_CSV; i<=MAX_CSV; i++)); do
#   CSV_FILE="${i}.csv"
#   LOCAL_FILE="${LOCAL_CSV_FOLDER}${CSV_FILE}"
#   HDFS_FILE="${HDFS_DESTINATION}${CSV_FILE}"

#   # Check if the file exists in HDFS
#   hdfs dfs -test -e "${HDFS_FILE}"
#   FILE_EXISTS=$?

#   # If the file doesn't exist in HDFS, copy it
#   if [ ${FILE_EXISTS} -ne 0 ]; then
#     # Copy CSV file to HDFS
#     hdfs dfs -put "${LOCAL_FILE}" "${HDFS_DESTINATION}"

#     # Check for successful file copy
#     if [ $? -eq 0 ]; then
#       echo "********** File ${CSV_FILE} copied to HDFS successfully **************"
#     else
#       echo "********* Failed to copy file ${CSV_FILE} to HDFS. *******************"
#     fi
#   else
#     echo "File ${CSV_FILE} already exists in HDFS. Skipping..."
#   fi
# done

cd ../hql

hive -e "create database if not exists har_stg"
hive -e "create database if not exists har_land"

echo "********** Hive Databases Created successfully **********"

hive -f "har_stg.hql"
hive -f "har_landing.hql"

echo "********** Hive Tables Created successfully **********"



hive -e "set hive.exec.dynamic.partition.mode=nonstrict;INSERT INTO TABLE har_land.har_landing PARTITION(label) SELECT timestamp_col,
back_x, back_y, back_z, thigh_x, thigh_y, thigh_z, label FROM har_stg.har_staging;"

cd ../files



  