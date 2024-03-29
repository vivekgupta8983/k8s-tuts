# k8s-tuts


## Installing the AWS Load Balancer Controller add-on

1. Create IAM Policy

```curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json```

```aws iam create-policy --policy-name AWSLoadBalancerControllerIAMPolicy --policy-document file://iam-policy.json```


2. Create IAM Role

```eksctl create iamserviceaccount --cluster=devcloudgeek-1-27  --namespace=kube-system  --name=aws-load-balancer-controller  --role-name AmazonEKSLoadBalancerControllerRole  --attach-policy-arn=arn:aws:iam::534748744050:policy/AWSLoadBalancerControllerIAMPolicy --approve```

3. Install the AWS Load Balancer Controller using Helm V3
   
   https://docs.aws.amazon.com/eks/latest/userguide/helm.html

   a. Add the eks-charts repository.
        
        helm repo add eks https://aws.github.io/eks-charts

    b. Update your local repo to make sure that you have the most recent charts.

         helm repo update eks

    c. Install ALB Controller

        helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n kube-system --set clusterName=devcloudgeek-1-27  --set serviceAccount.create=false --set serviceAccount.name=aws-load-balancer-controller


## Install Promethues and Grafana

Step 1: Add repositories
     Add the following helm repositories by the commands below.

     helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
     helm repo add stable https://charts.helm.sh/stable
     helm repo update

Step 2: Install Prometheus

      helm install prometheus prometheus-community/kube-prometheus-stack

       kubectl port-forward deployment/prometheus-grafana 3000


          username: admin
          password: prom-operator


