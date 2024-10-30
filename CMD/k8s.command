1. kubectl get pods -n prod-worker -l app=api -o jsonpath='{.items[*].metadata.name}' | xargs -n 1 kubectl logs -n prod-worker | grep -i "Exception occurred while hitting Amplitude for request:"
2. kubectl config set-context --current --namespace=kube-system
3. kubectl --namespace monitoring port-forward $POD_NAME 3000
4. kubectl drain --ignore-daemonsets <node_name>
5. kubectl delete node <node_name>
$ kubectl -n kube-system run my-shell --rm -i --tty --image ubuntu:latest -- /bin/bash
$ kubectl run -n staging -i --tty load-generator-3 --rm --image=busybox:1.28 --restart=Never -- /bin/sh -c "while sleep 0.01; do wget -q -O- http://api-service:5000/healthCheck; done"
kubectl get pods -n prod -l app=shopnek -o jsonpath='{.items[*].metadata.name}' | tr ' ' '\n' | xargs -I {} sh -c 'echo "Pod: {}" && kubectl logs -n prod {} | grep -i "with non-plain text contents is unsupported by type to select for accessibility"' ==> to check log in specific deployment
kubectl get nodes -o jsonpath="{range .items[*]}{.status.capacity.cpu}{'\n'}{end}" | awk '{s+=$1} END {print s}' ==> to count the cpu
kubectl get ing -A | awk '{print $1, $4}'
