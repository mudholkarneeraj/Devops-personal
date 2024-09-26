1. kubectl get pods -n prod-worker -l app=api -o jsonpath='{.items[*].metadata.name}' | xargs -n 1 kubectl logs -n prod-worker | grep -i "Exception occurred while hitting Amplitude for request:"
2. kubectl config set-context --current --namespace=kube-system
3. kubectl --namespace monitoring port-forward $POD_NAME 3000
4. 
