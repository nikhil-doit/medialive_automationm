resource "aws_medialive_input_security_group" "my_medialive_sg" {
  whitelist_rules {
    cidr = "0.0.0.0/0"
  }

  tags = {
    name = "my_medialive_sg"
    environment = "test"
  }
}

resource "aws_medialive_input" "test_inputs" {
  count = 2
  name              = element(var.input_names, count.index )
  input_security_groups = [aws_medialive_input_security_group.my_medialive_sg.id]
  type                  = "UDP_PUSH"

  tags = {
    name = "medialive_input_1"
    environment = "test"
  }
}

