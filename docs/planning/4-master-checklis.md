# Shopify Clone: Master Development Checklist

**Project Goal:** Build a deployable MVP that demonstrates professional full-stack capabilities  
**Timeline:** 6 weeks (10-15 hours/week)  
**Success Criteria:** Record 2-minute demo video showing end-to-end flow

---

## Phase 0: Setup & Planning (Before Writing Code)
**Goal:** Establish professional foundation and create paper trail  
**Time:** 2-3 hours

- [x] **Create External Accounts**
  - [x] GitHub account (if needed)
  - [x] Supabase account + new project
  - [x] Auth0 account + new application
  - [x] Cloudinary account
  - [x] Vercel account (for deployment)

- [ ] **Documentation First**
  - [x] Create `docs/adr/` folder
  - [x] Write ADR 0001: Use Auth0 for Authentication
  - [x] Write ADR 0002: Use Supabase with RLS
  - [ ] Write ADR 0003: Use Cloudinary for Images
  - [ ] Write ADR 0006: Use GitHub Flow
  - [ ] (Optional: Write remaining ADRs or do them as you implement)

- [x] **GitHub Repository Setup**
  - [x] Create new public repository: `shopify-clone`
  - [ ] Add comprehensive README.md with project overview
  - [x] Push initial commit with ADRs

- [x] **GitHub Projects Board**
  - [x] Create new GitHub Project (Board template)
  - [x] Set up columns: Backlog, Ready, In Progress, In Review, Done
  - [x] Add custom fields: Epic, Priority, Story Points, Type
  - [x] Configure automations (PR opened â†’ In Review, etc.)

- [x] **Create Epic 1 User Stories as GitHub Issues**
  - [x] Issue #1: Admin sign up with Auth0
  - [x] Issue #2: View all stores dashboard
  - [x] Issue #3: Create new store
  - [x] Issue #4: Switch between stores
  - [x] Issue #5: Log out securely

---

## Phase 1: Project Initialization (Day 1-2)
**Goal:** Get a working Next.js app with all tools configured  
**Time:** 3-5 hours

- [ ] **Initialize Next.js Project**
  - [ ] Run `npx create-next-app@latest shopify-clone`
  - [ ] Choose: TypeScript âœ…, ESLint âœ…, Tailwind âœ…, App Router âœ…, src/ directory âœ…
  - [ ] Test: `npm run dev` works

- [ ] **Install Core Dependencies**
  - [ ] `npm install @auth0/nextjs-auth0`
  - [ ] `npm install @supabase/supabase-js @supabase/ssr`
  - [ ] `npm install @tanstack/react-query @tanstack/react-query-devtools`
  - [ ] `npm install prisma @prisma/client`
  - [ ] `npm install zod react-hook-form @hookform/resolvers`
  - [ ] `npm install next-cloudinary`
  - [ ] Test: No dependency errors

- [ ] **Environment Variables Setup**
  - [ ] Create `.env.local` file
  - [ ] Add all credentials (Auth0, Supabase, Cloudinary)
  - [ ] Add `.env.local` to `.gitignore`

- [ ] **Database Schema Creation**
  - [ ] Open Supabase SQL Editor
  - [ ] Run SQL to create tables: users, stores, products, orders, order_items
  - [ ] Enable RLS on tables (basic policies for MVP)

- [ ] **Prisma Setup**
  - [ ] `npx prisma init`
  - [ ] Update `schema.prisma` with DATABASE_URL
  - [ ] `npx prisma db pull` (pull schema from Supabase)
  - [ ] `npx prisma generate` (generate Prisma Client)
  - [ ] Create `lib/prisma.ts` singleton

- [ ] **Initial Commit & Push**
  - [ ] `git add .`
  - [ ] `git commit -m "chore: initialize Next.js project with dependencies"`
  - [ ] `git push origin main`

---

## Phase 2: Epic 1 - Authentication & Store Setup (Week 1-2)
**Goal:** Users can sign up, create stores, and manage them  
**Time:** 10-15 hours

### Feature 1: Auth0 Integration
- [ ] Create branch: `git checkout -b feat/auth0-integration`
- [ ] Set up Auth0 route handler: `app/api/auth/[auth0]/route.ts`
- [ ] Create middleware to protect routes: `middleware.ts`
- [ ] Wrap app with UserProvider in `app/layout.tsx`
- [ ] Create landing page with "Sign Up" / "Login" buttons
- [ ] **Test:** Can sign up and log in
- [ ] Create PR, self-review, merge to main
- [ ] **Document:** Update README with Auth0 setup instructions

### Feature 2: Dashboard & Store Creation
- [ ] Create branch: `git checkout -b feat/store-management`
- [ ] Create `/dashboard` route (protected)
- [ ] Build "Create Store" form with slug validation
- [ ] Create API route: `POST /api/stores`
- [ ] Display list of user's stores on dashboard
- [ ] Implement store selection/switching
- [ ] **Test:** Can create multiple stores and switch between them
- [ ] Create PR, self-review, merge to main
- [ ] **Document:** Add screenshots to README

### Feature 3: Admin Layout & Navigation
- [ ] Create branch: `git checkout -b feat/admin-layout`
- [ ] Build admin dashboard layout with sidebar
- [ ] Create navigation menu (Products, Orders, Settings)
- [ ] Add store switcher in header
- [ ] Add logout button
- [ ] **Test:** Navigation works, layout is responsive
- [ ] Create PR, self-review, merge to main

- [ ] **Epic 1 Complete:** Update GitHub Projects board
- [ ] **Document:** Write ADR 0005 (TanStack Query) if not done yet

---

## Phase 3: Epic 2 - Product Management (Week 3)
**Goal:** Admin can create, edit, and delete products  
**Time:** 10-15 hours

### Feature 1: TanStack Query Setup
- [ ] Create branch: `git checkout -b feat/tanstack-query-setup`
- [ ] Create QueryProvider in `components/providers/query-provider.tsx`
- [ ] Add QueryProvider to root layout
- [ ] Create API functions in `lib/api/products.ts`
- [ ] Create PR, self-review, merge to main

### Feature 2: Product List Page
- [ ] Create branch: `git checkout -b feat/product-list`
- [ ] Create `/dashboard/[storeId]/products` route
- [ ] Build ProductList component using useQuery
- [ ] Add "Add Product" button
- [ ] Handle empty state ("No products yet")
- [ ] **Test:** Product list displays correctly
- [ ] Create PR, self-review, merge to main

### Feature 3: Add Product Form
- [ ] Create branch: `git checkout -b feat/add-product`
- [ ] Create `/dashboard/[storeId]/products/new` route
- [ ] Build product form with Zod validation
- [ ] Integrate Cloudinary image upload widget
- [ ] Create API route: `POST /api/products`
- [ ] Use useMutation for form submission
- [ ] **Test:** Can create product with image
- [ ] Create PR, self-review, merge to main

### Feature 4: Edit & Delete Products
- [ ] Create branch: `git checkout -b feat/edit-delete-products`
- [ ] Create edit product page
- [ ] Create API routes: `PATCH /api/products/[id]`, `DELETE /api/products/[id]`
- [ ] Add delete confirmation modal
- [ ] **Test:** Can edit and delete products
- [ ] Create PR, self-review, merge to main

- [ ] **Epic 2 Complete:** Update GitHub Projects board
- [ ] **Document:** Add product management screenshots to README

---

## Phase 4: Epic 3 - Storefront Display (Week 4)
**Goal:** Customers can browse products on public storefront  
**Time:** 8-12 hours

### Feature 1: Storefront Homepage
- [ ] Create branch: `git checkout -b feat/storefront-homepage`
- [ ] Create `/store/[slug]` route (public, no auth required)
- [ ] Fetch store by slug from database
- [ ] Build ProductGrid component
- [ ] Display only "published" products
- [ ] Add responsive Tailwind styling (mobile + desktop)
- [ ] **Test:** Storefront displays in incognito mode
- [ ] Create PR, self-review, merge to main

### Feature 2: Product Detail Page
- [ ] Create branch: `git checkout -b feat/product-detail`
- [ ] Create `/store/[slug]/product/[id]` route
- [ ] Display product image, name, description, price
- [ ] Add "Add to Cart" button (placeholder for now)
- [ ] Style with Tailwind
- [ ] **Test:** Product details display correctly
- [ ] Create PR, self-review, merge to main

### Feature 3: Storefront Polish
- [ ] Create branch: `git checkout -b feat/storefront-polish`
- [ ] Add store name/logo to storefront header
- [ ] Improve product card hover effects
- [ ] Add loading skeletons
- [ ] Ensure mobile responsiveness
- [ ] **Test:** Storefront looks professional on all devices
- [ ] Create PR, self-review, merge to main

- [ ] **Epic 3 Complete:** Update GitHub Projects board
- [ ] **Document:** Add storefront screenshots to README

---

## Phase 5: Epic 4 - Cart & Checkout (Week 5)
**Goal:** Customers can add to cart and complete simulated checkout  
**Time:** 10-15 hours

### Feature 1: Shopping Cart (localStorage)
- [ ] Create branch: `git checkout -b feat/shopping-cart`
- [ ] Create CartContext with localStorage persistence
- [ ] Add "Add to Cart" functionality to product pages
- [ ] Create cart icon with item count in header
- [ ] Create `/store/[slug]/cart` page
- [ ] Display cart items with quantities and total
- [ ] Add "Remove from Cart" functionality
- [ ] **Test:** Cart persists across page refreshes
- [ ] Create PR, self-review, merge to main

### Feature 2: Checkout Flow
- [ ] Create branch: `git checkout -b feat/checkout`
- [ ] Create `/store/[slug]/checkout` route
- [ ] Build checkout form (Name, Email, Shipping Address)
- [ ] Add Zod validation to checkout form
- [ ] Create API route: `POST /api/orders`
- [ ] Handle order creation in database
- [ ] Clear cart after successful order
- [ ] **Test:** Can complete checkout
- [ ] Create PR, self-review, merge to main

### Feature 3: Order Confirmation & Admin View
- [ ] Create branch: `git checkout -b feat/order-confirmation`
- [ ] Create `/store/[slug]/order-confirmation/[orderId]` page
- [ ] Display order summary to customer
- [ ] Create `/dashboard/[storeId]/orders` route for admin
- [ ] Display list of orders in admin dashboard
- [ ] Show order details (customer, items, total)
- [ ] **Test:** Admin can view orders
- [ ] Create PR, self-review, merge to main

- [ ] **Epic 4 Complete:** Update GitHub Projects board
- [ ] **MVP Complete! ðŸŽ‰** All core features working

---

## Phase 6: Polish, Testing & Deployment (Week 6)
**Goal:** Deploy a production-ready MVP to Vercel  
**Time:** 8-12 hours

### Documentation & README
- [ ] Create branch: `git checkout -b docs/comprehensive-readme`
- [ ] Write comprehensive README.md
  - [ ] Project overview and tech stack
  - [ ] Installation instructions
  - [ ] Environment variables list
  - [ ] Screenshots of all major features
  - [ ] Demo video or GIF
  - [ ] Architecture overview
  - [ ] Link to ADRs
- [ ] Create PR, self-review, merge to main

### UI/UX Polish
- [ ] Create branch: `git checkout -b polish/ui-improvements`
- [ ] Ensure consistent spacing and colors across all pages
- [ ] Add loading states to all async operations
- [ ] Add toast notifications for success/error messages
- [ ] Fix any visual bugs
- [ ] Improve mobile experience
- [ ] **Test:** Everything looks polished
- [ ] Create PR, self-review, merge to main

### Testing (Optional but Recommended)
- [ ] Create branch: `git checkout -b test/add-unit-tests`
- [ ] Write tests for critical utility functions
- [ ] Write tests for API routes
- [ ] Write tests for form validation
- [ ] Create PR, self-review, merge to main

### Vercel Deployment
- [ ] Create Vercel account (if not done)
- [ ] Connect GitHub repository to Vercel
- [ ] Add environment variables in Vercel dashboard
- [ ] Configure production domain (optional: custom domain)
- [ ] Deploy: `git push origin main` (auto-deploys)
- [ ] **Test:** Production site works end-to-end
- [ ] Update Auth0 callback URLs with production URL
- [ ] Test authentication on production

### Final Demo Video
- [ ] Record 2-minute demo video showing:
  - [ ] Sign up and create store
  - [ ] Add product with image
  - [ ] Visit storefront (incognito mode)
  - [ ] Add to cart and checkout
  - [ ] View order in admin dashboard
- [ ] Upload video to YouTube/Loom
- [ ] Add video link to README

### GitHub Projects Cleanup
- [ ] Review all issues are closed
- [ ] Review all PRs are merged
- [ ] Archive completed project board (optional)
- [ ] Take screenshot of completed project board

---

## Phase 7: Post-MVP (Optional Future Enhancements)

### Quick Wins (1-2 hours each)
- [ ] Add product search functionality
- [ ] Add product filtering by category
- [ ] Add pagination to product list
- [ ] Add order status updates (pending â†’ shipped)
- [ ] Add email notifications (using a service like Resend)

### Medium Features (4-8 hours each)
- [ ] Epic 5: Order Management (status updates, fulfillment)
- [ ] Epic 6: Theme Customization (colors, fonts)
- [ ] Add inventory tracking
- [ ] Add product variants (size, color)
- [ ] Add customer registration (for order history)

### Advanced Features (1-2 weeks each)
- [ ] Epic 7: Multi-user Permissions (staff roles)
- [ ] Epic 8: Analytics Dashboard
- [ ] Real payment integration (Stripe)
- [ ] Email marketing integration
- [ ] SEO optimization

---

## Ongoing Best Practices

### For Every Feature:
1. Create GitHub Issue from user story
2. Create branch from issue: `git checkout -b type/feature-name`
3. Make atomic commits with conventional commit messages
4. Push branch and create Pull Request
5. Self-review in "Files changed" tab
6. Link PR to issue with "Closes #X"
7. Merge PR (auto-closes issue, moves card to Done)
8. Delete feature branch
9. Pull latest main: `git pull origin main`

### Weekly:
- [ ] Review completed work
- [ ] Update README with new screenshots
- [ ] Identify blockers or challenges
- [ ] Plan next week's goals

### Documentation:
- [ ] Write ADR when making significant architectural decision
- [ ] Update README when adding new features
- [ ] Comment complex code
- [ ] Keep project plan updated

---

## Success Metrics

By the end of Week 6, you should have:
- âœ… Deployed, working MVP on Vercel
- âœ… 30-40 commits with clean Git history
- âœ… 15-20 closed GitHub Issues
- âœ… 15-20 merged Pull Requests
- âœ… 7 ADRs documenting key decisions
- âœ… Comprehensive README with demo video
- âœ… Professional GitHub Projects board showing entire workflow
- âœ… Portfolio piece that demonstrates:
  - Full-stack capabilities
  - Professional development process
  - Product thinking (user stories, MVP scope)
  - System architecture (multi-tenancy, theming considerations)
  - Domain expertise (e-commerce)

---

## Emergency Contacts / Resources

**If Stuck:**
- Auth0 Docs: https://auth0.com/docs/quickstart/webapp/nextjs
- Supabase Docs: https://supabase.com/docs
- TanStack Query Docs: https://tanstack.com/query/latest
- Prisma Docs: https://www.prisma.io/docs
- Next.js 15 Docs: https://nextjs.org/docs

**Community Help:**
- Stack Overflow
- Next.js Discord
- Supabase Discord
- Reddit: r/nextjs, r/webdev

---

**Remember:** This is a marathon, not a sprint. Focus on completing one phase at a time. The goal is a polished MVP that demonstrates professional capabilities, not a feature-complete platform.

**You've got this!** ðŸš€

*Last Updated: October 15, 2025*