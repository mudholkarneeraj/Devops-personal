 kubectl get pods -n prod-worker -l app=api -o jsonpath='{.items[*].metadata.name}' | xargs -n 1 kubectl logs -n prod-worker | grep -i "Exception occurred while hitting Amplitude for request:"
kubectl config set-context --current --namespace=kube-system
