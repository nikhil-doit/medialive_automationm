variable "vpc_id" {
  default = "vpc-0368dc1afbe9b7ffb"
}

#variable "sgw_ami" {
 # default = "ami-044238dc0ff5b8208"origin/mai
#}

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
