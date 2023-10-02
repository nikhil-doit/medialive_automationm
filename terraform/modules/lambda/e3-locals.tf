locals {
  vpc = {
    "eu-west-1" = {
      "default" = {
        "id"             = "vpc-9c8441f8"
        "subnet-default" = "subnet-0424a8ca92664697d"
        "sg-default"     = "sg-6e11bf09"
        "sg-rds-pg"      = "sg-06ea664e349d83a83"
      }
    }
  }

  efs = {
    "etl" = {
      "efs_local_mount_path" = "/mnt/shared-etl"
      "efs_access_point_arn" = "arn:aws:elasticfilesystem:eu-west-1:329205314638:access-point/fsap-0f323b6595ea8e239"
    }
    "sftp" = {
      "efs_local_mount_path" = "/mnt/shared-sftp"
      "efs_access_point_arn" = "arn:aws:elasticfilesystem:eu-west-1:329205314638:access-point/fsap-039cc818a01694f40"
    }
  }

  slack = {
    "arn" = "arn:aws:lambda:eu-west-1:329205314638:function:slack-notification"
  }
}