## Retrieving Amazon EKS optimized Amazon Linux AMI IDs

aws ssm get-parameter --name /aws/service/eks/optimized-ami/1.28/amazon-linux-2/recommended/image_id --region region-code --query "Parameter.Value" --output text
