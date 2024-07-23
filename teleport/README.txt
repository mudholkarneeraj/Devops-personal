sudo apt upgrade
sudo apt update
TELEPORT_EDITION="oss"
TELEPORT_VERSION="16.0.1”
curl https://goteleport.com/static/install.sh | bash -s ${TELEPORT_VERSION?} ${TELEPORT_EDITION?}
sudo teleport configure
mv /var/lib/teleport.yaml  /etc/.
URL https:IP:3080
 
teleport start \
   --roles=node \
   --token=91fc3197cf2a670bc59167779035956e \
   --ca-pin=sha256:85e07c98ff72cd939737e1ea39263190940247cdad9e78f8088330f3f59a4af2 \
   --auth-server=172.31.75.44:3025

=======================
AWS policy
=======================
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "s3:ListBucket",
                "s3:GetBucketLocation"
            ],
            "Resource": "arn:aws:s3:::mimir-storage-staging"
        },
        {
            "Effect": "Allow",
            "Action": [
                "s3:PutObject",
                "s3:GetObject",
                "s3:DeleteObject",
                "s3:AbortMultipartUpload",
                "s3:ListMultipartUploadParts",
                "s3:ListBucketMultipartUploads",
                "s3:ListBucket",
                "s3:ListBucketVersions",
                "s3:GetObjectVersion"
            ],
            "Resource": [
                "arn:aws:s3:::mimir-storage-staging/*",
                "arn:aws:s3:::mimir-storage-staging"
            ]
        }
    ]
}
================================================
sudo teleport start --config="/etc/teleport.yaml"

