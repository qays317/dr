############################################
#  AWS Regions
############################################
PRIMARY_REGION="us-east-1"
DR_REGION="ca-central-1"

############################################
#  Terraform Backend Config
############################################
TF_STATE_BUCKET_NAME="terraform-state-110420261"
TF_STATE_BUCKET_REGION="eu-central-1"

############################################
#  ECS / Container Config
############################################
DOCKERHUB_IMAGE="qaysalnajjad/ecs-wordpress-app:v3.6"
ECR_REPO_NAME="ecs-wordpress-app"
ECS_CLUSTER_NAME="wordpress-cluster"
ECS_SERVICE_NAME="wordpress-service"

############################################
#  Media S3 buckets
############################################
PRIMARY_MEDIA_S3_BUCKET="wordpress-media-primary-20261"
DR_MEDIA_S3_BUCKET="wordpress-media-dr-20261"

############################################
#  Media S3 buckets
############################################
RDS_IDENTIFIER="wordpress-rds"
MAX_REPLICA_LAG=30

############################################
#  Domain and hosted zone
############################################
HOSTED_ZONE_ID="Z0201471MCIEQVEUEMQF"
PRIMARY_DOMAIN="rqays.com"   # Primary custom domain without www (e.g., yourdomain.com)
CERTIFICATE_SANs='["*.rqays.com"]'

############################################
#  SSL certificates
############################################
PRIMARY_ALB_SSL_CERTIFICATE_ARN="arn:aws:acm:us-east-1:174512274809:certificate/bfdb54d1-e12c-483e-9c4a-e5697af6c65d"
DR_ALB_SSL_CERTIFICATE_ARN=""
CLOUDFRONT_SSL_CERTIFICATE_ARN="arn:aws:acm:us-east-1:174512274809:certificate/bfdb54d1-e12c-483e-9c4a-e5697af6c65d"
