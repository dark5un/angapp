output "angapp_ecr_name" {
  value =  module.ecr_angapp.ecr_name
}
output "angapp_ecr_id" {
  value = module.ecr_angapp.ecr_id
}
output "angapp_ecr_url" {
  value = module.ecr_angapp.ecr_url
}

output "nginx_ecr_name" {
  value =  module.ecr_nginx.ecr_name
}
output "nginx_ecr_id" {
  value = module.ecr_nginx.ecr_id
}
output "nginx_ecr_url" {
  value = module.ecr_nginx.ecr_url
}