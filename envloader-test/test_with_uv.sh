#!/bin/bash
echo "Testing with UV..."
# First set environment variables
eval "$(./envloader)"
# Then use UV - it will inherit the environment
uv venv
source .venv/bin/activate
uv run test.py
deactivate
rm -rf .venv 