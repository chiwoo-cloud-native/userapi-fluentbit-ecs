terraform -chdir=services/userapi destroy -auto-approve -compact-warnings
terraform -chdir=main destroy -auto-approve -compact-warnings
