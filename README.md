# Accessing Kubernetes Applications with Colima

This guide explains how to make containerized applications running in Kubernetes pods accessible when using Colima as an alternative to Docker Desktop.

## Prerequisites

- Colima installed on your system
- Basic understanding of Kubernetes concepts

## Setup

1. Start Colima with Kubernetes support:
```bash
colima start && colima start --kubernetes
```

## Sample Application Deployment

The following example demonstrates deploying an Nginx web server using Kubernetes.

1. Create `nginx-web.yaml`:
```yaml
apiVersion: v1
kind: Service
metadata:
  name: svc-web-app
  labels:
    app: svc-web-app
spec:
  selector:
    app: web-app
  ports:
    - port: 8081
      protocol: TCP
      targetPort: 80
  type: NodePort

---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: web-app
  labels:
    app: web-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: web-app
  strategy:
    type: Recreate
  template:
    metadata:
      labels:
        app: web-app
    spec:
      containers:
      - name: web-app
        image: nginx
        ports:
        - containerPort: 80
          name: nginx
        imagePullPolicy: IfNotPresent
```

2. Apply the configuration:
```bash
kubectl apply -f nginx-web.yaml
```

## Accessing the Application

1. Check running pods:
```bash
kubectl get pods -o wide
```

2. Check service details:
```bash
kubectl get svc -o wide
kubectl describe svc svc-web-app
```

3. Get Colima IP address:
```bash
colima list
```

4. Access the application:
   - The application will be available at: `http://<colima-ip>:<nodeport>`
   - Example: If Colima IP is 192.168.106.2 and NodePort is 30252, access via:
     `http://192.168.106.2:30252`

## Key Points

- The service type is set to `NodePort` for external access
- The service listens on port 8081 internally
- A random NodePort (e.g., 30252) is assigned for external access
- The Colima IP address is required to access the application
- The application is load-balanced across multiple pods (replicas)

## Troubleshooting

If you cannot access the application:
1. Verify pods are running: `kubectl get pods`
2. Check service status: `kubectl get svc`
3. Confirm Colima IP: `colima list`
4. Ensure correct NodePort is being used
