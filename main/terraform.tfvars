context = {
  region      = "ap-southeast-1"
  project     = "symple"
  environment = "Development"
  owner       = "ops@sympleops.ml"
  team        = "DevOps"
  cost_center = "202076"
  domain      = "sympleops.ml"
  pri_domain  = "sympleops.local"
}

app_name = "userapi"

source_location              = "https://github.com/chiwoo-cloud-native/userapi-fluentbit-demo.git"
source_token_parameter_store = "/symple/github/token"
