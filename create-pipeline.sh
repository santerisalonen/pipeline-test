#!/bin/bash

# configuration variables
source config

BUILD_BUCKET=${PIPELINE_STACK_NAME}-build

if [ -z ${1} ]
then
	echo "PIPELINE CREATION FAILED!"
        echo "Pass your Github OAuth token as the first argument"
	exit 1
fi


# make bucket if does not exist
aws s3 mb s3://${BUILD_BUCKET} --region $REGION

# halt execution if commands return non-zero exit code
set -eu

# make build dir for artifacts
rm -rf build
mkdir build

#aws cloudformation package --template-file pipeline.yml --output-template-file build/pipeline.yml \
#  --s3-bucket $BUILD_BUCKET

aws cloudformation deploy \
  --capabilities CAPABILITY_IAM \
  --stack-name $PIPELINE_STACK_NAME \
  --region $REGION \
  --template-file pipeline.yml \
  --parameter-overrides \
    GitHubOwner=$GitHubOwner \
    GitHubRepo=$GitHubRepo \
    GitHubBranch=$GitHubBranch \
    GitHubOAuthToken=${1} 