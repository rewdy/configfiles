#!/bin/bash

export AWS_DEFAULT_REGION="us-east-1"

# function to add aws completions if installed
aws-profile-none() {
    unset AWS_DEFAULT_PROFILE
    unset AWS_PROFILE
}
