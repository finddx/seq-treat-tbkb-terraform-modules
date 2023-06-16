data "aws_security_group" "default" {
  name  = "default"
}

data "aws_subnet" "public_subnet" {
  filter {
    name   = "tag:Name"
    values = ["*-public-*1a"]
  }
}
