
# Week-6, Week 7 — Solving CORS with a Load Balancer and Custom Domain

Provisioned ECS Cluster, ECR Repo, push image for backend-flask and Deploy backend flask as a service to fargate
<img width="700" alt="image" src="https://github.com/nakshi-dudhiya/aws-bootcamp-cruddur-2023/assets/65428141/21c5cd74-73b6-41fd-811a-889c0e709278">

Reference: https://www.youtube.com/watch?v=QIZx2NhdCMI&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=58

Added the health-check -backend-flask/bin/flask/health-check

<img width="275" alt="image" src="https://github.com/nakshi-dudhiya/aws-bootcamp-cruddur-2023/assets/65428141/560423e9-048b-4475-b72d-47327ee5772c">



```
#!/usr/bin/env python3

import urllib.request

try: 
  response = urllib.request.urlopen('http://localhost:4567/api/health-check')
  if response.getcode() == 200:
    print("[OK] Flask server is running")
    exit(0) #SUCCESS
  else:
    print("[BAD] Flask server is not running")
    exit(1)#FALSE
except Exception as e:
    print(e)
    exit(1) #FALSE
 ```

Provisioned ECR Repo, push image for frontend-react-js and Deploy it as a service to fargate
reference: https://www.youtube.com/watch?v=HHmpZ5hqh1I&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=59

Managed the route 53 via hosted zones and created an ssl certificate via ACM
Setup a record ser for domain to point to front-end and api domain to point to backend
Configure CORS to only permit traffic from our domain

<img width="710" alt="image" src="https://github.com/nakshi-dudhiya/aws-bootcamp-cruddur-2023/assets/65428141/ca593a15-8725-4a92-8198-3a8a1918caf5">

<img width="764" alt="image" src="https://github.com/nakshi-dudhiya/aws-bootcamp-cruddur-2023/assets/65428141/4972e260-01fd-4197-9e1c-9cf4ea32c4b2">

reference: https://www.youtube.com/watch?v=HHmpZ5hqh1I&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=59

Secure flask by not running in debug mode
Reference: https://www.youtube.com/watch?v=9OQZSBKzIgs&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=60


Implemented Refresh token for Amazon Cognito
Reference: https://www.youtube.com/watch?v=LNLP2dxa5EQ&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=63

Refactored bin directory to be top-level
reference: https://www.youtube.com/watch?v=HyJOjBjieb4&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=62

Configured task definitions to contain x-ray and turn on container insights 
Changed the docker compose to explicitly use for a user-defined network
Created dockerfile for prod use case
Created a ruby script to generate env dot files for docker using erb
Reference: https://www.youtube.com/watch?v=G_8_xtS2MsY&list=PLBfufR7vyJJ7k25byhRXJldB5AiwgNnWv&index=64





Summary: I have successfully accomplished all the tasks for creating ECR repo for frontend and backend. Configuring task definition with X-ray and turn on container insights, using ruby to generate frontend/backend env along with the tasks for week-6.
