# Deploy ArgoCD on EKS

this demo I will install argocd on EKS and using an ALB for users to access


## Usage

- add argocd helm repo
```shell
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update
```

- Install argocd
```shell
helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --set server.service.type=ClusterIP

```
- You can also download the argocd helm charts locally and install locally
```shell
helm pull argo/argo-cd --version 7.3.11 --untar

helm-install-argocd % helm upgrade --install argocd ./argo-cd \
  --namespace argocd \
  --create-namespace \
  --set server.service.type=ClusterIP \
  --timeout 10m

```
- check the argocd pods status 
```shell
terraform-aws-modules % kubectl get pods -n argocd 
NAME                                                READY   STATUS      RESTARTS   AGE
argocd-application-controller-0                     1/1     Running     0          3m24s
argocd-applicationset-controller-69f78d976c-qqdqz   1/1     Running     0          3m40s
argocd-dex-server-8597875b74-w5cgw                  1/1     Running     0          3m27s
argocd-notifications-controller-7498484cdc-pbqbf    1/1     Running     0          3m37s
argocd-redis-5846749747-x2wgw                       1/1     Running     0          3m26s
argocd-redis-secret-init-qbmsp                      0/1     Completed   0          4m45s
argocd-repo-server-794c7579db-f8764                 1/1     Running     0          3m35s
argocd-server-84d845dc86-n4ls7                      1/1     Running     0          3m31s
allen@192 terraform-aws-modules % 
```

- prepare argocd-ingress.yaml file if you want an alb for access
```shell
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-ingress
  namespace: argocd
  annotations:
    kubernetes.io/ingress.class: "alb"
    alb.ingress.kubernetes.io/scheme: "internet-facing"
    alb.ingress.kubernetes.io/target-type: "ip"
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTP": 80}]'
    alb.ingress.kubernetes.io/backend-protocol: "HTTP"
    
    alb.ingress.kubernetes.io/target-group-attributes: stickiness.enabled=true,stickiness.lb_cookie.duration_seconds=86400
    
    alb.ingress.kubernetes.io/healthcheck-path: "/healthz"
    alb.ingress.kubernetes.io/healthcheck-protocol: "HTTP"
spec:
  ingressClassName: alb
  rules:
  - http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: argocd-server
            port:
              number: 80

```
- Since Argocd use the HTTPS by default, You have to give on a patch if you don't have a TLS cert 
- if you want allow HTTP to forward and HTTP open in browser when you don't have a TLS cert
```shell
kubectl patch deployment argocd-server -n argocd --type json -p='[{"op": "add", "path": "/spec/template/spec/containers/0/args/-", "value": "--insecure"}]'

```
- If you have a TLS cert from AWS ACM then use it on alb-ingress.yaml and you will have a HTTPS access

```shell
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: argocd-server-ingress
  namespace: argocd
  annotations:
    kubernetes.io/ingress.class: "alb"
    alb.ingress.kubernetes.io/scheme: "internet-facing"
    alb.ingress.kubernetes.io/target-type: "ip"
    # 1. 监听 443 端口并启用 HTTPS
    alb.ingress.kubernetes.io/listen-ports: '[{"HTTPS": 443}, {"HTTP": 80}]'
    # 2. 绑定你在 AWS ACM 中的证书 ARN（必填）
    alb.ingress.kubernetes.io/certificate-arn: "arn:aws:acm:region:account-id:certificate/your-cert-id"
    # 3. （可选）如果想把 HTTP 自动重定向到 HTTPS
    alb.ingress.kubernetes.io/actions.ssl-redirect: '{"Type": "redirect", "RedirectConfig": { "Protocol": "HTTPS", "Port": "443", "StatusCode": "HTTP_301"}}'
    
    alb.ingress.kubernetes.io/backend-protocol: "HTTP"
    alb.ingress.kubernetes.io/target-group-attributes: stickiness.enabled=true,stickiness.lb_cookie.duration_seconds=86400
    alb.ingress.kubernetes.io/healthcheck-path: "/healthz"
    alb.ingress.kubernetes.io/healthcheck-protocol: "HTTP"
spec:
  ingressClassName: alb
  rules:
  - host: argocd.example.com  
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: argocd-server
            port:
              number: 80

```




- create the ingress for argo-cd
```shell
kubectl apply -f argocd-ingress.yaml
```
- check the argocd ingress
```shell
kubectl get ingress -A

NAMESPACE   NAME                    CLASS   HOSTS   ADDRESS                                                                  PORTS   AGE
argocd      argocd-server-ingress   alb     *       k8s-argocd-argocdse-4f91bb4331-971921017.us-east-1.elb.amazonaws.com     80      89m
default     web-frontend-ingress    alb     *       k8s-default-webfront-3919819655-1446531995.us-east-1.elb.amazonaws.com   80      19h

```
- if you want to check more details when debug the ingress
```shell
kubectl describe ingress argocd-server-ingress -n argocd

```

- if you want to restart the argocd server deployment pods using the following command
```shell
kubectl rollout restart deployment argocd-server -n argocd

```








