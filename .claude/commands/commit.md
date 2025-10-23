# Shopify Clone - Conventional Commit Guide

## 📝 **Commit Message Format**

This project follows **Conventional Commits** specification for clear, semantic commit history.

---

## **Basic Format**

```
<type>(<scope>): <description>

[optional body]

[optional footer(s)]
```

### Components

**Type** (required): What kind of change
**Scope** (optional): What part of codebase
**Description** (required): Short summary (imperative mood)
**Body** (optional): Detailed explanation
**Footer** (optional): Breaking changes, issue references

---

## **Commit Types**

### `feat` - New Feature
Adds new functionality to the codebase

```bash
feat(auth): add Auth0 login route handlers
feat(stores): implement store creation API endpoint
feat(products): add Cloudinary image upload widget
feat(cart): implement localStorage cart persistence
```

### `fix` - Bug Fix
Fixes a bug or error

```bash
fix(auth): resolve session cookie expiration issue
fix(products): correct price validation in form
fix(stores): handle duplicate slug error properly
fix(cart): prevent negative quantities
```

### `docs` - Documentation
Changes to documentation only

```bash
docs: add installation instructions to README
docs: create ADR for multi-tenancy approach
docs(api): document store creation endpoint
docs: update Phase 2 completion checklist
```

### `style` - Code Style
Formatting, whitespace, missing semicolons (no code logic change)

```bash
style: format files with Prettier
style(components): fix indentation in ProductCard
style: remove unused imports
```

### `refactor` - Code Refactoring
Code change that neither fixes bug nor adds feature

```bash
refactor(api): extract Prisma error handling to utility
refactor(auth): simplify user sync logic
refactor: move type definitions to separate file
```

### `test` - Tests
Adding or updating tests

```bash
test(stores): add unit tests for slug validation
test: add E2E test for checkout flow
test(api): add integration tests for product CRUD
```

### `chore` - Maintenance
Build process, dependencies, tooling

```bash
chore(deps): upgrade Next.js to 15.1.0
chore: configure ESLint for TypeScript strict mode
chore: update .gitignore for Prisma files
chore(deps): install TanStack Query v5
```

### `perf` - Performance
Code change that improves performance

```bash
perf(products): implement pagination for product list
perf: optimize image loading with Next.js Image
perf(db): add database indexes for queries
```

---

## **Scopes (Optional)**

Scope indicates which part of the codebase is affected:

```bash
feat(auth): ...      # Authentication-related
feat(stores): ...    # Store management
feat(products): ...  # Product management
feat(orders): ...    # Order management
feat(cart): ...      # Shopping cart
feat(ui): ...        # UI components
feat(api): ...       # API routes
feat(db): ...        # Database/Prisma
```

---

## **Writing Good Descriptions**

### Rules
1. **Imperative mood**: "add" not "added" or "adds"
2. **Lowercase**: No capitalization
3. **No period**: Don't end with `.`
4. **50 characters max**: Be concise
5. **Clear and specific**: What does this do?

### Good Examples ✅
```bash
feat(auth): add Auth0 session middleware
fix(products): validate price is positive number
docs: create ADR 0003 for state management choice
refactor(api): extract error handling utility
chore(deps): upgrade Prisma to latest version
```

### Bad Examples ❌
```bash
feat: Added some stuff         # Vague, past tense
Fix bug.                       # Not specific enough
Update files                   # What files? What change?
feat(auth) add feature         # Missing colon
FEAT: BIG CHANGE               # Uppercase
```

---

## **Commit Body (Optional)**

Use the body to explain:
- **What** changed (if not obvious)
- **Why** you made this change
- **How** it solves the problem

```bash
feat(stores): implement slug validation

Store slugs must be unique and URL-safe. This adds:
- Zod schema validation for slug format
- Database uniqueness check before creation
- User-friendly error messages

The validation prevents duplicate store URLs and ensures
SEO-friendly paths.
```

---

## **Footer (Optional)**

### Breaking Changes
```bash
feat(api)!: change store creation endpoint response format

BREAKING CHANGE: The response now returns `{ data: { store } }`
instead of `{ store }` to maintain API consistency.
```

### Issue References
```bash
feat(auth): add login page

Implements user story from issue.

Closes #1
```

---

## **Example Workflow**

### Scenario: Implementing Auth0 Integration

**Multiple atomic commits:**

```bash
# 1. Install dependency
chore(deps): install @auth0/nextjs-auth0 package

# 2. Add route handlers
feat(auth): add Auth0 route handlers in /api/auth/[auth0]

# 3. Add middleware
feat(auth): create middleware to protect dashboard routes

Middleware checks for Auth0 session and redirects
unauthenticated users to login page.

# 4. Update layout
feat(auth): wrap app with UserProvider for session context

# 5. Add login page
feat(auth): create landing page with login button

# 6. Add user sync
feat(auth): sync Auth0 users to Prisma database

After successful login, user data from Auth0 (sub, email, name)
is synchronized to our PostgreSQL database for relational queries.

Closes #1
```

---

## **Common Patterns**

### Initial Setup
```bash
chore: initialize Next.js project with TypeScript
chore(deps): install core dependencies
feat(db): create database schema with 5 tables
feat(db): configure Prisma client with singleton pattern
docs: add ADR 0001 for Auth0 authentication choice
```

### Feature Implementation
```bash
feat(stores): create store API endpoints (GET, POST)
feat(stores): add store creation form with validation
feat(stores): implement store switcher in dashboard header
test(stores): add unit tests for store CRUD operations
```

### Bug Fixes
```bash
fix(auth): handle missing email in Auth0 profile
fix(products): prevent form submission with invalid data
fix(db): resolve Prisma connection pool exhaustion
```

### Documentation
```bash
docs: update README with installation instructions
docs: create ADR 0002 for Supabase RLS decision
docs(api): add JSDoc comments to API route handlers
```

---

## **Quick Reference**

```bash
# Feature
git commit -m "feat(scope): add feature description"

# Bug fix
git commit -m "fix(scope): resolve specific bug"

# Documentation
git commit -m "docs: update documentation"

# Refactor
git commit -m "refactor(scope): improve code without changing behavior"

# Chore
git commit -m "chore: update build configuration"
```

---

## **Tools**

### Check Commit Message Before Pushing
```bash
# View last commit message
git log -1 --pretty=%B

# Amend commit message if needed (before pushing!)
git commit --amend -m "feat(auth): add Auth0 login handlers"
```

### Commit with Multi-line Message
```bash
git commit -m "feat(stores): add store creation form" -m "
This form includes:
- Store name input with validation
- Slug generation from store name
- Description textarea (optional)
- Form submission with error handling

Closes #3
"
```

---

## **Why Conventional Commits Matter**

### For Your Portfolio
- ✅ Shows professional development practices
- ✅ Easy to generate changelogs
- ✅ Clear project history for reviewers
- ✅ Demonstrates attention to detail

### For Collaboration
- ✅ Teammates understand changes at a glance
- ✅ Automated versioning possible (SemVer)
- ✅ Easy to find when specific feature was added
- ✅ Code review is faster with clear context

---

**Remember**: Commit messages are documentation. Write them as if explaining your changes to your future self or a hiring manager reviewing your GitHub history.
