To recreate demo...
1. Run minikube
2. Follow instructions for setting up ArgoCD up to and including login
3. Add Abby's public git repo:
```
argocd repo add git@github.com:abangser/argocd-example.git --ssh-private-key-path ??
```
4. Clone repo: `git clone git@github.com:abangser/argocd-example.git`
5. Manually apply the two application resources:
```
kubectl apply -f app-helm.yaml -f app-kustomize.yaml
```
6. Load local ArgoUI at https://127.0.0.1:8080/applications
