exec > >(tee -i terminal-gcloud.log) 2>&1
set -x

echo "Build the webservice image with the defined Containerfile..."
podman build -t gcloud-img -f=Containerfile-gcloud .

echo "\nCreate and start the gcloud-container..."

#Source to mount credentials of gcloud automatically https://stackoverflow.com/questions/57137863/set-google-application-credentials-in-docker
# https://cloud.google.com/run/docs/testing/local?hl=de#docker-with-google-cloud-access_1
#because of a warning i set this platform flag https://stackoverflow.com/questions/66662820/m1-docker-preview-and-keycloak-images-platform-linux-amd64-does-not-match-th
podman run -d --platform linux/amd64 \
   -v /Users/men/gcloud/credentials.json:/tmp/keys/credentials.json:ro \
   -e GOOGLE_APPLICATION_CREDENTIALS=/tmp/keys/credentials.json \
   --name=gcloud-container gcloud-img

echo "\n\nShow running containers..."
podman ps -a

#I needed to configure my account and project in the google CLI after starting container so for executing commands in my running container i found this in the podman docs https://docs.redhat.com/en/documentation/red_hat_enterprise_linux/8/html/building_running_and_managing_containers/assembly_working-with-containers_building-running-and-managing-containers#proc_executing-commands-inside-a-running-container_assembly_working-with-containers
#To configure the config to edit the right project with the right account used these docs https://cloud.google.com/sdk/docs/configurations?hl=de
podman exec -it gcloud-container gcloud config set account devops-university@capable-sphinx-442212-k8.iam.gserviceaccount.com
podman exec -it gcloud-container gcloud config set project capable-sphinx-442212-k8

echo "\n\nShow that account is active and ressources can be created..."
podman exec -it gcloud-container gcloud auth list

# I thought its easy to create buckets so i decided to do that for this testcase. I decided to use gcloud commands and modified them for my requiered tasks
# https://cloud.google.com/storage/docs/creating-buckets?hl=de#command-line
echo "\n\nTest creation of resources..."
podman exec -it gcloud-container gcloud storage buckets create gs://my-devops-test-bucket-bht
podman exec -it gcloud-container gcloud storage buckets list
podman exec -it gcloud-container gcloud storage buckets delete gs://my-devops-test-bucket-bht


#to automate shut down of webservice container https://stackoverflow.com/a/45253682/20470359
echo "\n\nStop webservice-container and remove the container..."
podman rm -f gcloud-container || true
