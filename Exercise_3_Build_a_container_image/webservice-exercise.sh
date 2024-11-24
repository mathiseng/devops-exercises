exec > >(tee -i terminal-webservice.log) 2>&1
set -x

#i used the podman docs for information about containerfiles and build process https://docs.podman.io/en/v2.2.1/markdown/podman-build.1.html
echo "Build the webservice image with the defined Containerfile..."
podman build -t webservice -f=Containerfile-webservice .

#source https://podman.io/docs#running-a-container
echo "\nCreate and start the webservice-container..."
podman run -d -p 8080:3000 --name=webservice-container webservice

echo "\nSending request..."
curl http://localhost:8080

echo "\n\nShow running containers..."
podman ps -a

#to automate shut down of webservice container https://stackoverflow.com/a/45253682/20470359
echo "\n\nStop webservice-container and remove the container..."
podman rm -f webservice-container || true
