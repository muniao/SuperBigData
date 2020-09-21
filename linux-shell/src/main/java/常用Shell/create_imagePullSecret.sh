#!/bin/bash

set -e

REGISTRY_TOKEN=`sudo cat ~/.docker/config.json | base64 | tr -d '\n'`
REGISTRY_ADDRESS=${1}
NAMESPACE=${2}

if [ "" == "${REGISTRY_ADDRESS}" ]; then
    echo -e "\033[33mWARNING: REGISTRY_ADDRESS is blank,use default value ==> reg.mritd.me\033[0m"
    REGISTRY_ADDRESS="reg.mritd.me"
fi
if [ "" == "${NAMESPACE}" ]; then
    echo -e "\033[33mWARNING: NAMESPACE is blank,use default value ==> default\033[0m"
    NAMESPACE="default"
fi


tee imagePullSecret.yaml <<EOF
apiVersion: v1
kind: Secret
metadata:
  name: ${REGISTRY_ADDRESS}
  namespace: ${NAMESPACE}
data:
  .dockerconfigjson: ${REGISTRY_TOKEN}
type: kubernetes.io/dockerconfigjson
EOF
kubectl create -f imagePullSecret.yaml
kubectl patch serviceaccounts default -p "{\"imagePullSecrets\":[{\"name\":\"${REGISTRY_ADDRESS}\"}]}" -n ${NAMESPACE}
rm -f imagePullSecret.yaml
