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
        image: nginx
        ports:
        - containerPort: 80
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
      targetPort: 80
  type: LoadBalancer
EOF
)

# Apply the deployment YAML
echo "Creating Hello World Deployment..."
echo "$DEPLOYMENT_YAML" | kubectl apply -f -

# Apply the service YAML
echo "Creating Hello World Service..."
echo "$SERVICE_YAML" | kubectl apply -f -

# Wait for the LoadBalancer hostname to be provisioned
echo "Waiting for LoadBalancer hostname to be provisioned..."
while true; do
  EXTERNAL_HOSTNAME=$(kubectl get svc hello-world -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
  if [ -n "$EXTERNAL_HOSTNAME" ]; then
    break
  fi
  echo "Still waiting for LoadBalancer hostname..."
  sleep 10
done

# Display the external hostname
echo "Hello World application is deployed."
echo "Access it at http://$EXTERNAL_HOSTNAME"
