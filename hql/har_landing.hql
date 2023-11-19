CREATE EXTERNAL TABLE IF NOT EXISTS har_land.har_landing (
timestamp_col TIMESTAMP,
back_x DOUBLE,
back_y DOUBLE,
back_z DOUBLE,
thigh_x DOUBLE,
thigh_y DOUBLE,
thigh_z DOUBLE
)
PARTITIONED BY (label INT)
STORED AS ORC
LOCATION '/user/bigdatapedia/project/har_landing/';
