#!/bin/bash

# Exit when any command fails
set -e

# Call cleanup on exit
trap cleanup EXIT

# Global variables
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
cd "$DIR/.."
source env.sh

cleanup() {
    exit_code=$?

    if [[ "$exit_code" -eq 0 ]]; then
        echo "#####################################################################"
        echo "SUCCESS!"
        echo "#####################################################################"
    else
        echo "#####################################################################"
        echo "FAILURE! Something went wrong"
        echo "#####################################################################"
    fi

    exit "$exit_code"
}

# Get command line arguments
while getopts "e:v:" opt; do
  case $opt in
    e) ENV="$OPTARG"
        if [[
             "$ENV" != development && \
             "$ENV" != staging && \
             "$ENV" != qa  && \
             "$ENV" != production \
        ]]; then
            echo "#####################################################################"
            echo "Invalid value for flag -e. Please pass 'development', staging', qa', or 'production'"
            echo "#####################################################################"
            exit 22
        fi
    ;;
    v) VERSION="$OPTARG"
    ;;
    \?) echo "Invalid option -$OPTARG" >&2
    exit 1
    ;;
  esac
done

check_commands() {
    if ! [[ "$(command -v aws)" ]]; then
        echo "#####################################################################"
        echo "Error: aws not found"
        echo "#####################################################################"
        exit 127
    fi

    if ! [[ "$(command -v npm)" ]]; then
        echo "#####################################################################"
        echo "Error: NPM not found"
        echo "#####################################################################"
        exit 127
    fi

    if ! [[ "$(command -v docker)" ]]; then
        echo "#####################################################################"
        echo "Error: Docker not found"
        echo "#####################################################################"
        exit 127
    fi
}

build_image() {
    # Install dependencies
    npm ci

    # Bundle code
    npm run build

    # Build image
    IMAGE=${ECR_PREFIX}/generate-pdfs:${VERSION}
    docker build -t="${IMAGE}" --build-arg NODE_VERSION="${NODE_VERSION}" NODE_ENV="${NODE_ENV}" TINI_VERSION="${TINI_VERSION}" --file Dockerfile .
}

deploy() {
    # Docker login
    eval "$(aws ecr get-login --no-include-email --region "${AWS_REGION}")"

    docker push "${IMAGE}"
}

check_commands
build_image
deploy
