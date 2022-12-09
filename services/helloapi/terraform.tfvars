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

app_name = "helloapi"
cpu      = 256
memory   = 512
port     = 80

source_location              = "https://github.com/chiwoo-cloud-native/userapi-fluentbit-ecs.git"
source_token_parameter_store = "/symple/github/token"
