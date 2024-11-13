# bin/bash
sam build
cd .aws-sam/build/Fitness/
zip -r app.zip .
aws lambda update-function-code --function-name Fitness --zip-file fileb://app.zip --region eu-south-1 --profile personal
cd ../../../
