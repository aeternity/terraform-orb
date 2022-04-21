#!/bin/bash
ls -l
pwd
envdir /secrets terraform -chdir=${TERRAFORM_PATH} init -lock-timeout=${TERRAFORM_LOCK_TIMEOUT}
