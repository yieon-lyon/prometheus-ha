#! /bin/bash
AWS_ACCESS_KEY_ID={YOUR_ACCESS_KEY}
AWS_SECRET_ACCESS_KEY={YOUR_PASS_KEY}
ECR_REGISTRY=XXXXXXXXXXXX.dkr.ecr.ap-northeast-2.amazonaws.com
ECR_REPOSITORY=thanos
IMAGE_TAG=v0.34.1

if [ $1 ]; then
  IMAGE_TAG=$1
fi
echo "tag = $IMAGE_TAG"

function loginToECR() {
  echo "--> 1. ECR login"
  aws ecr get-login-password --region ap-northeast-2 | docker login --username AWS --password-stdin $ECR_REGISTRY
}

function pullImage() {
  echo "--> 2. pull thanos image"
  docker pull quay.io/thanos/thanos:$IMAGE_TAG
}

function pushToECR() {
  echo "--> 3-1. tagging image"
  docker tag quay.io/thanos/thanos:$IMAGE_TAG $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG

  echo "--> 3-2. push to ECR (arm64)"
  docker push $ECR_REGISTRY/$ECR_REPOSITORY:$IMAGE_TAG
}

loginToECR
pullImage
pushToECR
