1. kubectl get pods -n prod-worker -l app=api -o jsonpath='{.items[*].metadata.name}' | xargs -n 1 kubectl logs -n prod-worker | grep -i "Exception occurred while hitting Amplitude for request:"
2. kubectl config set-context --current --namespace=kube-system
3. kubectl --namespace monitoring port-forward $POD_NAME 3000
4. 
$ kubectl -n kube-system run my-shell --rm -i --tty --image ubuntu:latest -- /bin/bash
$ kubectl run -n staging -i --tty load-generator-3 --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://api-service:5000/healthCheck; done"