resource "aws_medialive_input_security_group" "my_media_sg" {
  whitelist_rules {
    cidr = "0.0.0.0/0"
  }

  tags = {
    ENVIRONMENT = "prod"
  }
}

resource "aws_medialive_input" "example" {
  name                  = "example-input"
  input_security_groups = [aws_medialive_input_security_group.my_media_sg.id]
  type                  = "UDP_PUSH"

  tags = {
    ENVIRONMENT = "test"
  }
}