#s3 bucket backend

resource "aws_s3_bucket" "ba-s3-backend" {
  bucket = "ba-s3-backend"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = {
    Name        = "ba_s3-backend"
    Environment = "Dev"
  }
}



# dynamodb table for backend

resource "aws_dynamodb_table" "ba-statelock" {
  name         = "state-lock"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }
}
