module "s3_bucket" {
  source = "terraform-aws-modules/s3-bucket/aws"

  bucket                   = var.bucket_name
  acl                      = var.acl
  tags                     = var.tags
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
}

resource "aws_s3_object" "subfolders" {
  count  = length(var.subfolder_keys)
  bucket = module.s3_bucket.s3_bucket_id
  key    = var.subfolder_keys[count.index] # Using variable to create subfolder paths
}






