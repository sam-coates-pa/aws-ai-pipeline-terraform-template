
import sys
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from awsglue.utils import getResolvedOptions
from pyspark.sql.functions import col, hour, dayofweek, when, avg, count, lit

args = getResolvedOptions(sys.argv, ['JOB_NAME'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# Read raw data
input_path = "s3://fraud-dev-s3-raw-ingest/transactions/"
df = spark.read.option("header", True).csv(input_path)

# Convert timestamp to datetime
df = df.withColumn("Timestamp", col("Timestamp").cast("timestamp"))

# Clean numerical columns
df = df.withColumn("Transaction_Amount", col("Transaction_Amount").cast("double"))        .withColumn("Card_Age", col("Card_Age").cast("int"))        .withColumn("Risk_Score", col("Risk_Score").cast("double"))

# Extract time-based features
df = df.withColumn("Hour", hour(col("Timestamp")))        .withColumn("DayOfWeek", dayofweek(col("Timestamp")))        .withColumn("Is_Weekend", when(col("DayOfWeek").isin([1, 7]), lit(1)).otherwise(lit(0)))

# Placeholder features (assumes prior computation or simple mock for demo)
df = df.withColumn("Daily_Transaction_Count", lit(3))        .withColumn("Avg_Transaction_Amount_7d", lit(50.0))        .withColumn("Failed_Transaction_Count_7d", lit(0))        .withColumn("Transaction_Distance", lit(1.2))        .withColumn("Previous_Fraudulent_Activity", lit(0))        .withColumn("IP_Address_Flag", lit(0))

# Write enriched output to processed path
output_path = "s3://fraud-dev-s3-processed/processed/train/"
df.write.mode("overwrite").option("header", True).csv(output_path)

job.commit()
