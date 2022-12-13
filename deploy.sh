# Provisioning VPC, ALB, ECS, so on
terraform -chdir=main init
terraform -chdir=main plan  -out main.planout
terraform -chdir=main apply -auto-approve main.planout
rm main/main.planout

# Provisioning application - userapi
terraform -chdir=services/userapi init
terraform -chdir=services/userapi plan  -out userapi.planout
terraform -chdir=services/userapi apply -auto-approve userapi.planout
rm services/userapi/userapi.planout

# Provisioning application - hello
# terraform -chdir=services/helloapi init
# terraform -chdir=services/helloapi plan  -out helloapi.planout
# terraform -chdir=services/helloapi apply -auto-approve helloapi.planout
