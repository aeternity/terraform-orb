#!/bin/bash
envdir /secrets terraform -chdir=${TERRAFORM_PATH} init -lock-timeout=${TERRAFORM_LOCK_TIMEOUT}
