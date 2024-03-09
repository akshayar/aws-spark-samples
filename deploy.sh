#!/bin/bash
ACCOUNT_ID=$(aws sts get-caller-identity --query Account --output text)
echo $ACCOUNT_ID
export STACK_NAME=
export AWS_REGION=
export SOURCE_CODE_BUCKET=
export DATA_BUCKET=
export GLUE_DATABASE_NAME=
export ENV_TYPE=
## Copy Code to S3 Bucket
aws s3 cp --recursive glue/code s3://${SOURCE_CODE_BUCKET}/glue/code
## Deploy Glue Job
aws cloudformation deploy \
        --stack-name ${STACK_NAME} \
        --template-file glue/deploy/cloudformation/glue-job.yaml \
        --region ${AWS_REGION} \
        --capabilities CAPABILITY_NAMED_IAM \
        --no-fail-on-empty-changeset \
        --role-arn arn:aws:iam::${ACCOUNT_ID}:role/cloudformation-github-actions-role \
        --tags EnvType=test \
        --parameter-overrides \
        SourceCodeBucket=${SOURCE_CODE_BUCKET} \
        DataBucket=${DATA_BUCKET} \
        GlueDatabaseName=${GLUE_DATABASE_NAME} \
        EnvType=${ENV_TYPE}