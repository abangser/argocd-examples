To recreate demo...
1. Run minikube (`minikube start --driver=hyperkit`)

1. Create an ArgoCD namespace
    ```bash
    kubectl create namespace argocd
    ```

1. Install argocd in k8s
    ```bash
    kubectl apply -n argocd -f [https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml](https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml)
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
    kubectl apply -f app-helm.yaml -f app-kustomize.yaml
    ```

1. Load local ArgoUI at https://127.0.0.1:8080/applications

Expected state:
Helm will be in a healthy state but the kustomize apps will not be as they have not had their "post commit" changes done yet.

To fix this, uncomment the [sed-patch-kustomize-image-tag job](.circleci/config.yml:74) which will both enable the job in the CircleCI pipeline necessary to patch the kustomize app, but also force the pipeline to run (given it is a committe change).

To reset this for review, change the image tag in the kustomize base directories to not contain a valid commit hash and recomment out the sed-patch-kustomize-image-tag job in CircleCI.
