To recreate demo...
1. Run minikube (`minikube start --driver=hyperkit`)
2. Follow instructions from the [ArgoCD Spike](https://www.notion.so/duffel/ArgoCD-Spike-ff4795979aa64274a22027b80ea4be99) up to and including login
3. Add Abby's public git repo:
```
argocd repo add https://github.com/abangser/argocd-examples.git
```
4. Clone repo: `git clone git@github.com:abangser/argocd-example.git`
5. Manually apply the two application resources:
```
kubectl apply -f app-helm.yaml -f app-kustomize.yaml
```
6. Load local ArgoUI at https://127.0.0.1:8080/applications
