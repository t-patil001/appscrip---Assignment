A) steps to provision the cluster

1) to run above yamls file we will use commands:
terraform init
terraform apply
 & This will - Set up a VPC, Provision the EKS cluster, Output your kubeconfig

2) note- here i have used module source-"terraform-aws-modules/vpc/aws".
So, it is a Terraform module published by the community (specifically by the Terraform AWS Modules team), and it's available on the Terraform Registry. 
And by using it, Terraform will--Download the module from the registry (on terraform init), Use the code inside it (which defines all AWS VPC-related resources), Allow us to configure the module using inputs like name, cidr, public_subnets, etc.
  
B) Deploy an NGINX Application using Kubernetes Manifests
 
1) We will Apply the Manifests
 so i'm doing it by Manual Deployment via kubectl(i can use it by ArgoCD as well but before i have to istall it and 3rd task include ArgoCD so here i'm deploying manually via kubectl)
 So, command is - 
kubectl apply -f manifests/nginx-deployment.yaml
kubectl apply -f manifests/nginx-service.yaml

2) Then to check:
kubectl get pods
kubectl get svc

3) or for service to Access via:
kubectl get nodes -o wide  
Then open in browser: http://<NODE_IP>:30080

C) ArgoCD login Instruction
 first, i'll create namespace
1) kubectl create namespace argocd
Then I'll  apply the official ArgoCD manifests:
2) kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

3) to Expose ArgoCD Server(post-forward)
kubectl port-forward svc/argocd-server -n argocd 8080:443
 Then open: https://localhost:8080

4) to get ArgoCD Admin Password
kubectl get secret argocd-initial-admin-secret -n argocd -o jsonpath="{.data.password}" | base64 -d && echo
By default, ArgoCD sets the admin password as the name of a secret

5) now to crete ArgoCD application, we already have nginx-app.yaml file inside manifest directory 
so we will apply by command :
kubectl apply -f argocd/nginx-app.yaml -n argocd
Then go to the ArgoCD UI and sync the app, or wait for it to sync automatically.

So, At this point, ArgoCD should be running on your EKS cluster,
and we have a UI accessible via port-forward.

D) Post Forward or Public access url for Nginx
So, we need to follow basic commands for that
1) kubectl get nodes -o wide        #Get the external IP of a worker node:
2) kubectl get svc nginx-service    # Get the service’s NodePort
 we'll see something like
 PORT(S): 80:30080/TCP
4) Access it using:
http://<NODE_IP>:<NODE_PORT>     

E) Ingress Domain details:
1) for that first we need to install NGINX Ingress Controller
so the command is:
 kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.10.1/deploy/static/provider/aws/deploy.yaml

then we'll wait for the controller pod to be ready
we can check it by:
kubectl get pods -n ingress-nginx

& to get the external IP:
kubectl get svc ingress-nginx-controller -n ingress-nginx

& we have nginx-ingress.yaml so we will apply it:
kubectl apply -f manifests/nginx-ingress.yaml

2) to Map Custom Domain
 fist we'll get the Ingress controller external IP:
command - kubectl get svc ingress-nginx-controller -n ingress-nginx

and then in route53(AWS) we will create A record and our domain mapping is successfull





