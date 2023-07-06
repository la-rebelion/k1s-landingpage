#!/bin/bash

# Check if namespace and deployment name are provided
if [[ $# -ne 2 ]]; then
  echo "Usage: $0 <namespace> <deployment>"
  echo "Example: $0 k1s-tests k1s-lp"
  exit 1
fi

# Assign command-line arguments to variables
NAMESPACE=$1
DEPLOYMENT=$2

# echo a message in green color
echo -e "\e[32mCopying html to all pods in the deployment\e[0m"
POD_NAMES=($(kubectl get pods -n $NAMESPACE -l io.kompose.service=$DEPLOYMENT -o jsonpath='{.items[*].metadata.name}'))
for pod in "${POD_NAMES[@]}"; do
  echo -e "\e[32m\t--> pod ${POD_NAMES[@]}\e[0m\n"
  kubectl cp index.html $NAMESPACE/$pod:/usr/local/apache2/htdocs/index.html
done

# echo a message in yellow color
# Copy .env to all pods in the deployment
echo -e "\e[33mCopying .env to all pods in the deployment\e[0m"
for pod in "${POD_NAMES[@]}"; do
  echo -e "\e[33m\t--> pod ${POD_NAMES[@]}\e[0m\n"
  kubectl cp .env $NAMESPACE/$pod:/usr/local/apache2/htdocs/.env
done

# Execute commands inside each pod to move the files to the desired location
#echo -e "\e[32mMove files to the desired location\e[0m\n"
#for pod in "${POD_NAMES[@]}"; do
#  kubectl exec -it $NAMESPACE/$pod -- bash -c "mv /tmp/index.html /usr/local/apache2/htdocs/"
#  kubectl exec -it $NAMESPACE/$pod -- bash -c "mv /tmp/.env /usr/local/apache2/htdocs/"
#done
