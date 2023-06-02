## Architecture Guide

Before you run any templates, be sure to create an S3 bucket to contain
all of our artifacts for Cloudformation

```
aws s3 mk s3://cfn-artifacts-ncodes
export CFN_BUCKET="cfn-artifacts-ncodes"
gp env CFN_BUCKET="cfn-artifacts-ncodes"
```

