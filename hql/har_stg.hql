CREATE EXTERNAL TABLE IF NOT EXISTS har_stg.har_staging (
timestamp_col TIMESTAMP,
back_x DOUBLE,
back_y DOUBLE,
back_z DOUBLE,
thigh_x DOUBLE,
thigh_y DOUBLE,
thigh_z DOUBLE,
label INT
)
COMMENT 'RAW HUMAN ACTIVITY RECOGNITION DATA'
ROW FORMAT DELIMITED
FIELDS TERMINATED BY ','
LINES TERMINATED BY '\n'
STORED AS TEXTFILE
LOCATION '/user/bigdatapedia/project/har_stg/'
TBLPROPERTIES ("skip.header.line.count"="1");
