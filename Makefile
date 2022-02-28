current-dir := $(dir $(abspath $(lastword $(MAKEFILE_LIST))))
SHELL = /bin/sh

AWS_PROFILE=admin-ecs-deployment-demo
AWS_REGION=$(shell grep aws_default_region terraform/terraform.tfvars | cut -d'"' -f 2)
ECR_REPOSITORY=$(shell grep ecr_repository terraform/terraform.tfvars | cut -d'"' -f 2)
APP_VERSION=$(shell cd demo-api && mvn org.apache.maven.plugins:maven-help-plugin:2.1.1:evaluate -Dexpression=project.version  | grep -v '\[')

start:
	@if [ -z $(shell which mvn) ]; then echo "ERROR: missing software required: maven" > /dev/stderr && exit 1; fi
	@if [ -z $(shell which terraform) ]; then echo "ERROR: missing software required: terraform" > /dev/stderr && exit 1; fi
	@if [ -z $(shell which aws) ]; then echo "ERROR: missing software required: aws" > /dev/stderr && exit 1; fi
	@if [ -z $(shell which docker) ]; then echo "ERROR: missing software required: docker" > /dev/stderr && exit 1; fi
	@if [ -z $(shell which tfenv) ]; then echo "ERROR: missing software required: tfenv" > /dev/stderr && exit 1; fi
	@cd terraform && tfenv install
	@cd terraform && terraform init
	@echo "Everything's fine :) Have fun!"

build:
	@if [ -z $(shell which mvn) ]; then echo "ERROR: missing software required: maven" > /dev/stderr && exit 1; fi
	@echo "Building demo-api artifact with version ${APP_VERSION}"
	@cd demo-api && mvn clean package

upload-image: build
	@if [ -z $(shell which aws) ]; then echo "ERROR: missing software required: aws" > /dev/stderr && exit 1; fi
	@if [ -z $(shell which docker) ]; then echo "ERROR: missing software required: docker" > /dev/stderr && exit 1; fi
	@aws ecr get-login-password --region ${AWS_REGION} --profile ${AWS_PROFILE} | docker login --username AWS --password-stdin ${ECR_REPOSITORY}
	@docker build -t demo-api .
	@docker tag demo-api:latest ${ECR_REPOSITORY}/demo-api:${APP_VERSION}
	@echo "Uploading demo-api Docker image with version ${APP_VERSION} to ECR registry"
	@docker push ${ECR_REPOSITORY}/demo-api:${APP_VERSION}

deploy: upload-image
	@echo "Applying Terraform changes to update project to version ${APP_VERSION}"
	@cd terraform && terraform init && terraform apply -var="app_version=${APP_VERSION}"

PHONY: start build upload-image deploy