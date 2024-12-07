exec > >(tee -i terminal.log) 2>&1
set -x

echo "\n\n initialize terraform...\n"
terraform init

# for auto-approve found this https://stackoverflow.com/questions/67476870/how-to-run-terraform-apply-auto-approve-in-docker-container-using-cmd
echo "\n\n launch vm in gcloud via terraform...\n"
terraform apply -auto-approve

#Source for port forwarding https://stackoverflow.com/questions/27294267/ssh-port-forwarding-google-compute-engine
nohup gcloud compute ssh --ssh-flag="-L 8080:localhost:3000"  --zone=europe-west1-b my-devops-vm --command="chmod +x ./artifact.bin && ./artifact.bin" > artifact.log 2>&1 &

echo "\n\n Waiting for ssh connection...\n"
sleep 15

echo "\n\n Sending request...\n"
curl -s  http://localhost:8080


echo "\n\n Destroy vm in gcloud...\n"
terraform destroy -auto-approve