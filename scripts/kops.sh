#!/bin/bash
ssh-keygen
sudo apt install curl unzip
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
aws configure
chmod +x kubectl
sudo mv kubectl /usr/local/bin/
kubectl --help
wget https://github.com/kubernetes/kops/releases/download/v1.28.5/kops-linux-amd64
chmod +x kops-linux-amd64
sudo mv kops-linux-amd64 /usr/local/bin/kops
kops

## Error in below 
## because of hosted zones
kops create cluster --name=kubevpro.groophy.in --state=s3://k8s-practice-udemy --zones=ap-south-1a,ap-south-1b --node-count=2 --node-size=t3.small --master-size=t3.medium --node-volume-size=8 --master-volume-size=8

kops update cluster --name kubevpro.groophy.in --state=s3://k8s-practice-udemy --yes --admin

kops validate cluster --state=s3://k8s-practice-udemy

cat ~/.kube/config

kubectl get nodes

# To delete the cluster
kops delete cluster --name=kubevpro.groophy.in --state=s3://k8s-practice-udemy --yes
