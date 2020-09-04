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

Expected state: We want Argo to update the deployment to use the newly created image tag based on the current commit.

**Solution 1: On each merge, generate an auto-merged commit to update the commit SHA in the deployment file *(argo-kustomize-sed-deployment.yaml)***
    This is best visualised from scratch. You can see the [initial value is set to a dud tag](kustomize-sed-deployment/base/deployment.yml:19). This will need to be replaced with the git commit SHA. To see this in action, uncomment the [sed-patch-kustomize-deployment-image-tag](.circleci/config.yml:50) which will both enable the job in the CircleCI pipeline that runs the sed and commit commands. This is idempotent and once enabled will work for all additional pipeline runs. If you were to re-comment this out and continue running the pipeline it will continue to appear healthy as long as the docker image built for the last updated commit hash exists, but that is an example of how this can become a confusing solution.

**Solution 2: On each merge, generate an auto-merged commit to update the commit SHA in the deployment file *(argo-kustomize-sed.yaml)***
    This is realised in much the same way as solution one. The CircleCI job is and the ["dud tag" is in the kustomize file](kustomize-sed/base/kustomization.yml:8) which means [the deployment does not need any confusing "dud" tags](kustomize-sed/base/deployment.yml:19). Something to note is that this solution looks very much the same as solution 1 given the argo application and deployment are in the same repo. If we were to store the Argo application in a different repo the real difference shines because the commit history is cleaner and the commit used does not need to be "previous".

**Solution 3: Run an ArgoCD CLI command to override the image value**
Helm will be in a healthy state but the kustomize apps will not be as they have not had their "post commit" changes done yet.

**Solution 4: Repackage our application using Helm 3 and feed a parameter override via the Argo application *(argo-helm.yaml)***

> NOTE: *To reset either solution 1 or 2 for review, change the image tag in the kustomize base directories to not contain a valid commit hash and re-comment out the jobs in CircleCI.*

