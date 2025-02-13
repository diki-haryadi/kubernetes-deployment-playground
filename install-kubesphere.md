Ah, we need to install the Custom Resource Definitions (CRDs) first. Let's do this step by step:

1. First, apply the KubeSphere installer which contains the necessary CRDs:
```bash
kubectl apply -f https://github.com/kubesphere/ks-installer/releases/download/v3.4.0/kubesphere-installer.yaml
```

2. Wait a few seconds for the CRD to be registered, then verify it's installed:
```bash
kubectl get crd | grep kubesphere
```

3. Now we can apply the ClusterConfiguration:
```bash
cat <<EOF | kubectl apply -f -
apiVersion: installer.kubesphere.io/v1alpha1
kind: ClusterConfiguration
metadata:
  name: ks-installer
  namespace: kubesphere-system
  labels:
    version: v3.4.0
spec:
  persistence:
    storageClass: ""
  authentication:
    jwtSecret: ""
  local_registry: ""
  etcd:
    monitoring: false
    endpointIps: localhost
    port: 2379
    tlsEnable: true
  common:
    redis:
      enabled: true
      volumeSize: 2Gi
    openldap:
      enabled: false
    es:
      enabled: false
  logging:
    enabled: false
  events:
    enabled: false
  auditing:
    enabled: false
  devops:
    enabled: false
  servicemesh:
    enabled: false
  notification:
    enabled: false
  openpitrix:
    store:
      enabled: false
EOF
```

The error occurred because we tried to create a custom resource before its definition was installed. Let's apply these commands in order and monitor the progress.

Let's check the installation progress:

1. First, verify the installer pod is running:
```bash
kubectl get pods -n kubesphere-system
```

2. Watch the installer logs:
```bash
kubectl logs -n kubesphere-system $(kubectl get pod -n kubesphere-system -l app=ks-installer -o jsonpath='{.items[0].metadata.name}') -f
```

3. Monitor for new components being created:
```bash
kubectl get all -n kubesphere-system
```

Once the installation is complete, we should see several components:
- ks-console
- ks-apiserver
- ks-controller-manager

When these are running, we can get the console access details:
```bash
kubectl get svc/ks-console -n kubesphere-system
```

Would you like me to help analyze the logs or current status to see where we are in the installation process?

Let's check the KubeSphere web console access:

1. Get the console service details:
```bash
kubectl get svc/ks-console -n kubesphere-system
```

2. Get all services to see what's available:
```bash
kubectl get svc -n kubesphere-system
```

The default access credentials for KubeSphere are:
- Username: `admin`
- Password: `P@88w0rd`

If the console service is running, you can access it at:
- If running locally: `http://localhost:<NodePort>`
- If running on a remote machine: `http://<node-ip>:<NodePort>`

Would you like me to help check if the console service is ready and get its access URL?
