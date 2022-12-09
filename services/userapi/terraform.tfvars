context = {
  region      = "ap-southeast-1"
  project     = "symple"
  environment = "Development"
  owner       = "ops@sympleops.ml"
  team        = "DevOps"
  cost_center = "7676"
  domain      = "sympleops.ml"
  pri_domain  = "sympleops.local"
}


app_name = "userapi"
cpu      = 512
memory   = 1024
port     = 8080

fluent_bit_image = "fluentbit-ecr:latest"
source_location              = "https://github.com/chiwoo-cloud-native/userapi-fluentbit-demo.git"
source_token_parameter_store = "/symple/github/token"
