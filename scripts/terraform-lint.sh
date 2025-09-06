#!/bin/bash

# Enhanced Terraform Lint Script for pre-commit
set -e

echo "🚀 Running comprehensive Terraform checks..."

# Check if required tools are installed
check_tool() {
    if ! command -v $1 &> /dev/null; then
        echo "⚠️  $1 is not installed. Install with: $2"
        return 1
    fi
}

# Terraform formatting check
echo "📝 Running Terraform formatting check..."
terraform fmt -recursive -check
if [ $? -ne 0 ]; then
    echo "❌ Terraform formatting issues found. Run 'terraform fmt -recursive' to fix."
    exit 1
fi
echo "✅ Terraform formatting check passed"

# Terraform validation
echo "🔍 Running Terraform validation..."
terraform validate
if [ $? -ne 0 ]; then
    echo "❌ Terraform validation failed"
    exit 1
fi
echo "✅ Terraform validation passed"

# TFLint (if available)
if check_tool "tflint" "curl -s https://raw.githubusercontent.com/terraform-linters/tflint/master/install_linux.sh | bash"; then
    echo "🔧 Running TFLint..."
    tflint --config=.tflint.hcl --recursive
    if [ $? -ne 0 ]; then
        echo "❌ TFLint found issues"
        exit 1
    fi
    echo "✅ TFLint check passed"
fi

# tfsec (if available)
if check_tool "tfsec" "brew install tfsec # or go install github.com/aquasecurity/tfsec/cmd/tfsec@latest"; then
    echo "🔒 Running tfsec security scan..."
    tfsec --config-file=.tfsec.yml .
    if [ $? -ne 0 ]; then
        echo "❌ tfsec found security issues"
        exit 1
    fi
    echo "✅ tfsec security scan passed"
fi

echo "🎉 All Terraform checks completed successfully!"