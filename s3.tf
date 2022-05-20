# bucket per conservar els fitxers de nextcloud
resource "aws_s3_bucket" "nextcloud_s3_datastore" {
  bucket = "arans3"
 # acl    = "private"

  force_destroy = true

  tags = {
    Name = "s3 cloudfront"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = "arans3"

  block_public_acls = true
  block_public_policy = true
  ignore_public_acls = true
  restrict_public_buckets = true  


}
## afegit
data "aws_caller_identity" "current" {}

# Allow access to the bucket only to the nextcloud user and the terraform user
resource "aws_s3_bucket_policy" "nextcloud_s3_datastore_policy" {

  bucket = aws_s3_bucket.nextcloud_s3_datastore.id

  policy = <<S3_POLICY
{
  "Id": "NextcloudS3Policy",
  "Version": "2008-10-17",
  "Statement": [
    {
      "Sid": "1",
      "Effect": "Allow",
      "Action": "s3:GetObject",
      "Resource": [ 
          "${aws_s3_bucket.nextcloud_s3_datastore.arn}",
          "${aws_s3_bucket.nextcloud_s3_datastore.arn}/*" 
        ],
      "Principal": {
        "AWS": [
            "${data.aws_caller_identity.current.arn}"
        ]
      }
    }
  ]

}
S3_POLICY
}

resource "aws_s3_bucket_website_configuration" "s3_website_hosting" {
  bucket = "arans3"

  index_document {
    suffix = "index.html"
  }
}

###########Aqui Joan!###################

resource "aws_s3_object" "S3SingleObject"{
bucket = aws_s3_bucket.nextcloud_s3_datastore.id
key = "index.html"
source = "/home/alumne01/s3cloudf/test/index.html"

}
