output "glue_database_name" {
  value       = try({ for k, v in aws_glue_catalog_database.this : k => v.name })
}

output "glue_classifier_name" {
  value = try({ for k, v in aws_glue_classifier.this : k => v.name })
}

output "glue_connection_name" {
  value =  try({ for k, v in aws_glue_connection.this : k => v.name })
}

output "glue_job_name" {
  value =  try({ for k, v in aws_glue_job.this : k => v.name })
}