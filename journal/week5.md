# Week 5 — DynamoDB and Serverless Caching
Summary: I have successfully accomplished all the tasks for dynamoDb which includes Creating message groups, creating messages for an existing group, updating a message group using DynamoDb, listing messages, listing messages in the message groups and a few more.

Implemented Schema load script for ddb

```
#!/usr/bin/env python3

import boto3
import sys

attrs ={
    'endpoint_url': 'http://localhost:8000'
}

if len(sys.argv) == 2:
 if "prod" in sys.argv[1]:
    attrs = {}


ddb = boto3.client('dynamodb',**attrs)
table_name = 'cruddur-message'

response = ddb.create_table(
  TableName=table_name,
  AttributeDefinitions=[
    {
      'AttributeName': 'pk',
      'AttributeType': 'S'
    },
    {
      'AttributeName': 'sk',
      'AttributeType': 'S'
    },
  ],
  KeySchema=[
    {
      'AttributeName': 'pk',
      'KeyType': 'HASH'
    },
    {
      'AttributeName': 'sk',
      'KeyType': 'RANGE'
    },
  ],
  #GlobalSecondaryIndexes=[
  #],
  BillingMode='PROVISIONED',
  ProvisionedThroughput={
      'ReadCapacityUnits': 5,
      'WriteCapacityUnits': 5
  }
)

print(response)
```

IMPLEMENTED SEED SCRIPT FOR DDB, IMPLEMENTED SCAN SCRIPTS
Reference: https://www.youtube.com/watch?v=pIGi_9E_GwA&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=52

IMPLEMENTED LIST TABLES FOR DDB
```
#! /usr/bin/bash
set -e # Stop if it fails at any point

if [ "$1" = "prod" ]; then
    ENDPOINT_URL= "" 
else 
    ENDPOINT_URL="--endpoint-url=http://localhost:8000"
fi

aws dynamodb list-tables $ENDPOINT_URL --query TableNames --output table

```

IMPLEMENTED DROP SCRIPT FOR DDB

```
#! /usr/bin/bash
set -e # Stop if it fails at any point

if [ -z "$1" ]; then
    echo "No TABLE_NAME argument supplied eg ./bin/ddb/drop cruddur-messages prod " 
    exit 1
fi
TABLE_NAME=$1

if [ "$2" = "prod" ]; then
    ENDPOINT_URL= "" 
else 
    ENDPOINT_URL="--endpoint-url=http://localhost:8000"
fi

echo "Deleting table: $TABLE_NAME "

aws dynamodb delete-table $ENDPOINT_URL --table-name $TABLE_NAME
```

IMPLEMENT SCAN DDB
```
#! /usr/bin/env python3

import boto3
import sys

attrs = {
  'endpoint_url': 'http://localhost:8000'
}
# unset endpoint url for use with production database
if len(sys.argv) == 2:
  if "prod" in sys.argv[1]:
    attrs = {}
ddb = boto3.resource('dynamodb',**attrs)
table_name = 'cruddur-messages'

table= ddb.Table(table_name)
response = table.scan()

print("======")
print(response)

items = response['Items']
for item in items:
    print(item)
    
```



Reference: https://www.youtube.com/watch?v=pIGi_9E_GwA&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=52


IMPLEMENTING UPDATE COGNITO-ID FOR POSTGRES DATABASE, IMPLEMENT LIST MESSAGES IN MESSAGE GROUP, IMPLEMENT LIST MESSAGE GROUP,
IMPLEMENT CREATE A MSG IN EXISTING GROUP, IMPLEMENT CREATE A MSG IN A NEW MSG GROUP

UPDATE COGNITO ID SCRIPT
```
#!/usr/bin/env python3

import boto3
import os
import sys

print("--Db-update-cognito-user-ids--")

current_path = os.path.dirname(os.path.abspath(__file__))
parent_path = os.path.abspath(os.path.join(current_path, '..', '..'))
sys.path.append(parent_path)
from lib.db import db

def update_users_with_cognito_user_id(handle,sub):
  sql = """
    UPDATE public.users
    SET cognito_user_id = %(sub)s
    WHERE
      users.handle = %(handle)s;
  """
  db.query_commit(sql,{
    'handle' : handle,
    'sub' : sub
  })

def get_cognito_user_ids():
  #userpool_id = os.getenv("AWS_COGNITO_USER_POOL_ID")
  userpool_id = "ca-central-1_uzDTfbFtP"
  client = boto3.client('cognito-idp')
  params = {
    'UserPoolId': userpool_id,
    'AttributesToGet': [
        'preferred_username',
        'sub'
    ]
  }
  response = client.list_users(**params)
  users = response['Users']
  dict_users = {}
  for user in users:
    attrs = user['Attributes']
    sub    = next((a for a in attrs if a["Name"] == 'sub'), None)
    handle = next((a for a in attrs if a["Name"] == 'preferred_username'), None)
    dict_users[handle['Value']] = sub['Value']
  return dict_users


users = get_cognito_user_ids()

for handle, sub in users.items():
  print('----',handle,sub)
  update_users_with_cognito_user_id(
    handle=handle,
    sub=sub
  )
```

Reference: https://www.youtube.com/watch?v=dWHOsXiAIBU&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=54

UPDATE A MSG GROUP
Reference:  https://www.youtube.com/watch?v=zGnzM_YdMJU&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=55

