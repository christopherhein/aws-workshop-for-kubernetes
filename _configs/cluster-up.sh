# THIS SCRIPT DOESN'T RUN BY ITSELF
# Copy and paste these commands for now. we can make it better overtime

export AWS_DEFAULT_REGION=us-east-1
export NAME=k8sworkshop.com
export BUCKET_NAME=state-store.${NAME}
export KOPS_STATE_STORE=s3://${BUCKET_NAME}
export AWS_DEFAULT_REGION=us-east-1
export ZONES=${AWS_DEFAULT_REGION}a,${AWS_DEFAULT_REGION},${AWS_DEFAULT_REGION}c

aws s3api create-bucket --bucket ${BUCKET_NAME} \
    --region ${AWS_DEFAULT_REGION}

aws s3api put-bucket-versioning --bucket ${BUCKET_NAME} \
    --versioning-configuration Status=Enabled

kops create cluster --zones ${ZONES} \
     --master-zones ${ZONES} \
     --dns public \
     --cloud-labels Team=k8s-on-aws-workshop \ 
     --dns-zone ZK3I7PWNMB09J \ 
     --encrypt-etcd-storage \
     --master-count 3 \
     --master-tenancy dedicated \
     --node-count 3 \
     --ssh-public-key /Users/heichris/.ssh/k8s_workshop_rsa.pub \
     --name ${NAME} \
     --yes

kops validate cluster --name ${NAME}

# Configure authenticator per https://aws.amazon.com/blogs/opensource/deploying-heptio-authenticator-kops/

kubectl apply -f _configs/cluster/namespaces.yaml

kubectl apply -f _configs/cluster/helm/

helm init --service-account tiller --tiller-namespace kube-admin

helm install stable/nginx-ingress \
     -f _configs/cluster/ingress/values.yaml \
     --name nginx-ingress \
     --tiller-namespace kube-system \
     --namespace kube-admin

helm install stable/nginx-ingress \
     -f _configs/cluster/ingress/values.yaml \
     --name nginx-ingress \
     --tiller-namespace kube-system \
     --namespace kube-admin