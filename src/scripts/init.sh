#!/bin/bash
echo ${TERRAFORM_PATH}
echo ${TERRAFORM_LOCK_TIMEOUT}
envdir /secrets terraform -chdir=${TERRAFORM_PATH} init -lock-timeout=${TERRAFORM_LOCK_TIMEOUT}
