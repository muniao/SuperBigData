#!/bin/bash

KUBE_API_SERVER=$1
CERT_DIR=${2:-"/etc/kubernetes/ssl"}

kubectl config set-cluster default-cluster --server=${KUBE_API_SERVER} \
    --certificate-authority=${CERT_DIR}/k8s-root-ca.pem \
    --embed-certs=true \
    --kubeconfig=admin.kubeconfig

kubectl config set-credentials default-admin \
    --certificate-authority=${CERT_DIR}/k8s-root-ca.pem \
    --embed-certs=true \
    --client-key=${CERT_DIR}/admin-key.pem \
    --client-certificate=${CERT_DIR}/admin.pem \
    --kubeconfig=admin.kubeconfig 

kubectl config set-context default-system --cluster=default-cluster \
    --user=default-admin \
    --kubeconfig=admin.kubeconfig

kubectl config use-context default-system --kubeconfig=admin.kubeconfig
