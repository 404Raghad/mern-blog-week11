output "ec2_public_ip" {
  value = aws_instance.backend.public_ip
}

output "frontend_bucket_url" {
  value = "http://${var.frontend_bucket}.s3-website.${var.aws_region}.amazonaws.com"
}