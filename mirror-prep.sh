images=(
kube-apiserver:v1.21.1
kube-controller-manager:v1.21.1
kube-scheduler:v1.21.1
kube-proxy:v1.21.1
pause:3.4.1
etcd:3.4.13-0)

for imageName in ${images[@]} ; do
  docker pull registry.aliyuncs.com/google_containers/$imageName
  docker tag registry.aliyuncs.com/google_containers/$imageName k8s.gcr.io/$imageName
  docker rmi registry.aliyuncs.com/google_containers/$imageName
done
docker pull coredns/coredns:1.8.0
docker tag coredns/coredns:1.8.0 k8s.gcr.io/coredns/coredns:v1.8.0
docker rmi coredns/coredns:v1.8.0
