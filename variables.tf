variable "AWS_ACCESS_KEY_ID" {
  description = "AWS Access Key ID"
}

variable "AWS_SECRET_ACCESS_KEY" {
  description = "AWS Secret Access Key"
}


variable "vpc_id" {
  default = "vpc-0368dc1afbe9b7ffb"
}

variable "input_names" {
  description = "Medialive input"
  type        = list
  default     = ["test_input1","test_input_2","test_input_3"]
}



 variable "resource_group_name" {
  description = "Default resource group name that the network will be created in."
  type        = list
  default     = ["asd-rg","asd2-rg"]

}

variable "sgw_mtype" {
  default = "m5.xlarge"
}

variable "sgw_ebs" {
  default = "200"
}

variable "ebs_type" {
  default = "gp3"
}

#variable "swg_allow" {
#  default = ["0.0.0.0/0", "1.2.3.4/32"]
#}

# mediallive variables
variable "mediachannel_role" {
  default      = "medialive_channel_role"
}
