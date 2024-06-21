#!/bin/bash

### Reference: https://tekton.dev/docs/dashboard/tutorial/

script_dir=`dirname $0`
script_path=`realpath "${script_dir}"`

: '
    For any of the kubectl command executed below, you can always monitor the install with the below command:
        kubectl get pods --namespace tekton-pipelines --watch
    When all components show Running under the STATUS column the installation is complete.
'

# Install Tekton pipelines
kubectl apply --filename https://storage.googleapis.com/tekton-releases/pipeline/latest/release.yaml

# Install the Tekton Dashboard
kubectl apply --filename https://storage.googleapis.com/tekton-releases/dashboard/latest/release-full.yaml

: '
    The Tekton Dashboard is not exposed outside the cluster by default, but we can access it by port-forwarding 
    to the tekton-dashboard Service on port 9097.
        kubectl port-forward -n tekton-pipelines service/tekton-dashboard 9097:9097
'

# Grant required permissions
kubectl apply --filename "${script_path}"/permissions.yaml