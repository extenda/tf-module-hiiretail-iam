.PHONY: help fmt validate test-complete test-simple test-manual test-all clean docs

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-20s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

fmt: ## Format all Terraform files
	@echo "Formatting Terraform files..."
	@terraform fmt -recursive .
	@echo "Done!"

validate: ## Validate Terraform configuration
	@echo "Validating module..."
	@terraform init -backend=false
	@terraform validate
	@echo "Done!"

test-complete: ## Test the complete example
	@echo "Testing complete example..."
	@cd examples/complete && terraform init && terraform validate
	@echo "Complete example validated!"

test-simple: ## Test the simple example
	@echo "Testing simple example..."
	@cd examples/simple && terraform init && terraform validate
	@echo "Simple example validated!"

test-manual: ## Test the manual example
	@echo "Testing manual example..."
	@cd examples/manual && terraform init && terraform validate
	@echo "Manual example validated!"

test-all: test-complete test-simple test-manual ## Test all examples
	@echo "All examples validated successfully!"

clean: ## Clean up Terraform files
	@echo "Cleaning up..."
	@find . -type d -name ".terraform" -prune -exec rm -rf {} \;
	@find . -type f -name "*.tfstate*" -delete
	@find . -type f -name ".terraform.lock.hcl" -delete
	@echo "Cleanup complete!"

docs: ## Generate documentation (placeholder for future doc generation)
	@echo "Documentation is maintained in README.md"
	@echo "See examples/ directory for usage examples"

check-env: ## Check if required environment variables are set
	@echo "Checking environment variables..."
	@[ -n "$$HIIRETAIL_CLIENT_ID" ] || (echo "ERROR: HIIRETAIL_CLIENT_ID not set" && exit 1)
	@[ -n "$$HIIRETAIL_CLIENT_SECRET" ] || (echo "ERROR: HIIRETAIL_CLIENT_SECRET not set" && exit 1)
	@[ -n "$$HIIRETAIL_TENANT_ID" ] || (echo "ERROR: HIIRETAIL_TENANT_ID not set" && exit 1)
	@echo "All required environment variables are set!"

init: ## Initialize the module
	@echo "Initializing module..."
	@terraform init
	@echo "Done!"

plan-complete: check-env ## Plan the complete example
	@echo "Planning complete example..."
	@cd examples/complete && terraform init && terraform plan

plan-simple: check-env ## Plan the simple example
	@echo "Planning simple example..."
	@cd examples/simple && terraform init && terraform plan

plan-manual: check-env ## Plan the manual example
	@echo "Planning manual example..."
	@cd examples/manual && terraform init && terraform plan
