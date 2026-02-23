
# --- IAM Roles Module: Lambda + Step Functions ---
module "iam" {
 source                  = "../../modules/iam"
 lambda_role_name        = "${var.project}-${var.env}-lambda-exec"
 step_function_role_name = "${var.project}-${var.env}-stepfunctions-exec"
 lambda_exec_role_arn = module.iam.lambda_role_arn
 env     = var.env
}

# --- S3 Buckets: raw + processed data storage ---
module "s3" {
 source = "../../modules/s3"
 project = var.project
 env     = var.env
}

# --- Glue ETL Job: data cleaning + feature engineering ---
module "glue" {
 source           = "../../modules/glue"
 project          = var.project
 env              = var.env
 glue_script_path = "s3://${module.s3.processed_bucket}/scripts/glue/glue_etl.py"
}

# --- SageMaker Notebook Setup ---
module "sagemaker" {
 source                = "../../modules/sagemaker"
 project               = var.project
 env                   = var.env
 lifecycle_config_name = var.lifecycle_config_name
 s3_processed_arn      = module.s3.processed_bucket_arn
}

# --- Lambda Function: triggers Step Function on new S3 file ---
module "lambda_sfn_starter" {
 source               = "../../modules/lambda"
 project              = var.project
 env                  = var.env
 function_name_suffix = "sfn-starter"
 zip_path             = "lambda/sfn_starter.zip"
 step_function_arn    = module.stepfunctions.pipeline_arn
 s3_raw_arn           = module.s3.raw_ingest_bucket_arn
 s3_raw_id            = module.s3.raw_ingest_bucket
 lambda_exec_role_arn = module.iam.lambda_role_arn
}

# --- Lambda Function: deploys SageMaker model after training ---
module "lambda_model_deployer" {
 source               = "../../modules/lambda"
 project              = var.project
 env                  = var.env
 function_name_suffix = "deploy-model"
 zip_path             = "lambda/deploy_model.zip"
 step_function_arn    = module.stepfunctions.pipeline_arn
 s3_processed_arn     = module.s3.processed_bucket_arn
 s3_processed_id      = module.s3.processed_bucket
 lambda_exec_role_arn = module.iam.lambda_role_arn
}

# --- Lambda Function: invokes SageMaker endpoint for fraud scoring ---
module "lambda_fraud_predictor" {
 source               = "../../modules/lambda"
 project              = var.project
 env                  = var.env
 function_name_suffix = "predict-fraud"
 zip_path             = "lambda/predict_fraud.zip"
 step_function_arn    = module.stepfunctions.pipeline_arn
 s3_processed_arn     = module.s3.processed_bucket_arn
 s3_processed_id      = module.s3.processed_bucket
 lambda_exec_role_arn = module.iam.lambda_role_arn
}

# --- Step Functions: pipeline orchestration ---
module "stepfunctions" {
  source                 = "../../modules/stepfunctions"
  project                = var.project
  env                    = var.env
  step_function_role_arn = module.iam.step_function_role_arn
}

# --- Output the Step Function ARN ---
output "step_function_arn" {
  description = "ARN of the deployed Step Functions state machine"
  value       = module.stepfunctions.step_function_role_arn
}