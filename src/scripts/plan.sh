#!/bin/bash
echo "Creating dicectory for terraform out"
mkdir -p "$(dirname "${TERRAFORM_OUT}")"
echo $?
echo "Generating secrets"
ls -lah /secrets/
cat /secrets/VAULT_ADDR
envdir /secrets echo ${VAULT_ADDR}
envdir /secrets terraform -chdir=${TERRAFORM_PATH} plan \
       -lock-timeout=${TERRAFORM_LOCK_TIMEOUT} \
       -parallelism=${TERRAFORM_PARALLELISM} \
       -out=${TERRAFORM_OUT} \
       -var vault_addr=${VAULT_ADDR:?} | tee terraform-plan-info
echo $?
echo "Creating TERRAFORM_PLAN_INFO variable"
TERRAFORM_PLAN_INFO=$(cat terraform-plan-info | grep Plan: | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g')
echo "Exporting TERRAFORM_PLAN_INFO variable"
export TERRAFORM_PLAN_INFO
echo $?
curl -X POST \
          -H "Authorization: token ${GITHUB_TOKEN}" \
          -d '{
            "state": "success",
            "target_url": "'"${CIRCLE_BUILD_URL}"'",
            "description": "'"${TERRAFORM_PLAN_INFO}"'",
            "context": "terraform plan"
          }' \
          https://api.github.com/repos/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/statuses/${CIRCLE_SHA1}
echo $?
