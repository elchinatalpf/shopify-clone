# Shopify Clone - Validation Checklist

## 🔍 **Phase Validation**

Run these checks after completing each phase to ensure quality and completeness.

---

## **Phase 1: Project Initialization** ✓

### File Structure
```bash
# Verify essential files exist
test -f package.json && echo "✅ package.json" || echo "❌ Missing package.json"
test -f tsconfig.json && echo "✅ tsconfig.json" || echo "❌ Missing tsconfig.json"
test -f next.config.ts && echo "✅ next.config.ts" || echo "❌ Missing next.config"
test -f tailwind.config.ts && echo "✅ tailwind.config.ts" || echo "❌ Missing Tailwind config"
test -f prisma/schema.prisma && echo "✅ Prisma schema" || echo "❌ Missing Prisma schema"
test -f src/lib/prisma.ts && echo "✅ Prisma client" || echo "❌ Missing Prisma client"
test -f .env.local && echo "✅ .env.local" || echo "❌ Missing .env.local"
test -f .gitignore && echo "✅ .gitignore" || echo "❌ Missing .gitignore"
```

### Dependencies
```bash
# Check core dependencies
npm list @auth0/nextjs-auth0 2>/dev/null && echo "✅ Auth0 installed" || echo "❌ Missing Auth0"
npm list @supabase/supabase-js 2>/dev/null && echo "✅ Supabase installed" || echo "❌ Missing Supabase"
npm list prisma 2>/dev/null && echo "✅ Prisma installed" || echo "❌ Missing Prisma"
npm list @tanstack/react-query 2>/dev/null && echo "✅ TanStack Query installed" || echo "❌ Missing TanStack Query"
npm list zod 2>/dev/null && echo "✅ Zod installed" || echo "❌ Missing Zod"
npm list react-hook-form 2>/dev/null && echo "✅ React Hook Form installed" || echo "❌ Missing React Hook Form"
npm list next-cloudinary 2>/dev/null && echo "✅ Cloudinary installed" || echo "❌ Missing Cloudinary"
npm list tailwindcss 2>/dev/null && echo "✅ Tailwind CSS installed" || echo "❌ Missing Tailwind"
```

### Database
```bash
# Test database connection
curl -s http://localhost:3000/test-db | grep "success" && echo "✅ Database connected" || echo "❌ Database connection failed"

# Check Prisma Client is generated
test -d node_modules/.prisma/client && echo "✅ Prisma Client generated" || echo "❌ Run: npx prisma generate"
```

### Environment Variables
```bash
# Check .env.local has required variables (without showing values)
grep -q "AUTH0_SECRET" .env.local && echo "✅ AUTH0_SECRET" || echo "❌ Missing AUTH0_SECRET"
grep -q "AUTH0_CLIENT_ID" .env.local && echo "✅ AUTH0_CLIENT_ID" || echo "❌ Missing AUTH0_CLIENT_ID"
grep -q "DATABASE_URL" .env.local && echo "✅ DATABASE_URL" || echo "❌ Missing DATABASE_URL"
grep -q "NEXT_PUBLIC_SUPABASE_URL" .env.local && echo "✅ SUPABASE_URL" || echo "❌ Missing SUPABASE_URL"
grep -q "NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME" .env.local && echo "✅ CLOUDINARY_CLOUD_NAME" || echo "❌ Missing CLOUDINARY"
```

---

## **Phase 2: Authentication & Store Management** ✓

### Auth0 Setup
```bash
# Check Auth0 files
test -f src/app/api/auth/\[auth0\]/route.ts && echo "✅ Auth0 route handlers" || echo "❌ Missing Auth0 routes"
test -f src/middleware.ts && echo "✅ Middleware exists" || echo "❌ Missing middleware"

# Verify middleware protects /dashboard
grep -q "/dashboard" src/middleware.ts && echo "✅ Dashboard protected" || echo "❌ Dashboard not protected"
```

### Pages & Components
```bash
# Check key pages
test -f src/app/page.tsx && echo "✅ Landing page" || echo "❌ Missing landing page"
test -f src/app/dashboard/page.tsx && echo "✅ Dashboard page" || echo "❌ Missing dashboard"

# Check store components
test -f src/components/CreateStoreForm.tsx && echo "✅ CreateStoreForm" || echo "⚠️ Check store form component"
```

### API Routes
```bash
# Check store API endpoints
test -f src/app/api/stores/route.ts && echo "✅ Stores API" || echo "❌ Missing stores API"
```

### Manual Testing
- [ ] Click "Sign Up" redirects to Auth0
- [ ] After login, redirected to /dashboard
- [ ] Create new store works
- [ ] Store appears in dashboard list
- [ ] Logout clears session

---

## **Phase 3: Product Management** ✓

### API Routes
```bash
# Check product API
test -f src/app/api/products/route.ts && echo "✅ Products API (GET, POST)" || echo "❌ Missing products API"
test -f src/app/api/products/\[id\]/route.ts && echo "✅ Products API (PATCH, DELETE)" || echo "❌ Missing product detail API"
```

### Pages & Components
```bash
# Check product pages
test -f src/app/dashboard/\[storeId\]/products/page.tsx && echo "✅ Product list page" || echo "❌ Missing product list"
test -f src/app/dashboard/\[storeId\]/products/new/page.tsx && echo "✅ Add product page" || echo "❌ Missing add product page"

# Check product components
test -f src/components/ProductCard.tsx && echo "✅ ProductCard component" || echo "⚠️ Check ProductCard"
test -f src/components/ProductForm.tsx && echo "✅ ProductForm component" || echo "⚠️ Check ProductForm"
```

### TanStack Query
```bash
# Check Query setup
grep -q "QueryClientProvider" src/app/layout.tsx && echo "✅ QueryClientProvider setup" || echo "❌ Missing QueryClientProvider"
grep -q "useQuery" src/lib -r && echo "✅ useQuery hooks exist" || echo "⚠️ Check data fetching"
grep -q "useMutation" src/lib -r && echo "✅ useMutation hooks exist" || echo "⚠️ Check mutations"
```

### Manual Testing
- [ ] Products list loads correctly
- [ ] Create product form validates inputs
- [ ] Cloudinary image upload works
- [ ] Edit product updates data
- [ ] Delete product removes from list
- [ ] Toast notifications appear

---

## **Phase 4: Storefront Display** ✓

### Public Routes
```bash
# Check storefront files
test -f src/app/store/\[slug\]/page.tsx && echo "✅ Store homepage" || echo "❌ Missing store homepage"
test -f src/app/store/\[slug\]/product/\[id\]/page.tsx && echo "✅ Product detail page" || echo "❌ Missing product detail"
```

### SEO & Performance
```bash
# Check for Server Components (no 'use client' directive)
! grep -q "'use client'" src/app/store/\[slug\]/page.tsx && echo "✅ Store page is Server Component" || echo "⚠️ Should be Server Component"

# Check for Next.js Image usage
grep -q "next/image" src/app/store -r && echo "✅ Using Next.js Image" || echo "⚠️ Use <Image> for optimization"
```

### Manual Testing
- [ ] Visit `/store/[your-slug]` shows products
- [ ] Only published products visible
- [ ] Product images load optimized
- [ ] Product detail page renders correctly
- [ ] Responsive design works (mobile, tablet, desktop)

---

## **Phase 5: Cart & Checkout** ✓

### Cart Implementation
```bash
# Check cart files
test -f src/contexts/CartContext.tsx && echo "✅ CartContext" || echo "❌ Missing CartContext"
test -f src/app/store/\[slug\]/cart/page.tsx && echo "✅ Cart page" || echo "❌ Missing cart page"
test -f src/app/store/\[slug\]/checkout/page.tsx && echo "✅ Checkout page" || echo "❌ Missing checkout page"
```

### Order API
```bash
# Check order endpoints
test -f src/app/api/orders/route.ts && echo "✅ Orders API" || echo "❌ Missing orders API"
test -f src/app/dashboard/\[storeId\]/orders/page.tsx && echo "✅ Admin orders page" || echo "❌ Missing admin orders"
```

### Manual Testing
- [ ] Add to cart updates cart count
- [ ] Cart persists after page refresh (localStorage)
- [ ] Remove from cart works
- [ ] Update quantity works
- [ ] Checkout form validates all fields
- [ ] Order creates successfully
- [ ] Order appears in admin dashboard

---

## **Phase 6: Deployment** ✓

### Production Readiness
```bash
# Check production build
npm run build && echo "✅ Build succeeds" || echo "❌ Build failed"

# Check no console.logs in production code
! grep -r "console.log" src/app src/components src/lib --exclude-dir=node_modules && echo "✅ No console.logs" || echo "⚠️ Remove console.logs"

# Check .env.local not committed
! git ls-files | grep -q ".env.local" && echo "✅ .env.local not in git" || echo "❌ REMOVE .env.local from git!"
```

### Vercel Deployment
```bash
# Check Vercel config (optional)
test -f vercel.json && echo "✅ Vercel config exists" || echo "⚠️ Using defaults"
```

### Manual Testing
- [ ] Application deploys to Vercel successfully
- [ ] Environment variables configured in Vercel dashboard
- [ ] Production database connection works
- [ ] Auth0 callbacks configured for production URL
- [ ] All features work in production
- [ ] No console errors in production

---

## **🎯 Quality Checks (All Phases)**

### Code Quality
```bash
# Run all quality checks
npm run lint && echo "✅ ESLint passed" || echo "❌ ESLint errors - fix before committing"
npm run typecheck && echo "✅ TypeScript passed" || echo "❌ TypeScript errors - fix before committing"
```

### TypeScript Strict Mode
```bash
# Verify strict mode is enabled
grep -q '"strict": true' tsconfig.json && echo "✅ Strict mode enabled" || echo "❌ Enable strict mode"
grep -q '"noUnusedLocals": true' tsconfig.json && echo "✅ No unused locals check" || echo "⚠️ Enable noUnusedLocals"
```

### Security Checks
```bash
# Verify .env.local is NOT in git
! git ls-files | grep -q ".env.local" && echo "✅ .env.local not tracked" || echo "🚨 REMOVE .env.local from git!"

# Check for hardcoded secrets (basic check)
! grep -r "sk_live_" src/ --exclude-dir=node_modules && echo "✅ No hardcoded API keys" || echo "🚨 Remove API keys from code!"
! grep -r "AUTH0_CLIENT_SECRET=" src/ && echo "✅ No hardcoded secrets" || echo "🚨 Remove secrets!"
```

### Database Security
```bash
# Check for SQL injection vulnerabilities (basic check)
! grep -r "prisma.\$queryRawUnsafe" src/ && echo "✅ No unsafe raw queries" || echo "⚠️ Use $queryRaw with parameterized queries"

# Verify RLS is enabled (check Supabase dashboard manually)
echo "⚠️ Manual check: Verify Row-Level Security is enabled in Supabase dashboard"
```

---

## **🚀 Pre-Commit Validation**

Run these checks before EVERY commit:

```bash
# Quick validation script
echo "🔍 Running pre-commit checks..."

# 1. TypeScript check
npm run typecheck || { echo "❌ TypeScript errors"; exit 1; }

# 2. ESLint
npm run lint || { echo "❌ ESLint errors"; exit 1; }

# 3. Check .env.local not committed
! git diff --cached --name-only | grep -q ".env.local" || { echo "🚨 ABORT: .env.local in commit"; exit 1; }

# 4. Check for console.logs (warning only)
git diff --cached | grep "console.log" && echo "⚠️ Warning: console.log found" || echo "✅ No console.logs"

echo "✅ All checks passed - ready to commit!"
```

---

## **📊 Build Validation**

### Production Build
```bash
# Test production build
npm run build

# Check for build warnings
npm run build 2>&1 | grep -i "warn" && echo "⚠️ Build warnings found" || echo "✅ Clean build"

# Check build size
du -sh .next/ | awk '{print "Build size: " $1}'
```

### Bundle Analysis (Optional)
```bash
# Install bundle analyzer
npm install -D @next/bundle-analyzer

# Analyze bundle
ANALYZE=true npm run build
```

---

## **✅ Phase Completion Checklist**

Before marking a phase as complete:

- [ ] All files/components created as planned
- [ ] `npm run typecheck` passes with no errors
- [ ] `npm run lint` passes with no errors
- [ ] Manual testing completed successfully
- [ ] All acceptance criteria met (from GitHub Issue)
- [ ] No console errors in browser dev tools
- [ ] Responsive design tested (mobile, tablet, desktop)
- [ ] Changes committed with conventional commit message
- [ ] Pull Request created (if using feature branch)
- [ ] Self-review completed (use `/review` checklist)
- [ ] Phase documentation updated

---

## **🎯 Final MVP Validation (Phase 6)**

Before deploying to production:

### Functionality
- [ ] Admin can sign up and login via Auth0
- [ ] Admin can create multiple stores
- [ ] Admin can create, edit, delete products
- [ ] Admin can view orders
- [ ] Customers can browse products on public storefront
- [ ] Customers can add products to cart
- [ ] Customers can complete checkout
- [ ] Orders appear in admin dashboard

### Security
- [ ] All admin routes protected by middleware
- [ ] API routes verify Auth0 session
- [ ] Database queries filtered by storeId
- [ ] No secrets in git history
- [ ] HTTPS enforced in production
- [ ] CORS configured properly

### Performance
- [ ] Lighthouse score > 80
- [ ] Images optimized with Next.js Image
- [ ] Server Components used where appropriate
- [ ] Database queries use indexes
- [ ] No N+1 query problems

### User Experience
- [ ] Loading states shown during async operations
- [ ] Error messages are user-friendly
- [ ] Success feedback via toast notifications
- [ ] Forms validate inputs before submission
- [ ] Mobile-responsive design

### Documentation
- [ ] README has installation instructions
- [ ] README includes screenshots
- [ ] ADRs document major decisions
- [ ] Environment variables documented
- [ ] API endpoints documented (if applicable)

---

## **Quick Validation Scripts**

### Create validation script
Save as `scripts/validate.sh`:

```bash
#!/bin/bash

echo "🔍 Running project validation..."
echo ""

echo "1. TypeScript Check"
npm run typecheck || exit 1
echo ""

echo "2. ESLint"
npm run lint || exit 1
echo ""

echo "3. Production Build"
npm run build || exit 1
echo ""

echo "4. Security Checks"
! git ls-files | grep -q ".env.local" || { echo "🚨 .env.local in git!"; exit 1; }
! grep -r "console.log" src/ --exclude-dir=node_modules || echo "⚠️ console.logs found"
echo ""

echo "✅ All validations passed!"
```

Make executable:
```bash
chmod +x scripts/validate.sh
./scripts/validate.sh
```

---

**Use this checklist after completing each phase to maintain quality and catch issues early.**
