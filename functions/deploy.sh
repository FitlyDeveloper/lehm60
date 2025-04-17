#!/bin/bash

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
NC='\033[0m' # No Color

echo -e "${YELLOW}Deploying Firebase Functions for AI Service${NC}"

# Check if Firebase CLI is installed
if ! command -v firebase &> /dev/null; then
    echo -e "${RED}Firebase CLI is not installed. Please install it with 'npm install -g firebase-tools'${NC}"
    exit 1
fi

# Check if logged in to Firebase
firebase projects:list &> /dev/null
if [ $? -ne 0 ]; then
    echo -e "${YELLOW}Please log in to Firebase:${NC}"
    firebase login
fi

# Install dependencies
echo -e "${YELLOW}Installing dependencies...${NC}"
npm install

# Check API key configuration
echo -e "${YELLOW}Checking DeepSeek API key configuration...${NC}"
API_KEY=$(firebase functions:config:get deepseek.api_key 2>/dev/null)

if [[ -z "$API_KEY" || "$API_KEY" == "{}" ]]; then
    echo -e "${RED}DeepSeek API key is not configured.${NC}"
    echo -e "${YELLOW}Please enter your DeepSeek API key:${NC}"
    read -s api_key
    
    if [[ -z "$api_key" ]]; then
        echo -e "${RED}No API key provided. Aborting deployment.${NC}"
        exit 1
    fi
    
    echo -e "${YELLOW}Setting DeepSeek API key...${NC}"
    firebase functions:config:set deepseek.api_key="$api_key"
else
    echo -e "${GREEN}DeepSeek API key is configured.${NC}"
fi

# Deploy functions
echo -e "${YELLOW}Deploying Firebase Functions...${NC}"
firebase deploy --only functions

if [ $? -eq 0 ]; then
    echo -e "${GREEN}Deployment successful!${NC}"
    echo -e "${YELLOW}Functions available:${NC}"
    echo -e "- getAIResponse"
    echo -e "- streamAIResponse"
else
    echo -e "${RED}Deployment failed. Please check the error message above.${NC}"
    exit 1
fi

# Instructions for local testing
echo -e "${YELLOW}For local testing:${NC}"
echo -e "1. Run 'firebase functions:config:get > .runtimeconfig.json'"
echo -e "2. Run 'firebase emulators:start --only functions'"
echo -e "${GREEN}Done!${NC}" 