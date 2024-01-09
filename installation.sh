#!/bin/bash
sudo apt-get install -y apt-transport-https ca-certificates curl gpg
sudo mkdir /etc/apt/keyrings
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.29/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo 'deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.29/deb/ /' | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt-get update
sudo apt-get install -y kubelet kubeadm kubectl
sudo apt-mark hold kubelet kubeadm kubectl



sudo apt-get install apt-transport-https
sudo apt install -y docker.io
sudo systemctl start docker
sudo systemctl enable docker
sudo apt-get install -y kubelet kubeadm kubectl kubernates-cni
sudo swapoff -a


#initialize
sudo kubeadmn init

kubeadm token create --print-join-command

kubeadm join 192.168.1.21:6443 --token tvhvap.sbto4zfcgqq16sn9 \
        --discovery-token-ca-cert-hash sha256:1e1718a1df3e7bc6923d77fe77fe1a20855fe211e1db2df84867cd09a0e79def
kubeadm join 192.168.1.22:6443 --token bqb2xj.kbdwyc101599ej77 \
        --discovery-token-ca-cert-hash sha256:694a2eaa90a48728fd609e08ba88a95c7d92fdd825cea371318fb6481309f0bc

kubectl version --clinet

# to view the config
kubectl config view


#Multiple cluster config:
kubectl config --kubeconfig=configdemo set-cluster kubernetes --server=https://1.2.3.4 --certificate-authority=ca.crt
kubectl config --kubeconfig=configdemo set-cluster testing --server=https://5.6.7.8 --insecure-skip-tls-verify

#adding user
kubectl config --kubeconfig=configdemo set-credentials kubernetes-admin --client-certificate=ca.cert --client-key=ca.key
kubectl config --kubeconfig=configdemo set-context kubernetes-admin@kubernetes --cluster=kubernetes --namespace=frontend --user=kubernetes-admin

kubectl config --kubeconfig=configdemo view


kubectl config --kubeconfig=configdemo use-context kubernetes-admin@kubernetes



#Get the credential to use kubernetes api using rest http client

kubectl describe secret
APISERVER=$(kubectl config view --minify | grep server | cut -f 2- -d':' | tr -d " ")
SECRET_NAME=$(kubectl get secrets | grep ^default | cut -f1 -d' ')
TOKEN=$(kubectl describe secret $SECRETE_NAME | grep -E '^token' | cut -f2 -d':' | tr -d" ")
curl $APISERVER/api --header "Authorization: Bearer $TOKEN" --insecure


#proxy mode kubectl (always uses stored api server location)
kubectl proxy --port=8080 
