#!/bin/bash

###############################################################################
# Tall Us - Quick Setup Script
###############################################################################
# This script helps you quickly set up your Appwrite backend

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m' # No Color

echo -e "${CYAN}${BOLD}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║          Tall Us - Appwrite Backend Setup                 ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${NC}"

# Check if .env file exists
if [ ! -f ../.env ]; then
    echo -e "${YELLOW}⚠ .env file not found! Creating from .env.example...${NC}"
    cp ../.env.example ../.env
    echo -e "${YELLOW}⚠ Please edit .env file with your Appwrite credentials:${NC}"
    echo ""
    echo "  1. Go to https://cloud.appwrite.io"
    echo "  2. Create a new project (or use existing)"
    echo "  3. Go to Settings → API Keys"
    echo "  4. Create a new API key with Databases, Storage, and Users permissions"
    echo "  5. Copy your Project ID and API Key into .env"
    echo ""
    echo -e "${YELLOW}After editing .env, run this script again.${NC}"
    echo ""
    read -p "Press Enter to open .env file in editor..."
    ${EDITOR:-nano} ../.env
    exit 0
fi

# Load environment variables
if [ -f ../.env ]; then
    export $(cat ../.env | grep -v '^#' | xargs)
fi

# Check required variables
if [ -z "$APPWRITE_PROJECT_ID" ] || [ "$APPWRITE_PROJECT_ID" = "your-project-id-here" ]; then
    echo -e "${RED}✗ APPWRITE_PROJECT_ID not set in .env file${NC}"
    exit 1
fi

if [ -z "$APPWRITE_API_KEY" ] || [ "$APPWRITE_API_KEY" = "your-api-key-here" ]; then
    echo -e "${RED}✗ APPWRITE_API_KEY not set in .env file${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Environment variables loaded${NC}"
echo -e "  Project ID: ${CYAN}$APPWRITE_PROJECT_ID${NC}"
echo ""

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo -e "${RED}✗ Node.js is not installed${NC}"
    echo -e "${YELLOW}Please install Node.js 18+ from https://nodejs.org${NC}"
    exit 1
fi

echo -e "${GREEN}✓ Node.js version: ${CYAN}$(node --version)${NC}"

# Check if npm dependencies are installed
if [ ! -d node_modules ]; then
    echo ""
    echo -e "${BLUE}Installing dependencies...${NC}"
    npm install
fi

echo ""
echo -e "${BOLD}Starting Appwrite setup...${NC}"
echo ""

# Run the setup script
node setup-appwrite.js

# Check if setup was successful
if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}${BOLD}╔════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${GREEN}${BOLD}║                    Setup Complete!                           ║${NC}"
    echo -e "${GREEN}${BOLD}╚════════════════════════════════════════════════════════════╝${NC}"
    echo ""
    echo -e "${CYAN}Next steps:${NC}"
    echo ""
    echo -e "  1. ${GREEN}cd ..${NC}                                # Go to project root"
    echo -e "  2. ${GREEN}flutter run${NC}                          # Run the app"
    echo -e "  3. ${GREEN}Create your first account${NC}            # Test the app"
    echo ""
    echo -e "${CYAN}Verify in Appwrite Console:${NC}"
    echo -e "  → https://cloud.appwrite.io/v1/console"
    echo -e "  → Check Databases (should have 9 collections)"
    echo -e "  → Check Storage (should have 1 bucket)"
    echo ""
else
    echo ""
    echo -e "${RED}✗ Setup failed. Please check the error messages above.${NC}"
    exit 1
fi
