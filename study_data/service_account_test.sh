#! /bin/bash
# execute these lines inside pod bash to check K8s API call

# internal Kubernetes API server hostname
export APISERVER=https://kubernetes.default.svc

# path to ServiceAccount mount directory
export SERVICEACCOUNT=/var/run/secrets/kubernetes.io/serviceaccount

# ServiceAccount bearer token
export TOKEN=$(cat ${SERVICEACCOUNT}/token)

# internal Kubernetes certificate authority (CA)
export CACERT=${SERVICEACCOUNT}/ca.crt

# check Variables
echo $CACERT

# install curl
apt-get install curl

# run curl to the Kubernetes API with TOKEN
curl --cacert ${CACERT} --header "Authorization: Bearer ${TOKEN}" -X GET ${APISERVER}/api/v1/namespaces/default/pods
# Before Setting ReadOnly Role Allowed ServiceAccount, it returns 403 Forbidden
# After ServiceAccount is added, it returns Pod Info using K8s API
