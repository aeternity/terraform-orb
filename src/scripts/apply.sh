#!/bin/bash
TF_ARGS=""
if [ "<< parameters.auto_approve >>" = "true" ]; then
    TF_ARGS="$TF_ARGS -auto-approve"
fi
envdir /secrets terraform -chdir=<< parameters.path >> apply \
       -lock-timeout=<< parameters.lock_timeout >> \
       -parallelism=<< parameters.parallelism >> \
       $TF_ARGS \
       << parameters.in >>
