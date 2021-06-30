echo "Installing docker and its components\n"
sudo apt-get remove docker docker-engine docker.io
sudo apt-get install -y apt-transport-https ca-certificates curl gnupg2 software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
archi=`dpkg --print-architecture`
sudo add-apt-repository \
   "deb [arch=$archi] https://mirrors.tuna.tsinghua.edu.cn/docker-ce/linux/ubuntu \
   $(lsb_release -cs) \
   stable"
sudo apt-get update
sudo apt install -y docker-ce
echo "Provisioning environment for kubernetes"
echo "----------------------------------------"
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
sudo add-apt-repository 'deb https://mirrors.tuna.tsinghua.edu.cn/kubernetes/apt kubernetes-xenial main'
curl -LO https://storage.googleapis.com/minikube/releases/latest/minikube_latest_amd64.deb
sudo apt install kubeadm
echo "Preparing virtualization environment"
sudo apt install libvirt-daemon libvirt0 libvirt-clients libvirt-bin -y
sudo chmod 777 /run/user/0/
sudo chmod 777 /run/user/0/*
sudo systemctl restart libvirtd

images=$(echo "$(kubeadm config images list)" | sed 's/k8s.gcr.io\///g')
FS=' ' read -r -a array <<< "$(echo $images)"

for imageName in "${array[@]}" ; do
  if [[ $imageName != "coredns/coredns:v1.8.0" ]]; then
   docker pull registry.aliyuncs.com/google_containers/$imageName
   docker tag registry.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
   docker rmi registry.aliyuncs.com/google_containers/$imageName
  else
   docker pull coredns/coredns:1.8.0
   docker tag coredns/coredns:1.8.0 k8s.gcr.io/coredns/coredns:v1.8.0
   docker rmi coredns/coredns:1.8.0
  fi
done

