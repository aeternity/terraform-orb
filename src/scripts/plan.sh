#!/bin/bash
mkdir -p $(dirname "<< parameters.out >>")
envdir /secrets terraform -chdir=<< parameters.path >> plan \
       -lock-timeout=<< parameters.lock_timeout >> \
       -parallelism=<< parameters.parallelism >> \
       -out=<< parameters.out >> \
       -var vault_addr=${VAULT_ADDR:?} | tee terraform-plan-info

 export TERRAFORM_PLAN_INFO=`cat terraform-plan-info | grep Plan: | sed 's/\x1b\[[0-9;]*[a-zA-Z]//g'`
 curl -sSX POST \
          -H "Authorization: token ${GITHUB_TOKEN}" \
          -d '{
            "state": "success",
            "target_url": "'"${CIRCLE_BUILD_URL}"'",
            "description": "'"${TERRAFORM_PLAN_INFO}"'",
            "context": "terraform plan"
          }' \
          https://api.github.com/repos/${CIRCLE_PROJECT_USERNAME}/${CIRCLE_PROJECT_REPONAME}/statuses/${CIRCLE_SHA1} > /dev/null