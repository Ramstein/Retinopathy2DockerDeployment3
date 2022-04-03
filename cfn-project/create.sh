#!/usr/bin/env bash
# uploading the template file to bucket studysync-cfn
aws s3 cp ~/environment/LearningEB/cfn-project/template.yaml s3://studysync-cfn/template.yaml --region us-east-1

# updating the stack in cloudformation
aws cloudformation create-stack \
    --region us-east-1 \
    --stack-name StudySync \
    --template-url https://studysync-cfn.s3.amazonaws.com/template.yaml \
    --parameters \
    ParameterKey=VpcId,ParameterValue=vpc-53ba612e
