resource "aws_security_group" "redshift-serverless-security-group" {
  depends_on = [aws_vpc.redshift-serverless-vpc]

  name        = "${var.app_name}-${var.app_environment}-redshift-serverless-security-group"
  description = "${var.app_name}-${var.app_environment}-redshift-serverless-security-group"

  vpc_id = aws_vpc.redshift-serverless-vpc.id

  tags = {
    Name        = "${var.app_name}-${var.app_environment}-redshift-serverless-security-group"
    Environment = var.app_environment
  }
}