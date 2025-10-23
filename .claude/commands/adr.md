# Shopify Clone - Architectural Decision Record (ADR) Guide

## 📋 **What is an ADR?**

An **Architectural Decision Record** documents significant technical decisions made during the project. It captures:
- **What** decision was made
- **Why** this choice over alternatives
- **Consequences** (both positive and negative)

ADRs are stored in `docs/adr/` with sequential numbering.

---

## **When to Write an ADR**

Create an ADR when making decisions about:
- ✅ **Technology choices** (Auth0, Supabase, Prisma, etc.)
- ✅ **Architecture patterns** (multi-tenancy, state management)
- ✅ **Database design** (schema structure, RLS policies)
- ✅ **API design** (RESTful patterns, endpoint structure)
- ✅ **Security approaches** (authentication flow, data isolation)
- ✅ **Deployment strategy** (Vercel, environment configuration)

**Don't create ADRs for:**
- ❌ Minor implementation details
- ❌ Temporary solutions
- ❌ Obvious choices with no alternatives
- ❌ UI styling decisions

---

## **ADR Template**

```markdown
# ADR XXXX: [Title of Decision]

## Status
[Proposed | Accepted | Deprecated | Superseded]

## Date
YYYY-MM-DD

## Context
[Describe the problem you're trying to solve. Include:
- What is the current situation?
- What requirements led to this decision?
- What constraints exist?
- Why does this decision matter?]

## Decision
[State the decision clearly. What are you choosing to do?]

## Consequences

### Positive
[List benefits and advantages of this decision]

### Negative
[List drawbacks, trade-offs, and technical debt]

### Neutral
[List facts that are neither good nor bad but worth noting]

## Alternatives Considered
[Optional: List alternatives you evaluated and why you didn't choose them]
```

---

## **Example ADRs for This Project**

### ADR 0001: Use Auth0 for Authentication

**File**: `docs/adr/0001-use-auth0-for-authentication.md`

```markdown
# ADR 0001: Use Auth0 for Authentication

## Status
Accepted

## Date
2025-10-21

## Context
The platform requires secure authentication for Admin users with potential
for social logins and MFA in the future. Building authentication from scratch
is time-consuming and introduces security risks. As a solo developer, I need
a solution that:
- Handles security best practices automatically
- Reduces development time
- Provides room for future features (OAuth, MFA)
- Has a generous free tier
- Integrates well with Next.js App Router

## Decision
We will use Auth0 as our authentication provider with the
`@auth0/nextjs-auth0` SDK.

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
- Monthly costs if platform scales beyond free tier
- Auth0 user data must be synchronized with application database

### Neutral
- Need to learn Auth0 SDK and configuration patterns
- Auth0 user IDs (sub claim) must be stored as foreign keys in database
- User data is split: Auth0 (authentication) vs PostgreSQL (application data)
- Middleware configuration required to protect routes

## Alternatives Considered

**NextAuth.js**
- Pros: Open source, fully self-hosted, no vendor lock-in
- Cons: More setup required, need to handle security ourselves, fewer
  built-in features

**Supabase Auth**
- Pros: Already using Supabase for database, integrated solution
- Cons: Less mature than Auth0, fewer social login options, less flexible
  for custom auth flows

**Build from scratch**
- Pros: Complete control, no external dependencies
- Cons: 2-3 weeks additional development, security risks, need to maintain
```

---

### ADR 0002: Use Supabase with Row-Level Security

**File**: `docs/adr/0002-use-supabase-with-row-level-security.md`

```markdown
# ADR 0002: Use Supabase with Row-Level Security for Multi-Tenancy

## Status
Accepted

## Date
2025-10-21

## Context
The platform allows Admins to create multiple stores, and each store's data
must be isolated from others. We need a database solution that:
- Supports multi-tenancy with proper data isolation
- Provides PostgreSQL (relational data model fits e-commerce domain)
- Enforces security at the database level, not just application code
- Has file storage for future use
- Provides a free tier sufficient for MVP

### Multi-Tenancy Options Evaluated

**Option 1: Separate Database per Store**
- Pros: Complete isolation, independent scaling
- Cons: Complex management, expensive, cross-store queries impossible

**Option 2: Single Database with Application-Level Filtering**
- Pros: Simple implementation, easy cross-store analytics
- Cons: Security risk (developer error could leak data), no database-level
  enforcement

**Option 3: Single Database with Row-Level Security (RLS)**
- Pros: Database-enforced isolation, industry-standard (Shopify uses this),
  developer errors caught at DB level, simple architecture
- Cons: Slightly more complex setup than Option 2

## Decision
We will use Supabase (managed PostgreSQL) with Row-Level Security (RLS)
policies for multi-tenancy.

**Implementation Strategy:**
- Every table with store-specific data includes a `store_id` foreign key
- RLS policies filter rows based on session context (`app.current_store_id`)
- Application sets session variable when Admin selects a store
- PostgreSQL enforces isolation automatically

## Consequences

### Positive
- **Security**: Data isolation enforced at database level (bulletproof)
- **Free tier**: 500 MB storage, 2 GB file storage, 50 MB file uploads
- **Full PostgreSQL**: No vendor-specific SQL limitations
- **Real-time subscriptions**: Useful for order notifications (post-MVP)
- **Built-in Auth**: Alternative to Auth0 if needed in future
- **Built-in Storage**: Alternative to Cloudinary if needed
- **Developer experience**: Excellent dashboard, migrations, and CLI tools

### Negative
- **Shared resources**: All stores share same database instance
- **RLS complexity**: Policies must be carefully designed and tested
- **Session management**: Must properly set/clear `app.current_store_id`
- **Free tier limits**: 500 MB may require upgrade if many stores
- **Vendor lock-in**: Supabase-specific features would need replacement

### Neutral
- PostgreSQL RLS requires understanding of policy syntax
- Must maintain dual user tables: Auth0 users + Supabase application users
- Connection pooling configuration needed for production scale
```

---

## **ADR Numbering Convention**

```
docs/adr/
├── 0001-use-auth0-for-authentication.md
├── 0002-use-supabase-with-row-level-security.md
├── 0003-choose-tanstack-query-for-state.md
├── 0004-implement-cart-with-localstorage.md
└── 0005-deploy-to-vercel.md
```

- Use 4-digit numbers: `0001`, `0002`, etc.
- Use kebab-case for titles
- Store in `docs/adr/` directory

---

## **Creating a New ADR**

### Step 1: Identify the Decision
Ask yourself:
- Is this a significant technical choice?
- Are there multiple viable alternatives?
- Will future developers need to understand why this was chosen?

### Step 2: Research Alternatives
- List 2-3 alternative approaches
- Document pros/cons of each
- Consider trade-offs

### Step 3: Write the ADR
```bash
# Create new file
touch docs/adr/0003-choose-tanstack-query-for-state.md

# Open in editor
code docs/adr/0003-choose-tanstack-query-for-state.md
```

### Step 4: Use the Template
Fill in each section:
1. **Context**: Why are you making this decision?
2. **Decision**: What did you choose?
3. **Consequences**: What are the implications?

### Step 5: Commit to Git
```bash
git add docs/adr/0003-choose-tanstack-query-for-state.md
git commit -m "docs: add ADR 0003 for TanStack Query choice"
git push origin main
```

---

## **Example: ADR 0003 (State Management)**

```markdown
# ADR 0003: Choose TanStack Query for Server State Management

## Status
Accepted

## Date
2025-10-25

## Context
The application needs to manage server state (stores, products, orders) fetched
from API routes. Requirements:
- Cache API responses to reduce server load
- Automatically refetch data when stale
- Handle loading and error states consistently
- Support optimistic updates for better UX
- Integrate with Next.js App Router

Options evaluated:
1. Native React useState + useEffect
2. Redux Toolkit with RTK Query
3. TanStack Query (React Query)
4. SWR (Vercel)

## Decision
We will use TanStack Query v5 for server state management.

## Consequences

### Positive
- Automatic background refetching keeps data fresh
- Built-in caching reduces API calls
- Excellent DevTools for debugging cache
- First-class TypeScript support
- Optimistic updates for instant UI feedback
- Minimal boilerplate compared to Redux
- Active community and excellent documentation
- Handles loading/error states automatically

### Negative
- Additional dependency (40kb gzipped)
- Learning curve for query keys and cache invalidation
- Not suitable for complex client-side state (still need useState/Context)
- Need to structure query keys carefully for cache management

### Neutral
- Requires QueryClient provider at root layout
- Query keys must be consistent across the app
- Works alongside other state management (Context, useState)

## Alternatives Considered

**Redux Toolkit + RTK Query**
- Pros: Powerful, handles both client and server state
- Cons: More boilerplate, steeper learning curve, overkill for this project

**SWR**
- Pros: Lightweight, similar API to TanStack Query
- Cons: Less features, smaller community, less TypeScript support

**useState + useEffect**
- Pros: No dependencies, full control
- Cons: Must implement caching, refetching, error handling manually
```

---

## **ADR Best Practices**

### Do:
- ✅ Write ADRs **as decisions are made**, not retroactively
- ✅ Keep ADRs **concise** (1-2 pages max)
- ✅ Be **honest** about negative consequences
- ✅ Explain **context** so future readers understand why
- ✅ Include **alternatives** you considered
- ✅ Use **specific examples** when helpful

### Don't:
- ❌ Write ADRs for obvious choices
- ❌ Skip negative consequences
- ❌ Use jargon without explanation
- ❌ Make ADRs too long or academic
- ❌ Forget to commit ADRs to git

---

## **ADR Statuses**

- **Proposed**: Decision is being considered
- **Accepted**: Decision has been made and is active
- **Deprecated**: Decision is no longer recommended but still in use
- **Superseded**: Decision has been replaced (reference new ADR)

Example of superseded:
```markdown
# ADR 0002: Use localStorage for Cart

## Status
Superseded by ADR 0008

(Original content preserved for history)
```

---

## **Why ADRs Matter for Your Portfolio**

ADRs demonstrate:
- ✅ **Critical thinking**: You evaluated alternatives
- ✅ **Decision-making**: You can make informed technical choices
- ✅ **Communication**: You document decisions clearly
- ✅ **Honesty**: You acknowledge trade-offs
- ✅ **Professionalism**: You follow industry best practices

Hiring managers reviewing your GitHub will see that you:
- Think architecturally, not just tactically
- Understand there's no perfect solution, only trade-offs
- Document decisions for future team members
- Take ownership of technical direction

---

**Your ADRs are part of your story. Make them thoughtful and thorough.**
