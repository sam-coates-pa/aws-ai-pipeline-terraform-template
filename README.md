# Fraud Detection Pipeline – AWS + Terraform

This repository contains a Proof‑of‑Concept (PoC) **AI‑enabled fraud detection pipeline** built on AWS using **Terraform**. It demonstrates a complete, automated machine learning workflow for credit card fraud detection using synthetic Kaggle data, and serves as a reusable template for rapid delivery of AI‑driven data pipelines.

Key Benefits for Our Data Engineering Sub‑Capability

- Reusable AWS AI pipeline template – accelerates setup and reduces repeated engineering effort.
- Faster client delivery – Terraform‑provisioned infrastructure enables rapid deployment and iteration.
- Standardised best‑practice patterns – improves consistency across projects and simplifies onboarding.
- Integrated Data Engineering + MLOps approach – strengthens capability across ingestion, ETL, training, deployment, and monitoring.
- Adaptable to multiple use cases – easily repurposed for anomaly detection, risk scoring, and other domain‑specific AI workloads.
- Enhances client confidence – demonstrates our technical maturity and ability to deliver AI pipelines quickly and reliably.

Source Data: [Click Here](https://www.kaggle.com/datasets/ealaxi/paysim1?resource=download)
---

## Overview

The pipeline automates ingestion, transformation, model training, inference, and analytics.  
The design is derived from the accompanying architecture slide deck, showing a modular cloud‑native ML flow using AWS services. 


he pipeline automates ingestion, transformation, model training, inference, and analytics.  
The design is derived from the accompanying architecture slide deck, showing a modular cloud‑native ML flow using AWS services.

### High‑Level Workflow
- Raw data ingestion into **S3 Landing Bucket**
- Data cleaning & transformation with **Glue Jobs**
- Fraud detection & prediction using a **SageMaker AI model**
- Processed output organised into **train**, **validation**, **model**, and **prediction** folders in S3
- Analytics & dashboards generated in **QuickSight**
- Workflow automation via **AWS Step Functions**
- Monitoring with **CloudWatch**
- SQL‑style interrogation using **Athena**

---

## Architecture Overview

### Core AWS Components

#### **S3 Landing Bucket**
Stores raw credit card transaction data before processing.  
Derived from the ingestion stage of the pipeline.

#### **AWS Glue Jobs**
Performs ETL including:  
- Data cleaning  
- Data standardisation  
- Transformation to model‑ready format  
Based on the “Data Cleaning & Transformation” stage.

#### **S3 Processed Buckets**
Output folder structure:

#### **SageMaker Training & Inference**
Supports:  
- Model training  
- Deployment  
- Fraud prediction checks  
Matches the “AI Base Fraud Detection & Prediction” and deployment steps.

#### **AWS Step Functions**
Orchestrates automated flow:  
Ingest → Transform → Train → Deploy → Predict  
Shown as “Orchestrate Workflow for Automation”.

#### **CloudWatch**
Monitors system health and logs pipeline execution.  
Matches the “Monitor Pipeline Health” component.

#### **Athena & QuickSight**
- Athena provides SQL‑based querying over processed data.  
- QuickSight visualises fraud insights on dashboards.  
These cover “Displays analysis on a Dashboard” and “Athena” items.

---

## Machine Learning Elements

The solution uses **synthetic Kaggle credit card transaction data** for fraud detection experiments.

### Workflow
- Data is cleaned through Glue  
- Training & validation sets generated  
- Model training performed in SageMaker  
- Predictions written to S3 under `predictions/`  
- Dashboard visuals updated in QuickSight  

This reflects the SageMaker training and prediction flow in the slide deck.

---

## Infrastructure as Code (Terraform)

Terraform is used to provision the entire stack, including:
- S3 buckets  
- Glue ETL jobs  
- IAM policies and roles  
- SageMaker training and inference resources  
- Step Functions workflow definition  
- CloudWatch alarms & log groups  
- Athena database/table definitions  
- QuickSight assets where supported  

This enables reproducibility and provides a template for future AWS‑based AI pipelines.

---

## Getting Started

### Prerequisites
- Terraform CLI  
- AWS credentials configured  
- Kaggle dataset placed in `/data` or uploaded to S3

### Deploy Infrastructure
```bash
cd terraform/environments/dev
terraform init
terraform apply
```

## Run the Pipeline

- Upload dataset to the Landing S3 bucket.
- Step Functions triggers ETL, training, and predictions.
- Trained model is deployed in SageMaker.
- Predictions are stored in S3.
- Dashboard updates in QuickSight.

---

## Dashboards & Analytics
QuickSight provides:

- Fraud probability heatmaps
- High‑risk transaction summaries
- Time‑series anomaly visualisation
- Model performance graphs

Athena allows flexible ad‑hoc interrogation of model outputs and processed datasets.

---

## Extending the Template
This pattern can be reused across:

- Fraud detection workloads
- Anomaly and risk scoring systems
- Automated ML pipelines on AWS
- Data engineering & ETL orchestrated workflows
