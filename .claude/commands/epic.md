# Shopify Clone - Epic Breakdown Guide

## 📖 **What is an Epic?**

An **Epic** is a large body of work that can be broken down into smaller **User Stories**. Each user story represents a single feature or functionality from the user's perspective.

**Project Structure:**
```
Epic (2-4 weeks)
├── User Story #1 (2-8 hours)
├── User Story #2 (2-8 hours)
├── User Story #3 (2-8 hours)
└── User Story #4 (2-8 hours)
```

---

## **User Story Format**

```
As a [role], I want to [action], so that [benefit]
```

**Components:**
- **Role**: Who is this for? (Admin, Customer)
- **Action**: What do they want to do?
- **Benefit**: Why do they want this?

---

## **Epic 1 Example: Authentication & Store Management**

### Epic Description
Implement authentication system and allow Admins to create and manage multiple stores.

### User Stories

#### Issue #1: Admin Sign Up
```markdown
**User Story:**
As an Admin, I want to sign up using Auth0, so that I can access the platform securely.

**Acceptance Criteria:**
- [ ] Landing page displays "Sign Up" button
- [ ] Clicking "Sign Up" redirects to Auth0 Universal Login
- [ ] After successful signup, user is redirected to dashboard
- [ ] User data (sub, email, name) is synced to PostgreSQL
- [ ] Session cookie is created and encrypted

**Technical Tasks:**
- [ ] Create Auth0 route handlers in `/api/auth/[auth0]`
- [ ] Create landing page with Auth0 login button
- [ ] Create middleware to protect `/dashboard` routes
- [ ] Create user sync logic (Auth0 → PostgreSQL)
- [ ] Add UserProvider to root layout

**Definition of Done:**
- TypeScript check passes
- ESLint passes
- Manual testing completed (signup flow works)
- PR merged to main
```

#### Issue #2: View Dashboard
```markdown
**User Story:**
As an Admin, I want to view my dashboard after logging in, so that I can access my stores.

**Acceptance Criteria:**
- [ ] Dashboard displays welcome message with user name
- [ ] Dashboard shows list of user's stores (or empty state)
- [ ] Dashboard has "Create Store" button
- [ ] User can navigate back to dashboard from any admin page
- [ ] Unauthenticated users are redirected to login

**Technical Tasks:**
- [ ] Create `/dashboard` page component
- [ ] Fetch stores from `/api/stores` endpoint
- [ ] Display stores in a responsive grid
- [ ] Add empty state for new users
- [ ] Create navigation component

**Definition of Done:**
- Dashboard renders correctly
- Data fetching works with TanStack Query
- Responsive design (mobile, tablet, desktop)
- PR merged to main
```

#### Issue #3: Create New Store
```markdown
**User Story:**
As an Admin, I want to create a new store with a unique name, so that I can start adding products.

**Acceptance Criteria:**
- [ ] "Create Store" form has store name input
- [ ] Slug is auto-generated from store name
- [ ] Form validates store name is required
- [ ] Form validates slug is URL-safe
- [ ] Duplicate store slugs show error message
- [ ] After creation, user is redirected to store dashboard

**Technical Tasks:**
- [ ] Create Zod schema for store creation
- [ ] Create `POST /api/stores` endpoint
- [ ] Implement slug generation utility
- [ ] Create CreateStoreForm component with React Hook Form
- [ ] Add validation and error handling
- [ ] Update stores list after creation (TanStack Query)

**Definition of Done:**
- Form validation works correctly
- Duplicate slugs are prevented
- Success toast notification appears
- New store appears in dashboard list
- PR merged to main
```

#### Issue #4: Switch Between Stores
```markdown
**User Story:**
As an Admin with multiple stores, I want to switch between them, so that I can manage each store separately.

**Acceptance Criteria:**
- [ ] Store switcher dropdown in dashboard header
- [ ] Current store is highlighted
- [ ] Clicking store name switches active store
- [ ] Dashboard updates to show selected store's data
- [ ] Selected store persists across page navigation

**Technical Tasks:**
- [ ] Create store switcher component
- [ ] Add store selection state (Context or URL param)
- [ ] Update API routes to filter by selected store
- [ ] Style active store indicator
- [ ] Add keyboard navigation support

**Definition of Done:**
- Store switcher works smoothly
- Data updates when switching stores
- UI clearly indicates active store
- PR merged to main
```

#### Issue #5: Log Out
```markdown
**User Story:**
As an Admin, I want to log out securely, so that my session is terminated.

**Acceptance Criteria:**
- [ ] "Log Out" button in dashboard navigation
- [ ] Clicking "Log Out" terminates Auth0 session
- [ ] User is redirected to landing page
- [ ] Session cookie is cleared
- [ ] Attempting to access dashboard redirects to login

**Technical Tasks:**
- [ ] Add "Log Out" button to navigation
- [ ] Link to Auth0 logout endpoint (`/api/auth/logout`)
- [ ] Configure logout redirect URL in Auth0
- [ ] Test session termination

**Definition of Done:**
- Logout clears session completely
- User cannot access dashboard after logout
- Redirect works correctly
- PR merged to main
```

---

## **Epic 2 Example: Product Management**

### Epic Description
Enable Admins to create, edit, and delete products with image uploads.

### User Stories

#### Issue #6: View Product List
```markdown
**User Story:**
As an Admin, I want to view all my store's products, so that I can manage my inventory.

**Acceptance Criteria:**
- [ ] Product list page shows all products for selected store
- [ ] Each product displays name, price, image thumbnail, status
- [ ] Empty state shown when no products exist
- [ ] Products are paginated (if >20 products)
- [ ] Loading state shown while fetching

**Technical Tasks:**
- [ ] Create `/dashboard/[storeId]/products` page
- [ ] Create `GET /api/products?storeId=X` endpoint
- [ ] Create ProductCard component
- [ ] Implement product list with TanStack Query
- [ ] Add empty state component
- [ ] Style with Tailwind CSS grid

**Definition of Done:**
- Product list renders correctly
- Loading/error states handled
- Responsive design
- PR merged
```

---

## **Creating GitHub Issues from User Stories**

### Step 1: Navigate to GitHub Issues
Go to your repository → **Issues** tab → **New Issue**

### Step 2: Title Format
```
User Story: [Short description]
```

Examples:
- User Story: Admin Sign Up with Auth0
- User Story: Create New Store with Unique Slug
- User Story: Upload Product Images to Cloudinary

### Step 3: Issue Body Template
```markdown
## User Story
As a [role], I want to [action], so that [benefit].

## Acceptance Criteria
- [ ] Criterion 1
- [ ] Criterion 2
- [ ] Criterion 3

## Technical Tasks
- [ ] Task 1
- [ ] Task 2
- [ ] Task 3

## Definition of Done
- [ ] Feature works as expected
- [ ] TypeScript check passes (`npm run typecheck`)
- [ ] ESLint passes (`npm run lint`)
- [ ] Manual testing completed
- [ ] PR created and self-reviewed
- [ ] PR merged to main

## Related
Epic: Authentication & Store Management (#epic-1)
```

### Step 4: Add Labels
- `user-story` - Identifies this as a user story
- `epic-1-auth` - Groups by epic
- `phase-2` - Indicates which phase
- `priority-high` - If critical for MVP

### Step 5: Add to Project Board
- Assign to **Project**: Shopify Clone MVP
- Set **Status**: Backlog (or Ready if next to work on)
- Set **Iteration**: Week 1-2 (if using iterations)

---

## **Breaking Down Epics - Guidelines**

### Good User Story Characteristics (INVEST)

**I - Independent**: Can be completed without dependencies
**N - Negotiable**: Details can be discussed
**V - Valuable**: Delivers value to the user
**E - Estimable**: Can estimate time needed
**S - Small**: 2-8 hours of work
**T - Testable**: Clear acceptance criteria

### Example: Too Large ❌
```
As an Admin, I want a complete product management system
```
**Problem**: Too vague, weeks of work, not testable

### Example: Good Size ✅
```
As an Admin, I want to create a new product with name and price,
so that I can start building my store's catalog.
```
**Why**: Specific action, 2-4 hours, clear acceptance criteria

---

## **Epic Planning Process**

### 1. Define Epic Scope
```markdown
**Epic**: Authentication & Store Management
**Duration**: 10-15 hours (Week 1-2)
**Outcome**: Admins can sign up, create stores, and log out
```

### 2. List User Stories
Brainstorm all features needed:
- Admin sign up
- View dashboard
- Create store
- Switch stores
- Log out

### 3. Write Acceptance Criteria
For each story, define "done":
- What must work?
- What must be validated?
- What edge cases must be handled?

### 4. Create GitHub Issues
Convert each user story to an issue with:
- Clear title
- Acceptance criteria
- Technical tasks
- Definition of done

### 5. Prioritize
Order issues by dependency:
```
1. Issue #1 (Auth) ← Must do first
2. Issue #2 (Dashboard) ← Depends on #1
3. Issue #3 (Create Store) ← Depends on #2
4. Issue #4 (Switch Stores) ← Depends on #3
5. Issue #5 (Logout) ← Can do anytime
```

---

## **Epic Template**

```markdown
# Epic X: [Epic Name]

## Goal
[What is the high-level objective?]

## Success Criteria
- [ ] Criteria 1
- [ ] Criteria 2

## User Stories
- [ ] #1: [Story title]
- [ ] #2: [Story title]
- [ ] #3: [Story title]

## Estimated Duration
[X-Y hours or weeks]

## Phase
Phase [X] - [Phase Name]

## Dependencies
[List any dependencies on other epics or external factors]

## Technical Decisions
[List ADRs or technical approaches]

## Out of Scope
[What is explicitly NOT included in this epic]
```

---

## **Example: Epic 3 - Storefront Display**

```markdown
# Epic 3: Storefront Display

## Goal
Enable customers to browse products on a public storefront without authentication.

## Success Criteria
- [ ] Customers can visit `/store/[slug]` and see products
- [ ] Product detail pages load correctly
- [ ] Only published products are visible
- [ ] Pages are SEO-friendly (Server Components)
- [ ] Responsive design works on all devices

## User Stories
- [ ] #10: View Store Homepage
- [ ] #11: Browse Product Grid
- [ ] #12: View Product Detail Page
- [ ] #13: Search Products (optional)

## Estimated Duration
8-12 hours

## Phase
Phase 4

## Dependencies
- Requires Epic 2 (Product Management) to be complete
- Products must exist in database

## Technical Decisions
- Use Server Components for SEO
- Use Next.js Image for optimization
- Use Next.js dynamic routes for `/store/[slug]`

## Out of Scope
- Cart functionality (Epic 4)
- Customer authentication
- Product reviews
- Product variants (colors, sizes)
```

---

## **Tips for Writing Great User Stories**

### Focus on User Value
```markdown
❌ "Implement Auth0 SDK"
✅ "As an Admin, I want to sign up securely so my data is protected"
```

### Be Specific
```markdown
❌ "Admin can manage products"
✅ "As an Admin, I want to edit a product's price so I can run sales"
```

### Include Edge Cases
```markdown
**Acceptance Criteria:**
- [ ] Form validates price is positive number
- [ ] Form prevents duplicate product names
- [ ] Error messages are user-friendly
- [ ] Success toast appears after save
- [ ] Form is disabled while submitting
```

### Make it Testable
```markdown
**Manual Test Steps:**
1. Navigate to /dashboard/stores/1/products/new
2. Fill in product name: "Test Product"
3. Fill in price: "-10" (negative number)
4. Click "Create Product"
5. **Expected**: Error message "Price must be positive"
```

---

## **From Epic to Done - Workflow**

```
1. Define Epic
     ↓
2. Break into User Stories
     ↓
3. Create GitHub Issues
     ↓
4. Prioritize & Sequence
     ↓
5. Create Feature Branch for Issue
     ↓
6. Implement Story
     ↓
7. Create Pull Request
     ↓
8. Self-Review
     ↓
9. Merge to Main
     ↓
10. Issue Auto-Closes
     ↓
11. Move to Next Story
```

---

**Remember**: User stories are not technical specifications. They describe user needs. The technical implementation is up to you to design and execute.
