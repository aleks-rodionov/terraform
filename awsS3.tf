resource "aws_s3_bucket" "import_file_store" {
  bucket = var.bucket_name
  acl    = "private"

  tags = {
    Name        = "Source"
    Environment = "GCP"
  }
}
