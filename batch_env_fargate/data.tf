data "aws_security_group" "default" {
  filter {
    name  =  "tag:Name"
    values = ["*-allow-outbound"]
  }
}

data "aws_subnet" "private_subnet" {
  filter {
    name   = "tag:Name"
    values = ["*-private-*1a"]
  }
}
