#!/bin/bash

# Shopify Clone - Phase Workflow Hook
# Provides contextual reminders based on current phase

# Colors for output
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
NC='\033[0m' # No Color

# Check current phase by analyzing project state
check_current_phase() {
    if [ ! -f "package.json" ]; then
        echo "0"  # Phase 0: Planning (no Next.js yet)
    elif [ ! -f "prisma/schema.prisma" ]; then
        echo "1"  # Phase 1: Project init not complete
    elif [ ! -f "src/middleware.ts" ]; then
        echo "2"  # Phase 2: Auth not implemented
    elif [ ! -d "src/app/api/products" ]; then
        echo "3"  # Phase 3: Products not implemented
    elif [ ! -d "src/app/store" ]; then
        echo "4"  # Phase 4: Storefront not created
    elif ! grep -q "CartContext" src -r 2>/dev/null; then
        echo "5"  # Phase 5: Cart not implemented
    elif [ ! -f "README.md" ] || ! grep -q "Screenshots" README.md; then
        echo "6"  # Phase 6: Documentation/deployment pending
    else
        echo "7"  # Phase 7+: Post-MVP features
    fi
}

PHASE=$(check_current_phase)

echo ""
echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}"
echo -e "${PURPLE}   Shopify Clone - Phase Workflow Assistant${NC}"
echo -e "${PURPLE}═══════════════════════════════════════════════════${NC}"
echo ""

# Provide phase-specific reminders
case $PHASE in
    0)
        echo -e "${YELLOW}📋 Phase 0: Planning & Setup${NC}"
        echo ""
        echo "Current focus:"
        echo "  • Create GitHub repository and Projects board"
        echo "  • Write ADR 0001 (Auth0) and ADR 0002 (Supabase RLS)"
        echo "  • Create GitHub Issues for Epic 1"
        echo "  • Review master checklist and planning docs"
        echo ""
        echo "Next phase: Initialize Next.js 15 project"
        ;;
    1)
        echo -e "${BLUE}🚀 Phase 1: Project Initialization${NC}"
        echo ""
        echo "Current focus:"
        echo "  • Install Next.js 15 with TypeScript and Tailwind"
        echo "  • Install core dependencies (Auth0, Supabase, Prisma, TanStack Query)"
        echo "  • Configure .env.local with all credentials"
        echo "  • Create database schema in Supabase"
        echo "  • Set up Prisma and test connection"
        echo ""
        echo "Reference: 5-Phase 1: Project Initialization.md"
        echo "Commands:"
        echo "  • npm run dev - Start dev server"
        echo "  • npx prisma studio - Open database GUI"
        echo ""
        echo "Next phase: Auth0 integration (Issues #1-5)"
        ;;
    2)
        echo -e "${BLUE}🔐 Phase 2: Authentication & Store Management${NC}"
        echo ""
        echo "Current focus:"
        echo "  • Epic 1 - Issues #1-5 (Authentication & Stores)"
        echo "  • Auth0 route handlers (/api/auth/[auth0])"
        echo "  • Middleware to protect /dashboard routes"
        echo "  • Landing page with login button"
        echo "  • Dashboard with store creation form"
        echo ""
        echo "Workflow:"
        echo "  1. Create feature branch (feat/auth0-integration)"
        echo "  2. Implement auth (reference /workflow command)"
        echo "  3. Create PR and self-review (/review command)"
        echo "  4. Merge to main"
        echo ""
        echo "Next phase: Product management (Epic 2)"
        ;;
    3)
        echo -e "${BLUE}🛍️ Phase 3: Product Management${NC}"
        echo ""
        echo "Current focus:"
        echo "  • Epic 2 - Product CRUD operations"
        echo "  • Product list page with TanStack Query"
        echo "  • Add/Edit product forms with validation"
        echo "  • Cloudinary image uploads"
        echo "  • API routes: GET, POST, PATCH, DELETE /api/products"
        echo ""
        echo "Commands:"
        echo "  • Use /schema for database queries"
        echo "  • Use /learn for TanStack Query patterns"
        echo ""
        echo "Next phase: Public storefront (Epic 3)"
        ;;
    4)
        echo -e "${BLUE}🏪 Phase 4: Storefront Display${NC}"
        echo ""
        echo "Current focus:"
        echo "  • Epic 3 - Public product browsing"
        echo "  • Dynamic route: /store/[slug]"
        echo "  • Product grid with responsive design"
        echo "  • Product detail pages"
        echo "  • Server Components for SEO"
        echo ""
        echo "Remember:"
        echo "  • Use Server Components by default"
        echo "  • Only published products visible"
        echo "  • Optimize images with Next.js Image"
        echo ""
        echo "Next phase: Cart & checkout (Epic 4)"
        ;;
    5)
        echo -e "${BLUE}🛒 Phase 5: Cart & Checkout${NC}"
        echo ""
        echo "Current focus:"
        echo "  • Epic 4 - Shopping cart and order creation"
        echo "  • CartContext with localStorage"
        echo "  • Cart page with quantity updates"
        echo "  • Checkout form with Zod validation"
        echo "  • Order API endpoint and admin view"
        echo ""
        echo "Remember:"
        echo "  • Cart persists in localStorage (no auth required)"
        echo "  • Capture product snapshot in order_items"
        echo ""
        echo "Next phase: Polish & deployment"
        ;;
    6)
        echo -e "${BLUE}🎨 Phase 6: Polish & Deployment${NC}"
        echo ""
        echo "Current focus:"
        echo "  • Comprehensive README with screenshots"
        echo "  • Demo video (2 minutes showing flow)"
        echo "  • UI/UX polish and consistent styling"
        echo "  • Toast notifications for all actions"
        echo "  • Vercel deployment and production testing"
        echo ""
        echo "Checklist:"
        echo "  • Use /validate for final checks"
        echo "  • Run npm run build - ensure no errors"
        echo "  • Test all features end-to-end"
        echo ""
        echo "Next: Post-MVP features (optional)"
        ;;
    7)
        echo -e "${GREEN}🌟 Phase 7+: Post-MVP Features${NC}"
        echo ""
        echo "MVP complete! Consider:"
        echo "  • Order status management"
        echo "  • Theme customization"
        echo "  • Staff permissions"
        echo "  • Analytics dashboard"
        echo "  • Real payment integration (Stripe)"
        echo "  • Email notifications"
        ;;
esac

echo ""
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo -e "${YELLOW}Quality Checks:${NC}"
echo "  • npm run typecheck - TypeScript validation"
echo "  • npm run lint - ESLint checks"
echo ""
echo -e "${YELLOW}Helpful Commands:${NC}"
echo "  • /phase-status - Detailed phase tracking"
echo "  • /workflow - GitHub Flow reminders"
echo "  • /commit - Conventional commit guide"
echo "  • /review - Self-review checklist"
echo "  • /learn - Tech stack resources"
echo ""
echo -e "${PURPLE}Remember: This is a portfolio project. Focus on${NC}"
echo -e "${PURPLE}professional process and quality over speed.${NC}"
echo -e "${YELLOW}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
echo ""
