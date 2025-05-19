#!/bin/bash

export AWS_DEFAULT_REGION="us-east-1"

aws-profile-none() {
    unset AWS_DEFAULT_PROFILE
    unset AWS_PROFILE
}
