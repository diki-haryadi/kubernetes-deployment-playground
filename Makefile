# Makefile for KubeSphere and Kubernetes management

.PHONY: install check-cluster check-kubesphere clean-install get-credentials get-console-access monitor-install check-components

# KubeSphere Installation
install:
	kubectl create namespace kubesphere-system
	kubectl apply -f https://github.com/kubesphere/ks-installer/releases/download/v3.3.0/kubesphere-installer.yaml
	kubectl apply -f https://github.com/kubesphere/ks-installer/releases/download/v3.3.0/cluster-configuration.yaml

# Clean Installation
clean-install:
	kubectl delete -n kubesphere-system ks-installer-67577685fd-gvtqb

# Monitor Installation
monitor-install:
	kubectl logs -n kubesphere-system $$(kubectl get pod -n kubesphere-system -l 'app in (ks-install, ks-installer)' -o jsonpath='{.items[0].metadata.name}') -f

# Check KubeSphere Components
check-components:
	kubectl get pods -n kubesphere-system

# Get Console Access
get-console-access:
	@echo "Console Service Details:"
	kubectl get svc/ks-console -n kubesphere-system
	@echo "\nDefault credentials:"
	@echo "Username: admin"
	@echo "Password: P@88w0rd"

# Check Kubernetes Cluster
check-cluster:
	@echo "\n=== Cluster Info ==="
	kubectl cluster-info
	@echo "\n=== Cluster Version ==="
	kubectl version
	@echo "\n=== Node Status ==="
	kubectl get nodes
	@echo "\n=== System Pods ==="
	kubectl get pods -n kube-system
	@echo "\n=== Resource Usage ==="
	kubectl top nodes
	kubectl top pods --all-namespaces

# Detailed Cluster Check
check-cluster-detailed:
	@echo "\n=== Storage Classes ==="
	kubectl get storageclass
	@echo "\n=== Services ==="
	kubectl get services --all-namespaces
	@echo "\n=== Network Policies ==="
	kubectl get networkpolicies --all-namespaces
	@echo "\n=== Config Maps ==="
	kubectl get configmaps --all-namespaces
	@echo "\n=== RBAC Configuration ==="
	kubectl get roles --all-namespaces
	kubectl get clusterroles
	kubectl get rolebindings --all-namespaces
	@echo "\n=== Events ==="
	kubectl get events --all-namespaces

# Monitor KubeSphere Installation
watch-installation:
	kubectl get pods -n kubesphere-system -w

# Check Pod Details
describe-pod:
	@if [ "$(pod)" = "" ]; then \
		echo "Usage: make describe-pod pod=<pod-name>"; \
	else \
		kubectl describe pod $(pod) -n kubesphere-system; \
	fi

# Get Pod Logs
get-logs:
	@if [ "$(pod)" = "" ]; then \
		echo "Usage: make get-logs pod=<pod-name>"; \
	else \
		kubectl logs -n kubesphere-system $(pod); \
	fi

# Help
help:
	@echo "Available targets:"
	@echo "  install              - Install KubeSphere"
	@echo "  clean-install       - Clean up existing installation"
	@echo "  monitor-install     - Monitor installation progress"
	@echo "  check-components    - Check KubeSphere components status"
	@echo "  get-console-access  - Get console access details"
	@echo "  check-cluster       - Basic cluster health check"
	@echo "  check-cluster-detailed - Detailed cluster check"
	@echo "  watch-installation  - Watch KubeSphere installation progress"
	@echo "  describe-pod        - Describe specific pod (use: make describe-pod pod=<pod-name>)"
	@echo "  get-logs           - Get logs for specific pod (use: make get-logs pod=<pod-name>)"

# Default target
default: help
