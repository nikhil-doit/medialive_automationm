
module "medialivesg" {
  source = "./module_sg"
  sg_name        = "user-service"
  sg_description = "Security group for user-service with custom ports open within VPC, and PostgreSQL publicly open"
  vpc_id      = "vpc-12345678"

  ### Note - This CIDR is to restrict where you streaming from
  ingress_cidr_blocks      = ["0.0.0.0/0"]
  ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      from_port   = 8080
      to_port     = 8090
      protocol    = "tcp"
      description = "User-service ports"
      cidr_blocks = "10.10.0.0/16"
    },
    {
      rule        = "postgresql-tcp"
      cidr_blocks = "0.0.0.0/0"
    },
  ]
}

/*
resource "aws_medialive_input" "media_input" {
  name                  = "example-input"
  input_security_groups = [aws_medialive_input_security_group.media_sg.id]
  type                  = "UDP_PUSH"

  tags = {
    ENVIRONMENT = "prod"
  }
}

resource "aws_medialive_channel" "myfirstchannel" {
  name          = "example-channel"
  channel_class = "SINGLE_PIPELINE"
  role_arn      = var.mediachannel_role

  input_specification {
    codec            = "AVC"
    input_resolution = "HD"
    maximum_bitrate  = "MAX_20_MBPS"
  }

  input_attachments {
    input_attachment_name = "example-input"
    input_id              = aws_medialive_input.media_input.id

  }

  destinations {
    id = "destination"

    settings {
      #url = "s3://${aws_s3_bucket.main.id}/test1"

    }

    #settings {
    #  url = "s3://${aws_s3_bucket.main2.id}/test2"
    #}
  }

  encoder_settings {
    timecode_config {
      source = "EMBEDDED"
    }

    audio_descriptions {
      audio_selector_name = "example audio selector"
      name                = "audio-selector"
    }

    video_descriptions {
      name = "example-video"
    }

    output_groups {
      output_group_settings {
        archive_group_settings {
          destination {
            destination_ref_id = "destination"
          }
        }
      }

      outputs {
        output_name             = "example-name"
        video_description_name  = "example-video"
        audio_description_names = ["audio-selector"]
        output_settings {
          archive_output_settings {
            name_modifier = "_1"
            extension     = "m2ts"
            container_settings {
              m2ts_settings {
                audio_buffer_model = "ATSC"
                buffer_model       = "MULTIPLEX"
                rate_mode          = "CBR"
              }
            }
          }
        }
      }
    }
  }
}

*/