############################################################
# AWS STUFF
############################################################

export AWS_DEFAULT_REGION="us-east-1"

# granted cli setup: https://docs.commonfate.io/granted/introduction
if command -v granted &>/dev/null; then
    # setup the assume command
    unalias assume &>/dev/null
    assume_path=$(which assume)
    alias assume="source $assume_path"

    # reload completions if needed
    assume-completions-reload() {
        granted completion -s zsh
    }
fi

# function to add aws completions if installed
aws-completions() {
    local mydir
    mydir=$(pyenv which aws_completer | xargs dirname)
    source $mydir/aws_zsh_completer.sh
}

# Personaol profile!!
aws-profile-personal() {
    export AWS_DEFAULT_PROFILE="ameyer-personal-aws"
    export AWS_PROFILE="ameyer-personal-aws"
    export AWS_REGION="us-east-1"
    export AWS_DEFAULT_REGION="us-east-1"
    unset AWS_ACCESS_KEY_ID
    unset AWS_SECRET_ACCESS_KEY
    unset AWS_SESSION_TOKEN
    unset AWS_SESSION_EXPIRATION
    unset AWS_CREDENTIAL_EXPIRATION
}

aws-profile-none() {
    unset AWS_DEFAULT_PROFILE
    unset AWS_PROFILE
}
