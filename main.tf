#Create s3 bucket
resource "aws_s3_bucket" "mybucket" {
  bucket = var.bucketName
 
}

#Ownership control 

resource "aws_s3_bucket_ownership_controls" "example" {
  bucket = aws_s3_bucket.mybucket.id

  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

#Make the bucket public available

resource "aws_s3_bucket_public_access_block" "example" {
  bucket = aws_s3_bucket.mybucket.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

#configure ACL 

resource "aws_s3_bucket_acl" "example" {
  depends_on = [
    aws_s3_bucket_ownership_controls.example,
    aws_s3_bucket_public_access_block.example,
  ]

  bucket = aws_s3_bucket.mybucket.id
  acl    = "public-read"
}



#recursive file upload to s3 without using modules 

locals{
  upload_directory = "${path.cwd}/codeBase/"
}

resource "aws_s3_object" "website_files" {
  for_each      = fileset(local.upload_directory, "**/*.*")
  bucket        = aws_s3_bucket.mybucket.id
  key           = replace(each.value, local.upload_directory, "")
  source        = "${local.upload_directory}${each.value}"
  acl           = "public-read"
  etag          = filemd5("${local.upload_directory}${each.value}")
  content_type  = lookup(var.mime_types, split(".", each.value)[length(split(".", each.value)) - 1])
}

#Website_configuration

resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.mybucket.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }

  depends_on = [ aws_s3_bucket_acl.example ]

}

