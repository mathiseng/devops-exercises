
exec > >(tee -i -a terminal.log) 2>&1
set -x

#build artifact for linux
cd ./webservice && go get -t ./... && GOARCH=amd64 GOOS=linux go build -o artifact.bin && cd ..

#copy artifact to VM
scp -P 2222 -r ./webservice/artifact.bin user1@127.0.0.1:/home/user1/

# ssh into the VM and port forward here because somehow in qemu config it didn't work for port 3000
# Tutorial source: https://phoenixnap.com/kb/ssh-port-forwarding
# For directly executing commands after connecting ssh for easier automation i used this source : https://stackoverflow.com/questions/18522647/run-ssh-and-immediately-execute-command
nohup ssh -L 8080:127.0.0.1:3000 -p 2222 user1@127.0.0.1 "./artifact.bin" > artifact.log 2>&1 &

echo "Waiting for ssh connection..."
sleep 15

echo "Sending request..."
curl -s  http://localhost:8080
#ssh -p 2222 user1@127.0.0.1
