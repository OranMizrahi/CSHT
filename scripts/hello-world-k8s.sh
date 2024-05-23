#!/bin/bash

set -e

# Define variables for the YAML content
DEPLOYMENT_YAML=$(cat <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: hello-world
spec:
  replicas: 3
  selector:
    matchLabels:
      app: hello-world
  template:
    metadata:
      labels:
        app: hello-world
    spec:
      containers:
      - name: hello-world
        image: nginxdemos/hello
        ports:
        - containerPort: 8080
EOF
)

SERVICE_YAML=$(cat <<EOF
apiVersion: v1
kind: Service
metadata:
  name: hello-world
spec:
  selector:
    app: hello-world
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: LoadBalancer
EOF
)


# Apply the deployment YAML
echo "Creating Hello World Deployment..."
echo "$DEPLOYMENT_YAML" | kubectl apply -f -

# Apply the service YAML
echo "Creating Hello World Service..."
echo "$SERVICE_YAML" | kubectl apply -f -

# Wait for the LoadBalancer IP to be provisioned
echo "Waiting for LoadBalancer IP to be provisioned..."
while true; do
  EXTERNAL_IP=$(kubectl get svc hello-world -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
  if [ -n "$EXTERNAL_IP" ]; then
    break
  fi
  echo "Still waiting for LoadBalancer IP..."
  sleep 10
done

# Display the external IP address
echo "Hello World application is deployed."
echo "Access it at http://$EXTERNAL_IP"
