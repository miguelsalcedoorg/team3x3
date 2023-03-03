resource "aws_cloudformation_stack" "Team3" {
  name = "Team3"
  parameters = {
    VpcId = aws_vpc.this.id
  }
  template_body = file("${path.module}/cloudformation.json")
}
 