# Shopify Clone - Professional E-Commerce Platform

## 🎯 **Project Mission**
Build a production-quality, multi-tenant e-commerce platform that demonstrates professional full-stack development practices, system architecture expertise, and e-commerce domain knowledge. This is a **portfolio piece** showcasing both technical capabilities and professional development discipline.

## 🏗️ **Architecture & Tech Stack**

### Frontend
- **Framework**: Next.js 15 (App Router) + React 19 + TypeScript (strict mode)
- **Routing**: Next.js file-based routing with dynamic routes
- **State Management**: TanStack Query v5 (server state, optimistic updates, caching)
- **Styling**: Tailwind CSS 4 (utility-first, responsive design)
- **Forms**: React Hook Form + Zod validation
- **Images**: Cloudinary (CDN, transformations)

### Backend
- **Database**: Supabase (PostgreSQL with Row-Level Security for multi-tenancy)
- **ORM**: Prisma (type-safe database client)
- **Authentication**: Auth0 (OAuth, JWT, session management)
- **API**: Next.js API Routes (RESTful endpoints)

### DevOps & Workflow
- **Hosting**: Vercel (auto-deployment from main branch)
- **Version Control**: GitHub Flow (main + feature branches)
- **Project Management**: GitHub Projects + Issues (linked to PRs)
- **Documentation**: Architectural Decision Records (ADRs) in `docs/adr/`

## 📋 **Current Phase Tracking**

**Active Phase**: Check with `/phase-status` command

**6-Week Roadmap:**
- **Phase 0**: Setup & Planning (docs, ADRs, GitHub setup)
- **Phase 1**: Project Initialization (Next.js, dependencies, database schema) ⏳
- **Phase 2**: Epic 1 - Authentication & Store Management (Auth0, dashboard)
- **Phase 3**: Epic 2 - Product Management (CRUD, Cloudinary uploads)
- **Phase 4**: Epic 3 - Storefront Display (public product browsing)
- **Phase 5**: Epic 4 - Cart & Checkout (localStorage cart, simulated checkout)
- **Phase 6**: Polish & Deployment (README, testing, Vercel deployment)
- **Phase 7+**: Post-MVP features (theming, staff permissions, analytics)

## ⚠️ **Development Workflow Rules**

### Professional Standards
- ✅ **GitHub Flow**: Feature branches → Pull Requests → Self-review → Merge to main
- ✅ **Conventional Commits**: Format: `type(scope): description` (e.g., `feat(auth): add Auth0 login`)
- ✅ **Atomic Commits**: One logical change per commit (revertible independently)
- ✅ **User Stories**: Every feature tracked as GitHub Issue (acceptance criteria defined)
- ✅ **ADRs**: Document significant architectural decisions in `docs/adr/`
- ✅ **Self-Review**: Critically review your own PRs before merging (quality gate)

### Manual Development Emphasis
- ❌ **NO auto-implementation**: You write the code manually (learning through doing)
- ❌ **NO skipping documentation**: README, ADRs, PR descriptions are mandatory
- ❌ **NO direct commits to main**: Always use feature branches + PRs
- ❌ **NO ambiguous commits**: Commit messages must be descriptive and conventional

## 🔄 **Development Pattern**

```
1. 📋 SELECT: Choose user story from GitHub Issues (linked to Epic)
2. 🌿 BRANCH: Create feature branch from main (linked to issue)
3. 🔨 IMPLEMENT: Write code following tech stack best practices
4. 🧪 TEST: Manual testing + TypeScript check + ESLint
5. 📝 COMMIT: Atomic commits with conventional messages
6. 🔍 PR: Create Pull Request, write detailed description
7. 👀 SELF-REVIEW: Use /review command checklist
8. ✅ MERGE: Squash and merge to main
9. 🗑️ CLEANUP: Delete feature branch
10. ➡️ NEXT: Move to next issue
```

## 📁 **Project Structure**

```
shopify-clone/
├── docs/
│   ├── adr/                      # Architectural Decision Records
│   │   ├── 0001-use-auth0.md
│   │   └── 0002-use-supabase-rls.md
│   └── planning/                 # Project plans and checklists
├── src/
│   ├── app/                      # Next.js App Router
│   │   ├── api/                  # API routes
│   │   │   ├── auth/[auth0]/     # Auth0 handlers
│   │   │   ├── stores/           # Store CRUD
│   │   │   ├── products/         # Product CRUD
│   │   │   └── orders/           # Order management
│   │   ├── dashboard/            # Admin dashboard (protected)
│   │   ├── store/[slug]/         # Public storefront (dynamic)
│   │   └── layout.tsx            # Root layout with providers
│   ├── components/
│   │   ├── providers/            # QueryProvider, UserProvider
│   │   └── ui/                   # Reusable UI components
│   ├── lib/
│   │   ├── api/                  # TanStack Query hooks
│   │   ├── prisma.ts             # Prisma client singleton
│   │   └── supabase/             # Supabase client utilities
│   ├── types/                    # TypeScript type definitions
│   └── hooks/                    # Custom React hooks
├── prisma/
│   └── schema.prisma             # Database schema (Prisma ORM)
└── .env.local                    # Environment variables (not committed!)
```

## 🎓 **Learning Objectives**

This project teaches:
1. **Professional Workflow**: GitHub Flow, PRs, Issues, ADRs, conventional commits
2. **Full-Stack Architecture**: Next.js 15 App Router, API routes, server/client components
3. **Authentication**: Auth0 integration, JWT, protected routes, middleware
4. **Database Design**: Multi-tenancy, Row-Level Security (RLS), relational schema
5. **Type Safety**: TypeScript strict mode, Zod validation, Prisma generated types
6. **State Management**: TanStack Query (caching, mutations, optimistic updates)
7. **E-Commerce Domain**: Products, orders, inventory, multi-store management
8. **Deployment**: Vercel hosting, environment variables, production configuration

## 🎨 **Development Principles**

### Process Over Speed
- Quality and correctness are prioritized over rapid feature completion
- Every PR should tell a clear story of what changed and why
- Code is written once but read many times - optimize for readability

### Documentation as Code
- ADRs capture the "why" behind technical decisions
- README evolves with the project (installation, architecture, screenshots)
- PR descriptions explain both implementation and rationale

### E-Commerce Domain Expertise
- Understand Shopify's architecture (multi-tenant, theming engine, admin/storefront separation)
- Implement professional patterns (product variants, order fulfillment, inventory tracking)
- Demonstrate real-world problem-solving (data isolation, slug-based routing, image optimization)

## 💡 **Key Architectural Decisions**

**Multi-Tenancy Strategy:**
- Single PostgreSQL database with Row-Level Security (RLS)
- Every table has `store_id` foreign key for data isolation
- Database-level enforcement (not just application logic)
- Follows Shopify's architectural pattern

**Authentication Flow:**
- Auth0 handles user sign-up, login, session management
- Auth0 user ID (`sub`) stored in `users.auth0_user_id`
- Next.js middleware protects admin routes (`/dashboard/*`)
- Encrypted session cookie with JWT

**Frontend Architecture:**
- Server Components for SEO-friendly product pages
- Client Components for interactive UI (cart, forms)
- TanStack Query for data fetching (caching, background refetch)
- Optimistic updates for smooth UX (favorites, cart modifications)

## 🚀 **Custom Commands Available**

Use these slash commands for guidance:
- `/phase-status` - Show current phase progress and next steps
- `/adr` - Guide for creating Architectural Decision Records
- `/epic` - Break down epics into user stories with acceptance criteria
- `/commit` - Conventional commit format guide and examples
- `/review` - Self-review checklist before merging PR
- `/workflow` - GitHub Flow workflow reminder
- `/schema` - Database schema reference and Prisma commands
- `/learn` - Learning resources for specific tech stack items

## 📊 **Success Metrics**

By project completion, you will have:
- ✅ Deployed MVP on Vercel with working end-to-end flow
- ✅ 30-40 atomic commits with conventional messages
- ✅ 15-20 closed GitHub Issues (user stories)
- ✅ 15-20 merged Pull Requests with self-review comments
- ✅ 7+ ADRs documenting architectural decisions
- ✅ Comprehensive README with screenshots and demo video
- ✅ Professional GitHub Projects board showing entire workflow
- ✅ Portfolio piece demonstrating full-stack capabilities + process discipline

## 🎯 **Current Focus**

Run `/phase-status` to see your current phase, completed tasks, and next steps.

**Remember:**
- This project is about demonstrating **professional engineering practices**
- The process is as important as the final product
- Every commit, PR, and ADR tells a story about your capabilities
- Employers will review your GitHub history - make it compelling!

---

**WORKFLOW**: You code manually. Commands provide guidance, not implementation. Quality and learning over speed.
