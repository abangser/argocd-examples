To recreate demo...
1. Run minikube (`minikube start --driver=hyperkit`)

1. Create an ArgoCD namespace
    ```bash
    kubectl create namespace argocd
    ```

1. Install argocd in k8s
    ```bash
    kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
    ```

1. Install argocd CLI
    ```bash
    brew tap argoproj/tap
    brew install argoproj/tap/argocd
    ```

1. Port-forward argocd server
    ```bash
    kubectl -n argocd port-forward svc/argocd-server 8080:443
    ```

1. Login
    ```bash
    argocd login 127.0.0.1:8080 --username admin --password <POD_NAME>
    ```

1. Add Abby's public git repo:
    ```bash
    argocd repo add https://github.com/abangser/argocd-examples.git
    ```

1. Clone repo:
    ```bash
    git clone git@github.com:abangser/argocd-example.git
   ```

1. Manually apply the two application resources:
    ```bash
    kubectl apply -f app-helm.yaml -f app-kustomize-sed-deployment.yaml -f app-kustomize-sed-kustomization.yaml -f app-kustomize-set-image-cli.yaml
    ```

1. Load local ArgoUI at https://127.0.0.1:8080/applications

Expected state: We want Argo to update the deployment to use the newly created image tag based on the current commit.

**Solution 4: Repackage our application using Helm 3 and feed a parameter override via the Argo application *(argo-helm.yaml)***
    Helm will be in a healthy state but the kustomize apps will not be as they have not had their "post commit" changes done yet.

> NOTE: *To reset either solution 1 or 2 for review, change the image tag in the kustomize base directories to not contain a valid commit hash and re-comment out the jobs in CircleCI.*

