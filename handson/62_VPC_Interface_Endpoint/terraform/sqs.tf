resource "aws_sqs_queue" "my_queue" {
  name = "my-queue"
}

output "my_queue_url" {
  value = aws_sqs_queue.my_queue.id
}