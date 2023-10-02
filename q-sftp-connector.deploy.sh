#!/bin/bash
set -ex

export tag=0.011
terraform -chdir=terraform/q-sftp-connector apply -var="image_tag=$tag" $1
