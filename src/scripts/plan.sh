#!/bin/bash
mkdir -p "$(dirname "${TERRAFORM_OUT}")"

envdir /secrets terraform -chdir=${TERRAFORM_PATH} plan \
       -lock-timeout=${TERRAFORM_LOCK_TIMEOUT} \
       -parallelism=${TERRAFORM_PARALLELISM} \
       -out=${TERRAFORM_OUT} \
       -var vault_addr=${VAULT_ADDR} | tee terraform-plan-info
TERRAFORM_PLAN_INFO=$(cat terraform-plan-info | grep Plan: | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g')
export TERRAFORM_PLAN_INFO

curl -sSX POST \
       -H "Authorization: token ${GITHUB_TOKEN}" \
       -d '{
            "state": "success",
            "target_url": "'"${CIRCLE_BUILD_URL}"'",
            "description": "'"${TERRAFORM_PLAN_INFO}"'",
            "context": "terraform plan"
          }' \
       https://api.github.com/repos/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/statuses/${CIRCLE_SHA1}
