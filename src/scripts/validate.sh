#!/bin/bash
terraform -chdir=${TERRAFORM_PATH} fmt -check=true -diff=true
