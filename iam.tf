resource "aws_iam_role_policy" "ec2-policy" {
  name = "ec2-policy"
  role = aws_iam_role.ec2-role.id
  policy = "${file("IAM/ec2-policy.json")}"
}

resource "aws_iam_role" "ec2-role" {
  name = "terraform-aws-ec2-role"
  assume_role_policy = "${file("IAM/ec2-assume-policy.json")}"
}

resource "aws_iam_instance_profile" "ec2_profile" {
    name = "ec2-role_profile"
    role = aws_iam_role.ec2-role.id
}