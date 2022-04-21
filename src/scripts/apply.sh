#!/bin/bash
TF_ARGS=""
if [ "$TERRAFORM_AUTO_APPROCE" = "true" ]; then
    TF_ARGS="$TF_ARGS -auto-approve"
fi
envdir /secrets terraform -chdir=${TERRAFORM_PATH} apply \
       -lock-timeout=${TERRAFORM_LOCK_TIMEOUT} \
       -parallelism=${TERRAFORM_PARALLELISM} \
       $TF_ARGS \
       ${TERRAFORM_IN}
