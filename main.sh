#!/bin/bash
SERVICE_NAME=socat-tunnel
read -p "Whitch 'port' u want expose: " PORT
read -p "Whitch 'endpoint' u want expose: " ENDPOINT

echo "Delete exist pod and service"
kubectl delete pod ${SERVICE_NAME} -n default > /dev/null 2>&1
kubectl delete svc ${SERVICE_NAME} -n default > /dev/null 2>&1

echo "Create Socat Tunnel"
kubectl -n default run ${SERVICE_NAME} \
  --image=alpine/socat \
  --restart=Never \
  --expose=true --port=${PORT} \
  tcp-listen:${PORT},fork,reuseaddr \
  tcp-connect:${ENDPOINT}:${PORT} 
  
echo "Doing port-forward to access locally"
kubectl -n default port-forward service/${SERVICE_NAME} ${PORT}:${PORT}
