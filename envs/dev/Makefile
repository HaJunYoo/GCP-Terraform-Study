# Simple Terraform Makefile for envs/dev

SHELL := /bin/bash

TF            ?= terraform
PARALLELISM   ?= 10
PLAN_FILE     ?= plan.out
# Set to true to force backend reconfiguration on init
RECONFIGURE   ?= false

# Use terraform.tfvars if present; otherwise no -var-file
VAR_FILE      := $(if $(wildcard terraform.tfvars),-var-file=terraform.tfvars,)
TFVARS_EXAMPLE?= terraform.tfvars.example

# Workspace matches folder name (dev)
WORKSPACE     ?= $(notdir $(CURDIR))

.DEFAULT_GOAL := help

.PHONY: help
help: ## Show this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nTerraform Make targets:\n"} /^[a-zA-Z0-9_.-]+:.*?##/ { printf "  \033[36m%-18s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0,5) } ' $(MAKEFILE_LIST)

.PHONY: tfvars
tfvars: ## Create terraform.tfvars from example if missing
	@if [ ! -f terraform.tfvars ]; then \
		if [ -f "$(TFVARS_EXAMPLE)" ]; then \
			cp "$(TFVARS_EXAMPLE)" terraform.tfvars; \
			echo "Created terraform.tfvars from $(TFVARS_EXAMPLE)"; \
		else \
			echo "No $(TFVARS_EXAMPLE) found. Skipping."; \
		fi \
	else \
		echo "terraform.tfvars already exists. Skipping."; \
	fi

.PHONY: init
init: ## Initialize terraform (downloads providers/modules)
	@$(TF) init $(if $(filter true,$(RECONFIGURE)),-reconfigure,) $(if $(filter true,$(UPGRADE)),-upgrade,)

.PHONY: init-upgrade
init-upgrade: ## Initialize with provider/module upgrade
	@$(MAKE) init UPGRADE=true

.PHONY: workspace
workspace: ## Ensure/select workspace matching folder name
	@$(TF) workspace list >/dev/null 2>&1 || $(TF) init >/dev/null
	@($(TF) workspace list | grep -q "^\* \?$(WORKSPACE)$$") || ( \
		$(TF) workspace list | grep -q "  $(WORKSPACE)$$" && $(TF) workspace select $(WORKSPACE) || $(TF) workspace new $(WORKSPACE) )

.PHONY: fmt
fmt: ## Format terraform files
	@$(TF) fmt -recursive

.PHONY: validate
validate: ## Validate configuration
	@$(TF) validate

.PHONY: providers
providers: ## Show required and installed providers
	@$(TF) providers

.PHONY: plan
plan: workspace ## Create an execution plan
	@$(TF) plan -parallelism=$(PARALLELISM) $(VAR_FILE) -out=$(PLAN_FILE)

.PHONY: show-plan
show-plan: ## Show the saved plan (if exists)
	@if [ -f "$(PLAN_FILE)" ]; then $(TF) show -no-color $(PLAN_FILE); else echo "No $(PLAN_FILE) found. Run 'make plan' first."; fi

.PHONY: apply
apply: workspace ## Apply the last saved plan or plan+apply if none
	@if [ -f "$(PLAN_FILE)" ]; then \
		$(TF) apply -parallelism=$(PARALLELISM) $(PLAN_FILE); \
	else \
		$(TF) apply -parallelism=$(PARALLELISM) -auto-approve $(VAR_FILE); \
	fi

.PHONY: destroy
destroy: workspace ## Destroy all managed resources
	@$(TF) destroy -parallelism=$(PARALLELISM) -auto-approve $(VAR_FILE)

.PHONY: output
output: ## Show all outputs
	@$(TF) output

.PHONY: output-%
output-%: ## Show a specific output: make output-<name>
	@$(TF) output $*

.PHONY: graph
graph: ## Render dependency graph to graph.dot
	@$(TF) graph > graph.dot && echo "Wrote graph.dot"

.PHONY: clean
clean: ## Remove local state cache and plan files (keeps actual state)
	@rm -rf .terraform/ .terraform.lock.hcl $(PLAN_FILE) graph.dot || true

.PHONY: all
all: fmt init validate plan ## Run common steps (fmt -> init -> validate -> plan)
