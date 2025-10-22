#!/bin/bash

# Shopify Clone - Code Quality Hook
# Runs after Write/Edit operations to ensure code quality

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get the edited file from the arguments (if available)
EDITED_FILE="$1"

# Check if we're in the project directory
if [ ! -f "package.json" ]; then
    echo -e "${YELLOW}⚠️  Not in project root - skipping quality checks${NC}"
    exit 0
fi

# Check if it's a TypeScript/JavaScript file
if [[ "$EDITED_FILE" == *.ts || "$EDITED_FILE" == *.tsx || "$EDITED_FILE" == *.js || "$EDITED_FILE" == *.jsx ]]; then
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo -e "${BLUE}🔍 Code Quality Checks${NC}"
    echo -e "${BLUE}═══════════════════════════════════════════${NC}"
    echo ""

    # ESLint check
    if command -v npx &> /dev/null; then
        echo "📝 Running ESLint..."
        npx eslint "$EDITED_FILE" --max-warnings 0 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ ESLint: No issues found${NC}"
        else
            echo -e "${YELLOW}⚠️  ESLint: Found issues - run 'npm run lint' for details${NC}"
            echo -e "${YELLOW}   Fix with: npm run lint -- --fix${NC}"
        fi
        echo ""
    fi

    # TypeScript check for .ts and .tsx files
    if [[ "$EDITED_FILE" == *.ts || "$EDITED_FILE" == *.tsx ]]; then
        if [ -f "tsconfig.json" ] && command -v npx &> /dev/null; then
            echo "🔷 Running TypeScript check..."
            npx tsc --noEmit 2>&1 | head -10
            if [ ${PIPESTATUS[0]} -eq 0 ]; then
                echo -e "${GREEN}✅ TypeScript: No type errors${NC}"
            else
                echo -e "${YELLOW}⚠️  TypeScript: Type errors detected${NC}"
                echo -e "${YELLOW}   Full report: npm run typecheck${NC}"
            fi
            echo ""
        fi
    fi

    # Check for common issues
    echo "🔎 Scanning for common issues..."

    # Check for console.log
    if grep -q "console.log" "$EDITED_FILE" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Found console.log() - remove before production${NC}"
    fi

    # Check for TODO comments
    if grep -q "TODO" "$EDITED_FILE" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Found TODO comments - consider creating GitHub issue${NC}"
    fi

    # Check for hardcoded localhost
    if grep -q "localhost:3000" "$EDITED_FILE" 2>/dev/null; then
        echo -e "${YELLOW}⚠️  Found hardcoded localhost - use environment variable${NC}"
    fi

    # Check for 'any' type (TypeScript)
    if [[ "$EDITED_FILE" == *.ts || "$EDITED_FILE" == *.tsx ]]; then
        if grep -q ": any" "$EDITED_FILE" 2>/dev/null; then
            echo -e "${YELLOW}⚠️  Found 'any' type - prefer specific types${NC}"
        fi
    fi

    echo ""
fi

# Check if it's a JSON file
if [[ "$EDITED_FILE" == *.json && "$EDITED_FILE" != "package-lock.json" ]]; then
    echo "📋 Validating JSON syntax..."
    if command -v jq &> /dev/null; then
        jq empty "$EDITED_FILE" 2>/dev/null
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ JSON: Valid syntax${NC}"
        else
            echo -e "${RED}❌ JSON: Invalid syntax${NC}"
        fi
    elif command -v python3 &> /dev/null; then
        python3 -m json.tool "$EDITED_FILE" > /dev/null 2>&1
        if [ $? -eq 0 ]; then
            echo -e "${GREEN}✅ JSON: Valid syntax${NC}"
        else
            echo -e "${RED}❌ JSON: Invalid syntax${NC}"
        fi
    fi
    echo ""
fi

# Check if it's a Prisma schema file
if [[ "$EDITED_FILE" == *"prisma/schema.prisma" ]]; then
    echo "🗄️  Prisma schema modified"
    echo -e "${YELLOW}💡 Remember to run: npx prisma generate${NC}"
    echo -e "${YELLOW}💡 And if needed: npx prisma db push${NC}"
    echo ""
fi

# Check if it's .env.local
if [[ "$EDITED_FILE" == *.env.local* ]]; then
    echo -e "${RED}🚨 WARNING: Never commit .env.local to git!${NC}"
    echo -e "${RED}   Verify with: git status${NC}"
    echo ""
fi

# Final reminders
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Pre-commit checklist:${NC}"
echo "  • npm run typecheck"
echo "  • npm run lint"
echo "  • Test in browser"
echo "  • Use conventional commit message"
echo ""
echo -e "${YELLOW}Helpful commands:${NC}"
echo "  • /commit - Commit message guide"
echo "  • /review - Self-review checklist"
echo "  • /validate - Full validation suite"
echo -e "${BLUE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""