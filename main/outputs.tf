output "ecr_app_repository_url" {
  value = module.ecr.repository_url
}

output "ecr_fp_repository_url" {
  value = module.ecr_fb.repository_url
}

#output "image_tags" {
#  value = module.build.image_tags
#}
