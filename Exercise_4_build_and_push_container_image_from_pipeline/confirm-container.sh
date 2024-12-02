#I was able to reuse almost everything from my previous exercises , just had to rename and pull the image instead of creating an image on my own
exec > >(tee -i terminal.log) 2>&1
set -x

#Information found here https://docs.github.com/de/packages/working-with-a-github-packages-registry/working-with-the-container-registry#pulling-container-images
echo "Pull the image from GitHub"
podman pull ghcr.io/mathiseng/podman-webservice:test

#source https://podman.io/docs#running-a-container
echo "\nCreate and start the container with the pulled image..."
podman run -d -p 8080:3000 --name=webservice-container ghcr.io/mathiseng/podman-webservice:test

echo "\nSending request..."
curl http://localhost:8080

echo "\n\nShow running containers..."
podman ps -a

#to automate shut down of webservice container https://stackoverflow.com/a/45253682/20470359
echo "\n\nStop webservice-container and remove the container..."
podman rm -f webservice-container || true
