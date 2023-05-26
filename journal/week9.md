# Week 9 — CI/CD with CodePipeline, CodeBuild and CodeDeploy

Implemented the buildspec.yml file
```
# Buildspec runs in the build stage of your pipeline.
version: 0.2
phases:
  install:
    runtime-versions:
      docker: 20
    commands:
      - echo "cd into $CODEBUILD_SRC_DIR/backend"
      - cd $CODEBUILD_SRC_DIR/backend-flask
      - aws ecr get-login-password --region $AWS_DEFAULT_REGION | docker login --username AWS --password-stdin $IMAGE_URL
  build:
    commands:
      - echo Build started on `date`
      - echo Building the Docker image...          
      - docker build -t backend-flask .
      - "docker tag $REPO_NAME $IMAGE_URL/$REPO_NAME"
  post_build:
    commands:
      - echo Build completed on `date`
      - echo Pushing the Docker image..
      - docker push $IMAGE_URL/$REPO_NAME
      - cd $CODEBUILD_SRC_DIR
      - echo "imagedefinitions.json > [{\"name\":\"$CONTAINER_NAME\",\"imageUri\":\"$IMAGE_URL/$REPO_NAME\"}]" > imagedefinitions.json
      - printf "[{\"name\":\"$CONTAINER_NAME\",\"imageUri\":\"$IMAGE_URL/$REPO_NAME\"}]" > imagedefinitions.json

env:
  variables:
    AWS_ACCOUNT_ID: 312848040152
    AWS_DEFAULT_REGION: ca-central-1
    CONTAINER_NAME: backend-flask
    IMAGE_URL: 312848040152.dkr.ecr.ca-central-1.amazonaws.com
    REPO_NAME: backend-flask:latest
artifacts:
  files:
    - imagedefinitions.json
 ```
 
 Added the Policy to the ECR (backend-flask)
 ```
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "codebuild",
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::312848040152:role/service-role/codebuild-cruddur-service-role"
      },
      "Action": [
        "ecr:BatchCheckLayerAvailability",
        "ecr:BatchGetImage",
        "ecr:CompleteLayerUpload",
        "ecr:DescribeImages",
        "ecr:DescribeRepositories",
        "ecr:GetAuthorizationToken",
        "ecr:GetDownloadUrlForLayer",
        "ecr:GetLifecyclePolicy",
        "ecr:GetLifecyclePolicyPreview",
        "ecr:GetRepositoryPolicy",
        "ecr:InitiateLayerUpload",
        "ecr:ListImages",
        "ecr:PutImage",
        "ecr:UploadLayerPart"
      ]
    }
  ]
}
```

Also followed the steps for additional ecr:GetAuthorizationToken
Search for the IAM user or role specified in the ARN (codebuild-cruddur-service-role/AWSCodeBuild-146aa108-4910-4b26-9c60-330xxxxxx3f07) and select it.
In the user or role details page, click on the "Add permissions" button.
Choose the "Attach existing policies directly" option.
Search for the AmazonEC2ContainerRegistryReadOnly managed policy and select it. This policy includes the necessary permissions for the ecr:GetAuthorizationToken action.


References:  https://www.youtube.com/watch?v=DLYfI0ehMZE&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=81&t=3081s
https://www.youtube.com/watch?v=py2E1f0IZg0&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=82
https://www.youtube.com/watch?v=EAudiRT9Alw&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=83
