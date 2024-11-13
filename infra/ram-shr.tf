
######################################################
# Resource Access Manager
######################################################
resource "aws_ram_resource_share" "vpc_sharing_subnet" {
  name                      = "Network Infrastructure"

  tags = {
    Name = "${var.prefix}-ram-vpc"
  }
}

######################################################
# RAM Association for Sharing Subnet with OU (Sandbox)
######################################################

resource "aws_ram_principal_association" "sandbox_ou" {
  principal          = var.sandbox_ou_arn
  resource_share_arn = aws_ram_resource_share.vpc_sharing_subnet.arn
}


######################################################
# RAM Association for Public & Private Subnet
######################################################

#Fetch existing Subnets from Network Account
data "aws_subnet" "public_subnets" {
  for_each = aws_subnet.public_subnets
  id       = each.value.id
}

data "aws_subnet" "private_subnets" {
  for_each = aws_subnet.private_subnets
  id       = each.value.id
}

# Fetch Public Subnets
resource "aws_ram_resource_association" "pub_subs" {
  for_each           = data.aws_subnet.public_subnets
  resource_arn       = each.value.arn
  resource_share_arn = aws_ram_resource_share.vpc_sharing_subnet.arn
}

# Fetch Private Subnets
resource "aws_ram_resource_association" "priv_subs" {
  for_each           = data.aws_subnet.private_subnets
  resource_arn       = each.value.arn
  resource_share_arn = aws_ram_resource_share.vpc_sharing_subnet.arn
}
