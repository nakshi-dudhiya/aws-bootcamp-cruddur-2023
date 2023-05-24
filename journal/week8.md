# Week 8 — Serverless Image Processing

IMPLEMENT CDK STACK
reference: https://www.youtube.com/watch?v=YiSNlK4bk90&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=72

IMPLEMENTED USERS PROFILE PAGE AND PROFILE FORM

reference:  https://www.youtube.com/watch?v=WdVPx-LLjQ8&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=75
https://www.youtube.com/watch?v=PTafksks528&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=76


IMPLEMENTED MIGRATION TO ADD BIO TO THE COLUMN
reference: https://www.youtube.com/watch?v=PTafksks528&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=76
```
from lib.db import db
class AddBioColumnMigration:
  def migrate_sql():
    data = """
    ALTER TABLE public.users ADD COLUMN bio text;
    """
    return data
  def rollback_sql():
    data = """
    ALTER TABLE public.users DROP COLUMN bio;
    """
    return data
  def migrate():
    db.query_commit(AddBioColumnMigration.migrate_sql(),{
    })
  def rollback():
    db.query_commit(AddBioColumnMigration.rollback_sql(),{
    })
migration = AddBioColumnMigration
```

IMPLEMENTED PRESIGNED URL and HTTP API GATEWAY LAMBDA AUTHORIZER
<img width="655" alt="image" src="https://github.com/nakshi-dudhiya/aws-bootcamp-cruddur-2023/assets/65428141/5ae0e3f2-94e8-4579-82c4-f977d80ea6a1">
NOTE: Added the USER_POOL_ID and CLIENT_ID under the ENV VAR in the LAMBDA
reference: https://www.youtube.com/watch?v=Bk2tq4pliy8&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=77


Fixed Several Cors Issue By:
1) Adding the proxy
<img width="220" alt="image" src="https://github.com/nakshi-dudhiya/aws-bootcamp-cruddur-2023/assets/65428141/dd4a4d0c-1ffb-4a17-9bbf-4c587e822090">

2) Adding the CORS origin under S3 bucket for S3upload function in ProfileForm.js
<img width="566" alt="image" src="https://github.com/nakshi-dudhiya/aws-bootcamp-cruddur-2023/assets/65428141/0a910ae3-ef4d-4ead-a05d-a52a8404f797">

3) Configuring the lambda layers and updating the function.rb  
```
require 'aws-sdk-s3'
require 'json'
require 'jwt'

def handler(event:, context:)
    puts event
    # return cors headers for preflight check
    
    if event['routeKey'] == "OPTIONS /{proxy+}"
      puts ({step: 'preflight', msg: 'preflight CORS check'}.to_json)
      { 
        headers: {
            "Access-Control-Allow-Headers": "*, Authorization",
            "Access-Control-Allow-Origin": "https://3000-**********.gitpod.io",
            "Access-Control-Allow-Methods": "OPTIONS,GET,POST"
            },
        statusCode: 200
        }
    else
        token = event['headers']['authorization'].split(' ')[1]
        puts ({step: 'presignedUrl', access_token: token}.to_json)

        body_hash= JSON.parse(event["body"])
        extension = body_hash["extension"]

        decoded_token = JWT.decode token, nil, false
        puts "DECODED"
        cognito_user_uuid= decoded_token[0]['sub']

        s3 = Aws::S3::Resource.new
        bucket_name= ENV["UPLOADS_BUCKET_NAME"]
        object_key = "#{cognito_user_uuid}.#{extension}"

        puts ({object_key: object_key}.to_json)

        obj = s3.bucket(bucket_name).object(object_key)
        url = obj.presigned_url(:put, expires_in: 60 * 5)
        url #This data will be returned
        body = { url: url}.to_json 
        { 
        headers: {
            "Access-Control-Allow-Headers": "*, Authorization",
            "Access-Control-Allow-Origin": "https://3000-**********.gitpod.io",
            "Access-Control-Allow-Methods": "OPTIONS,GET,POST"
            },
        statusCode: 200, 
        body: body 
        }
    end
end
```
Reference: 
https://www.youtube.com/watch?v=Bk2tq4pliy8&t=2729s
https://www.youtube.com/watch?v=eO7bw6_nOIc&t=1035s
https://www.youtube.com/watch?v=uWhdz5unipA&t=319s

IMPLEMENTING JWT LAMBDA-LAYERS:
```
#! /usr/bin/bash

gem i jwt -Ni /tmp/lambda-layers/ruby-jwt/ruby/gems/2.7.0
cd /tmp/lambda-layers/ruby-jwt

zip -r lambda-layers . -x ".*" -x "*/.*"
zipinfo -t lambda-layers

aws lambda publish-layer-version \
  --layer-name jwt \
  --description "Lambda Layer for JWT" \
  --license-info "MIT" \
  --zip-file fileb://lambda-layers.zip \
  --compatible-runtimes ruby2.7
 ```
 Reference: https://www.youtube.com/watch?v=uWhdz5unipA&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=79
 

IMPLEMENTED THE PROFILE AVATAR VIA CLOUDFRONT:

<img width="676" alt="image" src="https://github.com/nakshi-dudhiya/aws-bootcamp-cruddur-2023/assets/65428141/3c2f7d66-b257-4e7e-94a0-c4723a5b9948">
reference: https://www.youtube.com/watch?v=xrFo3QLoBp8&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=80
