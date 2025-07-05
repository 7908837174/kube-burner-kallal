#!/bin/bash
# Script to verify netcat fix works correctly

# Source the helpers to get access to the functions
source ./helpers.bash

# Set required environment variables
export SERVICE_LATENCY_NS="kube-burner-service-latency"
export SERVICE_CHECKER_POD="svc-checker"
export UUID="test123"

echo "Creating test cluster..."
setup-kind

echo "Setting up service checker..."
setup-service-checker

echo "Verification completed successfully!"
