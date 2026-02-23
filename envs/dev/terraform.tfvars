project               = "fraud"
env                   = "dev"
region                = "eu-west-2"

s3_bucket_raw         = "fraud-dev-s3-raw-ingest"
s3_bucket_processed   = "fraud-dev-s3-processed"

s3_raw_arn            = "arn:aws:s3:::fraud-dev-s3-raw-ingest"
s3_raw_id             = "fraud-dev-s3-raw-ingest"
s3_processed_arn      = "arn:aws:s3:::fraud-dev-s3-processed"
s3_processed_id       = "fraud-dev-s3-processed"

glue_script_path      = "s3://fraud-dev-s3-processed/scripts/glue_etl.py"
step_function_arn     = "arn:aws:states:eu-west-2:654654416089:stateMachine:fraud-dev-fraud-pipeline"

lambda_exec_role_arn  = "arn:aws:iam::aws:policy/AdministratorAccess"
lifecycle_config_name = null