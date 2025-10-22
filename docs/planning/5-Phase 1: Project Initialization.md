# Phase 1: Project Initialization - Complete Setup Guide

**Goal:** Initialize Next.js project with all dependencies, configuration, and database schema  
**Estimated Time:** 3-5 hours  
**Status:** Ready to start

---

## Prerequisites (Verify Before Starting)

- [x] All external accounts created (Supabase, Auth0, Cloudinary, Vercel)
- [x] GitHub repository created: `shopify-clone`
- [x] GitHub Issues #1-5 created and linked to project board
- [x] ADR 0001 and ADR 0002 written
- [x] Git installed and configured locally
- [x] Node.js 18+ installed (`node --version`)
- [x] VS Code installed with recommended extensions

---

## Step 0: Add Phase 0 Artifacts to Repository

**Purpose:** Create a reference trail showing your planning process before coding

### 0.1 Create Local Repository Directory

```bash
# Navigate to your projects folder
cd ~/projects  # or wherever you keep projects

# Create project directory
mkdir shopify-clone
cd shopify-clone

# Initialize git
git init

# Connect to your GitHub repository
git remote add origin https://github.com/YOUR_USERNAME/shopify-clone.git
# Replace YOUR_USERNAME with your GitHub username

# Verify remote is set
git remote -v
```

**Expected output:**
```
origin  https://github.com/YOUR_USERNAME/shopify-clone.git (fetch)
origin  https://github.com/YOUR_USERNAME/shopify-clone.git (push)
```

- [ ] Local repository initialized
- [ ] Remote origin configured

---

### 0.2 Create Project Documentation Structure

```bash
# Create documentation folders
mkdir -p docs/adr
mkdir -p docs/planning
```

- [ ] `docs/adr/` folder created
- [ ] `docs/planning/` folder created

---

### 0.3 Add ADRs to Repository

**Option A: Create ADRs manually in VS Code**

Open VS Code in your project:
```bash
code .
```

Create these files with their content:

**File: `docs/adr/0001-use-auth0-for-authentication.md`**

```markdown
# ADR 0001: Use Auth0 for Authentication

## Status
Accepted

## Date
2025-10-21

## Context
The platform requires secure authentication for Admin users with potential for social logins and MFA in the future. Building authentication from scratch is time-consuming and introduces security risks. As a solo developer, I need a solution that:

- Handles security best practices automatically
- Reduces development time
- Provides room for future features (OAuth, MFA)
- Has a generous free tier
- Integrates well with Next.js App Router

## Decision
We will use Auth0 as our authentication provider with the `@auth0/nextjs-auth0` SDK.

## Consequences

### Positive
- Industry-standard security practices handled by Auth0
- OAuth, social logins, and MFA available out of the box
- Free tier supports 7,000 active users (sufficient for MVP and beyond)
- Reduces development time by 2-3 weeks
- JWT-based authentication works seamlessly with Next.js API routes
- Excellent documentation and Next.js SDK with App Router support
- Automatic session management with encrypted cookies

### Negative
- Vendor lock-in (switching providers would require significant refactoring)
- Free tier has limitations (7,000 users, 2 social connections)
- Requires internet connection for authentication (no offline mode)
- External dependency adds network latency
- Monthly costs if platform scales beyond free tier ($35/month for 1,000 additional users)
- Auth0 user data must be synchronized with application database

### Neutral
- Need to learn Auth0 SDK and configuration patterns
- Auth0 user IDs (`sub` claim) must be stored as foreign keys in database
- User data is split: Auth0 (authentication) vs. PostgreSQL (application data)
- Middleware configuration required to protect routes
```

**File: `docs/adr/0002-use-supabase-with-row-level-security.md`**

```markdown
# ADR 0002: Use Supabase with Row-Level Security for Multi-Tenancy

## Status
Accepted

## Date
2025-10-21

## Context
The platform allows Admins to create multiple stores, and each store's data must be isolated from others. We need a database solution that:

- Supports multi-tenancy with proper data isolation
- Provides PostgreSQL (relational data model fits e-commerce domain)
- Offers authentication as a potential Auth0 alternative
- Has file storage for future use
- Provides a free tier sufficient for MVP
- Enforces security at the database level, not just application code

### Multi-Tenancy Options Evaluated

**Option 1: Separate Database per Store**
- **Pros:** Complete isolation, independent scaling
- **Cons:** Complex management, expensive, cross-store queries impossible, over-engineering for MVP

**Option 2: Single Database with Application-Level Filtering**
- **Pros:** Simple implementation, easy cross-store analytics
- **Cons:** Security risk (developer error could leak data), no database-level enforcement

**Option 3: Single Database with Row-Level Security (RLS)**
- **Pros:** Database-enforced isolation, industry-standard (Shopify uses this), developer errors caught at DB level, simple architecture
- **Cons:** Slightly more complex setup than Option 2, all stores share same database instance

## Decision
We will use Supabase (managed PostgreSQL) with Row-Level Security (RLS) policies for multi-tenancy.

**Implementation Strategy:**
- Every table with store-specific data includes a `store_id` foreign key
- RLS policies filter rows based on session context (`app.current_store_id`)
- Application sets session variable when Admin selects a store
- PostgreSQL enforces isolation automatically

## Consequences

### Positive
- **Security:** Data isolation enforced at database level (bulletproof)
- **Free tier:** 500 MB storage, 2 GB file storage, 50 MB file uploads
- **Full PostgreSQL:** No vendor-specific SQL limitations
- **Real-time subscriptions:** Useful for order notifications (post-MVP)
- **Built-in Auth:** Alternative to Auth0 if needed in future
- **Built-in Storage:** Alternative to Cloudinary if needed
- **Auto REST API:** Can use direct SQL or generated REST endpoints
- **Developer experience:** Excellent dashboard, migrations, and CLI tools

### Negative
- **Shared resources:** All stores share same database instance (acceptable for MVP)
- **RLS complexity:** Policies must be carefully designed and tested
- **Session management:** Must properly set/clear `app.current_store_id` context
- **Free tier limits:** 500 MB may require upgrade if many stores with large catalogs
- **Vendor lock-in:** Supabase-specific features (like real-time) would need replacement if migrating

### Neutral
- PostgreSQL RLS requires understanding of policy syntax
- Must maintain dual user tables: Auth0 users + Supabase application users
- Connection pooling configuration needed for production scale
- Need monitoring to prevent one store from consuming all database resources
```

- [x] ADR 0001 created
- [x] ADR 0002 created

**Option B: Copy from Claude's project files**

If you have the ADRs in this Claude conversation's project files, you can copy them directly into your local repo.

---

### 0.4 Add Planning Documents

Copy the planning documents into your repo for reference:

**File: `docs/planning/MASTER_CHECKLIST.md`**
- Copy the full master checklist from the Claude project

**File: `docs/planning/shopify-clone-project-plan-v2.md`**
- Copy the comprehensive project plan

**File: `docs/planning/workflow-guide.md`**
- Copy the workflow confirmation document

```bash
# After creating these files manually in VS Code
ls -la docs/adr/
ls -la docs/planning/
```

**Expected output:**
```
docs/adr/
  0001-use-auth0-for-authentication.md
  0002-use-supabase-with-row-level-security.md

docs/planning/
  MASTER_CHECKLIST.md
  shopify-clone-project-plan-v2.md
  workflow-guide.md
```

- [x] Planning documents added to `docs/planning/`

---

### 0.5 Create Initial README.md

**File: `README.md`**

```markdown
# Shopify-Like E-Commerce Platform

A full-stack, multi-tenant e-commerce platform built with modern web technologies. This project demonstrates professional development practices, system architecture, and domain expertise in e-commerce.

## Project Status
🚧 **In Development** - Phase 1: Project Initialization

## Tech Stack

### Frontend
- **Framework:** Next.js 15 (App Router)
- **Language:** TypeScript (strict mode)
- **Styling:** Tailwind CSS 4
- **State Management:** TanStack Query v5

### Backend
- **Database:** Supabase (PostgreSQL)
- **ORM:** Prisma
- **Authentication:** Auth0
- **File Storage:** Cloudinary

### DevOps
- **Hosting:** Vercel
- **Version Control:** GitHub Flow
- **Project Management:** GitHub Projects + Issues

## Project Structure

```
shopify-clone/
├── docs/
│   ├── adr/              # Architectural Decision Records
│   └── planning/         # Project plans and checklists
├── src/
│   ├── app/              # Next.js App Router
│   ├── components/       # React components
│   ├── lib/              # Utility functions
│   └── types/            # TypeScript types
└── prisma/
    └── schema.prisma     # Database schema
```

## Development Workflow

This project follows professional development practices:
- **GitHub Flow:** Feature branches + Pull Requests
- **Conventional Commits:** Semantic commit messages
- **Atomic Commits:** One logical change per commit
- **Self-Reviewed PRs:** Quality gate before merge
- **ADRs:** Documented architectural decisions

## Getting Started

_Installation instructions will be added after Phase 1 setup_

## Features

### MVP Scope (Weeks 1-5)
- [ ] Admin authentication via Auth0
- [ ] Multi-store management dashboard
- [ ] Product CRUD operations
- [ ] Public storefront with product display
- [ ] Shopping cart (localStorage)
- [ ] Simulated checkout process
- [ ] Order management for admins

### Post-MVP Features
- Theme customization engine
- Staff permissions and roles
- Real payment integration (Stripe)
- Inventory tracking
- Analytics dashboard
- Email notifications

## Project Management

- **Issues:** [GitHub Issues](https://github.com/YOUR_USERNAME/shopify-clone/issues)
- **Project Board:** [GitHub Projects](https://github.com/YOUR_USERNAME/shopify-clone/projects)
- **ADRs:** [docs/adr/](./docs/adr/)

## Architectural Decisions

Key technical decisions are documented in ADRs:
- [ADR 0001: Auth0 for Authentication](./docs/adr/0001-use-auth0-for-authentication.md)
- [ADR 0002: Supabase with Row-Level Security](./docs/adr/0002-use-supabase-with-row-level-security.md)

## Developer

**Background:** MERN stack developer with real-world Shopify admin experience (Eleve Dancewear). Former ballet dancer with the National Ballet of Cuba, bringing operations and analytical mindset to software development.

## License

MIT License - See LICENSE file for details

---

_This project is part of a professional portfolio demonstrating full-stack capabilities, system design, and e-commerce domain expertise._
```

- [ ] README.md created

---

### 0.6 Create .gitignore Template

Before pushing, create a basic `.gitignore`:

**File: `.gitignore`**

```gitignore
# Dependencies
node_modules/
.pnp
.pnp.js

# Testing
coverage/
.nyc_output/

# Next.js
.next/
out/
build/
dist/

# Production
*.log
npm-debug.log*
yarn-debug.log*
yarn-error.log*

# Environment variables
.env
.env*.local
.env.development
.env.production

# Vercel
.vercel

# IDEs
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db

# Prisma
prisma/migrations/
```

- [ ] `.gitignore` created

---

### 0.7 Initial Commit to GitHub

```bash
# Check status
git status

# Stage all files
git add .

# Create initial commit
git commit -m "docs: add Phase 0 artifacts (ADRs, planning docs, README)"

# Push to GitHub
git push -u origin main
```

**Verify on GitHub:**
- Go to your repository URL
- You should see: README.md, docs/ folder with ADRs and planning docs

- [ ] Phase 0 artifacts committed
- [ ] Phase 0 artifacts pushed to GitHub
- [ ] Repository shows documentation on GitHub

---

## Step 1: Initialize Next.js Project

### 1.1 Create Next.js Application

```bash
# Run Next.js create command
npx create-next-app@latest .
```

**You'll be prompted with these questions:**

```
✔ Would you like to use TypeScript? … Yes
✔ Would you like to use ESLint? … Yes
✔ Would you like to use Tailwind CSS? … Yes
✔ Would you like your code inside a `src/` directory? … Yes
✔ Would you like to use App Router? (recommended) … Yes
✔ Would you like to use Turbopack for `next dev`? … No
✔ Would you like to customize the import alias (`@/*` by default)? … No
```

**Expected output:**
```
Creating a new Next.js app in /path/to/shopify-clone

Installing dependencies:
- react
- react-dom
- next

Installing devDependencies:
- typescript
- @types/node
- @types/react
- @types/react-dom
- postcss
- tailwindcss
- eslint
- eslint-config-next

Success! Created shopify-clone at /path/to/shopify-clone
```

- [ ] Next.js project initialized
- [ ] TypeScript configured
- [ ] Tailwind CSS configured
- [ ] ESLint configured

---

### 1.2 Verify Next.js Installation

```bash
# Test development server
npm run dev
```

**Expected output:**
```
   ▲ Next.js 15.0.0
   - Local:        http://localhost:3000
   - Environments: .env.local

 ✓ Starting...
 ✓ Ready in 2.3s
```

Open browser to `http://localhost:3000` - you should see the Next.js welcome page.

**Stop the server:** `Ctrl+C`

- [ ] Development server runs successfully
- [ ] Next.js welcome page displays

---

### 1.3 Update TypeScript Configuration (Strict Mode)

**File: `tsconfig.json`**

Find and update these settings:

```json
{
  "compilerOptions": {
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true,
    "noFallthroughCasesInSwitch": true,
    "forceConsistentCasingInFileNames": true,
    // ... keep other settings
  }
}
```

- [ ] TypeScript strict mode enabled

---

### 1.4 Update .gitignore for Database Files

**File: `.gitignore`** (append to existing)

```gitignore
# Prisma
prisma/migrations/
prisma/dev.db
prisma/dev.db-journal

# Database
*.db
*.db-journal
```

- [ ] `.gitignore` updated with database files

---

### 1.5 Commit Next.js Initialization

```bash
git add .
git commit -m "chore: initialize Next.js 15 project with TypeScript and Tailwind"
git push origin main
```

- [ ] Next.js initialization committed and pushed

---

## Step 2: Install Core Dependencies

### 2.1 Install Authentication (Auth0)

```bash
npm install @auth0/nextjs-auth0
```

**Verify installation:**
```bash
npm list @auth0/nextjs-auth0
```

Expected: `@auth0/nextjs-auth0@3.x.x`

- [ ] Auth0 SDK installed

---

### 2.2 Install Database (Supabase + Prisma)

```bash
npm install @supabase/supabase-js @supabase/ssr
npm install prisma @prisma/client
npm install -D prisma
```

**Verify installation:**
```bash
npm list @supabase/supabase-js prisma @prisma/client
```

- [ ] Supabase client installed
- [ ] Prisma installed

---

### 2.3 Install State Management (TanStack Query)

```bash
npm install @tanstack/react-query@latest
npm install @tanstack/react-query-devtools@latest
```

**Verify installation:**
```bash
npm list @tanstack/react-query
```

Expected: `@tanstack/react-query@5.x.x`

- [ ] TanStack Query installed

---

### 2.4 Install Form Handling & Validation (React Hook Form + Zod)

```bash
npm install react-hook-form
npm install @hookform/resolvers
npm install zod
```

**Verify installation:**
```bash
npm list react-hook-form zod
```

- [ ] React Hook Form installed
- [ ] Zod installed

---

### 2.5 Install Image Upload (Cloudinary)

```bash
npm install next-cloudinary
```

**Verify installation:**
```bash
npm list next-cloudinary
```

- [ ] Cloudinary SDK installed

---

### 2.6 Install UI Utilities (Optional but Recommended)

```bash
# Toast notifications
npm install sonner

# Utility for conditional classNames
npm install clsx
```

- [ ] Sonner (toast notifications) installed
- [ ] clsx (utility) installed

---

### 2.7 Verify All Dependencies

```bash
npm list --depth=0
```

**Expected packages (among others):**
```
├── @auth0/nextjs-auth0@3.x.x
├── @hookform/resolvers@3.x.x
├── @prisma/client@5.x.x
├── @supabase/ssr@0.x.x
├── @supabase/supabase-js@2.x.x
├── @tanstack/react-query@5.x.x
├── @tanstack/react-query-devtools@5.x.x
├── clsx@2.x.x
├── next@15.x.x
├── next-cloudinary@6.x.x
├── prisma@5.x.x
├── react@19.x.x
├── react-hook-form@7.x.x
├── sonner@1.x.x
├── zod@3.x.x
```

- [ ] All core dependencies installed
- [ ] No installation errors

---

### 2.8 Commit Dependencies

```bash
git add package.json package-lock.json
git commit -m "chore(deps): install core dependencies (Auth0, Supabase, Prisma, TanStack Query, Zod)"
git push origin main
```

- [ ] Dependencies committed and pushed

---

## Step 3: Environment Variables Setup

### 3.1 Create .env.local File

**File: `.env.local`** (root of project)

```bash
# Create the file
touch .env.local
```

**Open in VS Code and add:**

```env
# ===================================
# Auth0 Configuration
# ===================================
# Get these from: https://manage.auth0.com/dashboard
# Your Application > Settings

AUTH0_SECRET='use-openssl-rand-hex-32-to-generate'
AUTH0_BASE_URL='http://localhost:3000'
AUTH0_ISSUER_BASE_URL='https://YOUR_TENANT.auth0.com'
AUTH0_CLIENT_ID='your_auth0_client_id'
AUTH0_CLIENT_SECRET='your_auth0_client_secret'

# ===================================
# Supabase Configuration
# ===================================
# Get these from: https://supabase.com/dashboard
# Your Project > Settings > API

NEXT_PUBLIC_SUPABASE_URL='https://your-project.supabase.co'
NEXT_PUBLIC_SUPABASE_ANON_KEY='your_supabase_anon_key'
SUPABASE_SERVICE_ROLE_KEY='your_supabase_service_role_key'

# Database URL (Supabase)
# Get from: Your Project > Settings > Database > Connection string > URI
DATABASE_URL='postgresql://postgres:your_password@db.your-project.supabase.co:5432/postgres'

# ===================================
# Cloudinary Configuration
# ===================================
# Get these from: https://cloudinary.com/console
# Dashboard > Account Details

NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME='your_cloud_name'
CLOUDINARY_API_KEY='your_api_key'
CLOUDINARY_API_SECRET='your_api_secret'

# ===================================
# Next.js Configuration
# ===================================
NODE_ENV='development'
```

- [ ] `.env.local` file created

---

### 3.2 Generate Auth0 Secret

Run this command to generate a secure secret:

```bash
openssl rand -hex 32
```

**Copy the output** and replace `use-openssl-rand-hex-32-to-generate` in `.env.local`

Example output: `a8f2d9e4b7c3a1f6e8d2b5c9a4f7e3d1b6c8a2f5e9d4b7c3a6f8e1d5b9c2a4f7`

- [ ] AUTH0_SECRET generated and added

---

### 3.3 Configure Auth0 Application

**Go to:** https://manage.auth0.com/dashboard

1. Navigate to: **Applications > Applications**
2. Click your application (or create new "Regular Web Application")
3. Go to **Settings** tab

**Add these URLs:**

**Allowed Callback URLs:**
```
http://localhost:3000/api/auth/callback
```

**Allowed Logout URLs:**
```
http://localhost:3000
```

**Allowed Web Origins:**
```
http://localhost:3000
```

4. Click **Save Changes**

5. Copy credentials to `.env.local`:
   - **Domain** → `AUTH0_ISSUER_BASE_URL` (add `https://` prefix)
   - **Client ID** → `AUTH0_CLIENT_ID`
   - **Client Secret** → `AUTH0_CLIENT_SECRET`

- [ ] Auth0 application configured
- [ ] Auth0 credentials added to `.env.local`

---

### 3.4 Get Supabase Credentials

**Go to:** https://supabase.com/dashboard

1. Select your project
2. Go to: **Settings > API**

**Copy these values to `.env.local`:**
- **Project URL** → `NEXT_PUBLIC_SUPABASE_URL`
- **anon public** key → `NEXT_PUBLIC_SUPABASE_ANON_KEY`
- **service_role** key → `SUPABASE_SERVICE_ROLE_KEY`

3. Go to: **Settings > Database**
4. Find **Connection string** section
5. Select **URI** tab
6. Copy the connection string → `DATABASE_URL`
7. Replace `[YOUR-PASSWORD]` with your actual database password

Example:
```
postgresql://postgres:your_actual_password@db.abcdefghijk.supabase.co:5432/postgres
```

- [ ] Supabase URL and keys added
- [ ] Database URL configured

---

### 3.5 Get Cloudinary Credentials

**Go to:** https://cloudinary.com/console

1. Dashboard shows your account details
2. Copy these to `.env.local`:
   - **Cloud name** → `NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME`
   - **API Key** → `CLOUDINARY_API_KEY`
   - **API Secret** → `CLOUDINARY_API_SECRET`

- [ ] Cloudinary credentials added

---

### 3.6 Verify .env.local

```bash
# Check the file exists and is ignored by git
ls -la | grep .env.local

# Verify it's in .gitignore
cat .gitignore | grep .env
```

**Expected:** `.env.local` exists but NOT staged for commit

- [ ] `.env.local` file complete with all credentials
- [ ] `.env.local` confirmed in `.gitignore`

**⚠️ NEVER commit `.env.local` to Git**

---

## Step 4: Database Schema Creation

### 4.1 Access Supabase SQL Editor

1. Go to: https://supabase.com/dashboard
2. Select your project
3. Click: **SQL Editor** (left sidebar)
4. Click: **New query**

- [ ] Supabase SQL Editor open

---

### 4.2 Create Database Schema

**Copy this SQL into the editor:**

```sql
-- ===================================
-- Shopify Clone Database Schema (MVP)
-- ===================================

-- Drop existing tables if you're starting fresh
DROP TABLE IF EXISTS order_items CASCADE;
DROP TABLE IF EXISTS orders CASCADE;
DROP TABLE IF EXISTS products CASCADE;
DROP TABLE IF EXISTS stores CASCADE;
DROP TABLE IF EXISTS users CASCADE;

-- Users table (synced with Auth0)
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  auth0_user_id TEXT UNIQUE NOT NULL,
  email TEXT UNIQUE NOT NULL,
  name TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Stores table (one Admin can have multiple stores)
CREATE TABLE stores (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  store_name TEXT NOT NULL,
  store_slug TEXT UNIQUE NOT NULL,
  subdomain TEXT UNIQUE,
  description TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Products table (store-specific)
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  store_id INTEGER NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,
  image_urls JSONB DEFAULT '[]',
  status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published')),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Orders table (store-specific)
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  store_id INTEGER NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  customer_name TEXT NOT NULL,
  customer_email TEXT NOT NULL,
  shipping_address JSONB NOT NULL,
  total_amount DECIMAL(10, 2) NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);

-- Order items table (line items in an order)
CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id INTEGER NOT NULL REFERENCES products(id),
  product_name TEXT NOT NULL,  -- Snapshot at time of purchase
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  price_at_purchase DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);

-- ===================================
-- Indexes for Performance
-- ===================================

CREATE INDEX idx_users_auth0_id ON users(auth0_user_id);
CREATE INDEX idx_stores_user_id ON stores(user_id);
CREATE INDEX idx_stores_slug ON stores(store_slug);
CREATE INDEX idx_products_store_id ON products(store_id);
CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_orders_store_id ON orders(store_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);

-- ===================================
-- Row-Level Security (RLS) Policies
-- ===================================

-- Enable RLS on all tables
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE order_items ENABLE ROW LEVEL SECURITY;

-- For MVP: Allow all operations (we'll tighten this in production)
-- These policies allow full access during development
-- Post-MVP: Replace with proper policies based on app.current_store_id

CREATE POLICY "Allow all operations on products" ON products
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all operations on orders" ON orders
  FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Allow all operations on order_items" ON order_items
  FOR ALL USING (true) WITH CHECK (true);

-- ===================================
-- Updated_at Trigger Function
-- ===================================

-- Function to automatically update updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
  NEW.updated_at = NOW();
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Apply trigger to tables with updated_at
CREATE TRIGGER update_users_updated_at
  BEFORE UPDATE ON users
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_stores_updated_at
  BEFORE UPDATE ON stores
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_products_updated_at
  BEFORE UPDATE ON products
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_orders_updated_at
  BEFORE UPDATE ON orders
  FOR EACH ROW
  EXECUTE FUNCTION update_updated_at_column();

-- ===================================
-- Verification Query
-- ===================================

-- Run this to verify schema creation
SELECT 
  table_name,
  (SELECT COUNT(*) FROM information_schema.columns WHERE table_name = t.table_name) as column_count
FROM information_schema.tables t
WHERE table_schema = 'public' 
  AND table_type = 'BASE TABLE'
ORDER BY table_name;
```

**Click:** Run (or press Ctrl+Enter)

**Expected output:**
```
 table_name   | column_count
--------------+-------------
 order_items  |           6
 orders       |          10
 products     |           9
 stores       |           7
 users        |           5
```

- [ ] Database schema executed successfully
- [ ] 5 tables created
- [ ] RLS policies enabled
- [ ] Triggers created

---

### 4.3 Verify Tables in Supabase

1. Go to: **Table Editor** (left sidebar)
2. You should see: `users`, `stores`, `products`, `orders`, `order_items`
3. Click each table to see the structure

- [ ] All tables visible in Table Editor
- [ ] Column structure looks correct

---

## Step 5: Prisma Setup

### 5.1 Initialize Prisma

```bash
npx prisma init
```

**Expected output:**
```
✔ Your Prisma schema was created at prisma/schema.prisma
  You can now open it in your favorite editor.

Next steps:
1. Set the DATABASE_URL in the .env file to point to your existing database
2. Run prisma db pull to turn your database schema into a Prisma schema
3. Run prisma generate to generate the Prisma Client
```

**Files created:**
- `prisma/schema.prisma`
- `.env` (but we're using `.env.local`)

- [ ] Prisma initialized
- [ ] `prisma/schema.prisma` created

---

### 5.2 Configure Prisma Schema

**File: `prisma/schema.prisma`**

Replace entire content with:

```prisma
// Prisma Schema for Shopify Clone

generator client {
  provider = "prisma-client-js"
}

datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

model User {
  id           Int       @id @default(autoincrement())
  auth0UserId  String    @unique @map("auth0_user_id")
  email        String    @unique
  name         String?
  createdAt    DateTime  @default(now()) @map("created_at")
  updatedAt    DateTime  @updatedAt @map("updated_at")
  
  stores       Store[]
  
  @@map("users")
}

model Store {
  id          Int       @id @default(autoincrement())
  userId      Int       @map("user_id")
  storeName   String    @map("store_name")
  storeSlug   String    @unique @map("store_slug")
  subdomain   String?   @unique
  description String?
  createdAt   DateTime  @default(now()) @map("created_at")
  updatedAt   DateTime  @updatedAt @map("updated_at")
  
  user        User      @relation(fields: [userId], references: [id], onDelete: Cascade)
  products    Product[]
  orders      Order[]
  
  @@map("stores")
}

model Product {
  id          Int       @id @default(autoincrement())
  storeId     Int       @map("store_id")
  name        String
  description String?
  price       Decimal   @db.Decimal(10, 2)
  imageUrls   Json      @default("[]") @map("image_urls")
  status      String    @default("draft")
  createdAt   DateTime  @default(now()) @map("created_at")
  updatedAt   DateTime  @updatedAt @map("updated_at")
  
  store       Store     @relation(fields: [storeId], references: [id], onDelete: Cascade)
  orderItems  OrderItem[]
  
  @@map("products")
}

model Order {
  id              Int       @id @default(autoincrement())
  storeId         Int       @map("store_id")
  customerName    String    @map("customer_name")
  customerEmail   String    @map("customer_email")
  shippingAddress Json      @map("shipping_address")
  totalAmount     Decimal   @db.Decimal(10, 2) @map("total_amount")
  status          String    @default("pending")
  createdAt       DateTime  @default(now()) @map("created_at")
  updatedAt       DateTime  @updatedAt @map("updated_at")
  
  store           Store     @relation(fields: [storeId], references: [id], onDelete: Cascade)
  orderItems      OrderItem[]
  
  @@map("orders")
}

model OrderItem {
  id               Int      @id @default(autoincrement())
  orderId          Int      @map("order_id")
  productId        Int      @map("product_id")
  productName      String   @map("product_name")
  quantity         Int
  priceAtPurchase  Decimal  @db.Decimal(10, 2) @map("price_at_purchase")
  createdAt        DateTime @default(now()) @map("created_at")
  
  order            Order    @relation(fields: [orderId], references: [id], onDelete: Cascade)
  product          Product  @relation(fields: [productId], references: [id])
  
  @@map("order_items")
}
```

- [ ] Prisma schema configured

---

### 5.3 Generate Prisma Client

```bash
npx prisma generate
```

**Expected output:**
```
✔ Generated Prisma Client (v5.x.x) to ./node_modules/@prisma/client

You can now start using Prisma Client in your code:

import { PrismaClient } from '@prisma/client'
const prisma = new PrismaClient()
```

- [ ] Prisma Client generated

---

### 5.4 Create Prisma Client Singleton

**File: `src/lib/prisma.ts`**

```typescript
import { PrismaClient } from '@prisma/client'

const globalForPrisma = globalThis as unknown as {
  prisma: PrismaClient | undefined
}

export const prisma = globalForPrisma.prisma ?? new PrismaClient({
  log: process.env.NODE_ENV === 'development' ? ['query', 'error', 'warn'] : ['error'],
})

if (process.env.NODE_ENV !== 'production') {
  globalForPrisma.prisma = prisma
}
```

**Why this pattern:**
- Prevents multiple Prisma Client instances during hot reload in development
- Logs queries in development for debugging
- Production-safe singleton pattern

- [ ] Prisma client singleton created

---

### 5.5 Test Prisma Connection

**File: `src/app/test-db/route.ts`** (create for testing)

```typescript
import { NextResponse } from 'next/server'
import { prisma } from '@/lib/prisma'

export async function GET() {
  try {
    // Test database connection
    await prisma.$queryRaw`SELECT 1`
    
    // Count tables
    const userCount = await prisma.user.count()
    const storeCount = await prisma.store.count()
    
    return NextResponse.json({
      status: 'success',
      message: 'Database connection successful',
      data: {
        users: userCount,
        stores: storeCount,
      },
    })
  } catch (error) {
    console.error('Database connection error:', error)
    return NextResponse.json(
      {
        status: 'error',
        message: 'Database connection failed',
        error: error instanceof Error ? error.message : 'Unknown error',
      },
      { status: 500 }
    )
  }
}
```

**Test the connection:**

```bash
# Start dev server
npm run dev

# In another terminal or browser, visit:
# http://localhost:3000/test-db
```

**Expected response:**
```json
{
  "status": "success",
  "message": "Database connection successful",
  "data": {
    "users": 0,
    "stores": 0
  }
}
```

- [ ] Database connection test route created
- [ ] Connection test successful

---

## Step 6: Project Structure Setup

### 6.1 Create Core Directories

```bash
mkdir -p src/components/ui
mkdir -p src/components/providers
mkdir -p src/lib/api
mkdir -p src/types
mkdir -p src/hooks
```

**Verify:**
```bash
tree src -L 2
```

**Expected structure:**
```
src/
├── app/
├── components/
│   ├── providers/
│   └── ui/
├── hooks/
├── lib/
│   ├── api/
│   └── prisma.ts
└── types/
```

- [ ] Core directories created

---

### 6.2 Create TypeScript Type Definitions

**File: `src/types/index.ts`**

```typescript
import { Prisma } from '@prisma/client'

// User types
export type User = Prisma.UserGetPayload<{}>
export type UserWithStores = Prisma.UserGetPayload<{
  include: { stores: true }
}>

// Store types
export type Store = Prisma.StoreGetPayload<{}>
export type StoreWithProducts = Prisma.StoreGetPayload<{
  include: { products: true }
}>

// Product types
export type Product = Prisma.ProductGetPayload<{}>
export type ProductWithStore = Prisma.ProductGetPayload<{
  include: { store: true }
}>

// Order types
export type Order = Prisma.OrderGetPayload<{}>
export type OrderWithItems = Prisma.OrderGetPayload<{
  include: { orderItems: { include: { product: true } } }
}>

// Order Item types
export type OrderItem = Prisma.OrderItemGetPayload<{}>

// API Response types
export interface ApiResponse<T = unknown> {
  success: boolean
  data?: T
  error?: string
  message?: string
}

// Form types
export interface CreateStoreInput {
  storeName: string
  storeSlug: string
  description?: string
}

export interface CreateProductInput {
  storeId: number
  name: string
  description?: string
  price: number
  imageUrls: string[]
  status?: 'draft' | 'published'
}

export interface CreateOrderInput {
  storeId: number
  customerName: string
  customerEmail: string
  shippingAddress: {
    street: string
    city: string
    state: string
    zipCode: string
    country: string
  }
  items: Array<{
    productId: number
    productName: string
    quantity: number
    price: number
  }>
}
```

- [ ] Type definitions created

---

## Step 7: Final Commit

### 7.1 Review All Changes

```bash
git status
```

**Expected changes:**
- `package.json` and `package-lock.json` (dependencies)
- `tsconfig.json` (TypeScript config)
- `.gitignore` (updated)
- `prisma/schema.prisma` (database schema)
- `src/lib/prisma.ts` (Prisma client)
- `src/types/index.ts` (type definitions)
- `src/app/test-db/route.ts` (test route)
- New directories: `src/components/`, `src/lib/`, `src/types/`, etc.

---

### 7.2 Stage and Commit

```bash
git add .
git commit -m "feat: complete Phase 1 project initialization

- Configure Next.js 15 with TypeScript strict mode
- Install core dependencies (Auth0, Supabase, Prisma, TanStack Query, Zod)
- Create database schema in Supabase with RLS policies
- Configure Prisma ORM with type-safe client
- Set up project structure and type definitions
- Add database connection test route
- Configure environment variables (not committed)"
```

---

### 7.3 Push to GitHub

```bash
git push origin main
```

- [ ] All changes committed
- [ ] Changes pushed to GitHub

---

### 7.4 Verify on GitHub

1. Go to your repository on GitHub
2. Check that all files are present
3. Verify `.env.local` is NOT in the repository

- [ ] Repository up to date on GitHub
- [ ] `.env.local` not committed

---

## Step 8: Update Project Documentation

### 8.1 Update README.md

**File: `README.md`** (update the "Getting Started" section)

```markdown
## Getting Started

### Prerequisites
- Node.js 18+ 
- PostgreSQL (via Supabase)
- Auth0 account
- Cloudinary account

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/YOUR_USERNAME/shopify-clone.git
   cd shopify-clone
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env.local
   ```
   Fill in your credentials for Auth0, Supabase, and Cloudinary.

4. **Generate Prisma Client**
   ```bash
   npx prisma generate
   ```

5. **Run development server**
   ```bash
   npm run dev
   ```

6. **Open browser**
   Navigate to [http://localhost:3000](http://localhost:3000)

### Database

The database schema is managed by Prisma. To view the schema:
```bash
npx prisma studio
```

### Scripts

- `npm run dev` - Start development server
- `npm run build` - Build for production
- `npm run start` - Start production server
- `npm run lint` - Run ESLint
- `npx prisma studio` - Open Prisma Studio (database GUI)
- `npx prisma generate` - Generate Prisma Client
```

---

### 8.2 Create Environment Variables Example

**File: `.env.example`**

```env
# Auth0
AUTH0_SECRET=
AUTH0_BASE_URL=http://localhost:3000
AUTH0_ISSUER_BASE_URL=
AUTH0_CLIENT_ID=
AUTH0_CLIENT_SECRET=

# Supabase
NEXT_PUBLIC_SUPABASE_URL=
NEXT_PUBLIC_SUPABASE_ANON_KEY=
SUPABASE_SERVICE_ROLE_KEY=
DATABASE_URL=

# Cloudinary
NEXT_PUBLIC_CLOUDINARY_CLOUD_NAME=
CLOUDINARY_API_KEY=
CLOUDINARY_API_SECRET=

# Next.js
NODE_ENV=development
```

- [ ] `.env.example` created

---

### 8.3 Commit Documentation Updates

```bash
git add README.md .env.example
git commit -m "docs: update README with installation instructions and create .env.example"
git push origin main
```

- [ ] Documentation updated and pushed

---

## Phase 1 Complete! ✅

### Checklist Summary

**Setup Completed:**
- [x] Phase 0 artifacts added to repository
- [x] Next.js 15 initialized with TypeScript
- [x] All core dependencies installed
- [x] Environment variables configured
- [x] Database schema created in Supabase
- [x] Prisma ORM configured
- [x] Project structure established
- [x] Type definitions created
- [x] Database connection tested
- [x] Documentation updated

### What You Have Now

1. **Working Next.js Application**
   - TypeScript in strict mode
   - Tailwind CSS configured
   - ESLint configured

2. **Database**
   - PostgreSQL on Supabase
   - 5 tables created with relationships
   - RLS policies enabled
   - Prisma ORM configured

3. **Authentication Ready**
   - Auth0 SDK installed
   - Environment variables configured

4. **Project Structure**
   - Professional directory layout
   - Type-safe API responses
   - Reusable utility structure

### Verification

Run these commands to verify everything works:

```bash
# 1. Install dependencies
npm install

# 2. Generate Prisma Client
npx prisma generate

# 3. Start dev server
npm run dev

# 4. Test database connection
# Visit: http://localhost:3000/test-db
# Should return success message
```

---

## Next Steps: Phase 2 - Epic 1

**You're now ready to start Issue #1: Admin Sign Up with Auth0**

**Branch creation:**
```bash
# Go to Issue #1 on GitHub
# Click "Create a branch" from the Development section
# Name it: feat/auth0-signup
# Then checkout locally:
git fetch origin
git checkout feat/auth0-signup
```

**What you'll build:**
- Auth0 route handlers
- Middleware to protect routes
- Landing page with Sign Up button
- Dashboard page (protected)
- User sync to database

---

## Troubleshooting

### Common Issues

**Issue: `npm install` fails**
- Solution: Delete `node_modules/` and `package-lock.json`, then run `npm install` again

**Issue: Prisma can't connect to database**
- Check `DATABASE_URL` in `.env.local`
- Verify database password is correct
- Test connection: `npx prisma db pull`

**Issue: Auth0 secret not generating**
- Run: `node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"`
- Copy output to `AUTH0_SECRET`

**Issue: TypeScript errors in Prisma**
- Run: `npx prisma generate`
- Restart VS Code TypeScript server: Cmd+Shift+P → "TypeScript: Restart TS Server"

---

## Resources

- [Next.js 15 Docs](https://nextjs.org/docs)
- [Auth0 Next.js SDK](https://auth0.com/docs/quickstart/webapp/nextjs)
- [Prisma Docs](https://www.prisma.io/docs)
- [TanStack Query Docs](https://tanstack.com/query/latest)
- [Supabase Docs](https://supabase.com/docs)

---

**Phase 1 completion time:** 3-5 hours  
**You're ready for development!** 🚀