# Add stuff here for booting the workshop
default: serve

GITHUB_REPO ?= github.com/aws-samples/aws-workshop-for-kubernetes
WORKSHOPPER_IMAGE ?= christopherhein/workshopper:latest
PORT ?= 8080
ORG ?= christopherhein
BRANCH ?= feature/workshop-2-0-1

.PHONY: serve simulate
	
serve:
	docker run --rm -p $(PORT):8080 -v ${PWD}:/app-data -e CONTENT_URL_PREFIX="file:///app-data" -e WORKSHOPS_URLS="file:///app-data/_workshops/kops_ops.yaml,file:///app-data/_workshops/kops_dev.yaml" $(WORKSHOPPER_IMAGE)

simulate:
	docker run --rm -p $(PORT):8080 -e CONTENT_URL_PREFIX="https://raw.githubusercontent.com/${ORG}/aws-workshop-for-kubernetes/${BRANCH}" -e WORKSHOPS_URLS="https://raw.githubusercontent.com/${ORG}/aws-workshop-for-kubernetes/${BRANCH}/_workshops/kops_ops.yaml,https://raw.githubusercontent.com/${ORG}/aws-workshop-for-kubernetes/${BRANCH}/_workshops/kops_dev.yaml" ${WORKSHOPPER_IMAGE}