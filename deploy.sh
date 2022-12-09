terraform -chdir=main init
terraform -chdir=main plan  -out main.planout
terraform -chdir=main apply -auto-approve main.planout
rm main/main.planout

terraform -chdir=services/userapi init
terraform -chdir=services/userapi plan  -out userapi.planout
terraform -chdir=services/userapi apply -auto-approve userapi.planout
rm services/userapp/userapi.planout
