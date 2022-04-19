#!/bin/bash
terraform -chdir=<< parameters.path >> fmt -check=true -diff=true
