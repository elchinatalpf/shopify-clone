# Shopify Clone - GitHub Flow Workflow

## 🔄 **Professional Development Workflow**

This project follows **GitHub Flow** - a lightweight, branch-based workflow that supports professional development practices.

---

## **GitHub Flow Steps**

### 1. Select User Story
- Navigate to your GitHub Issues
- Choose the next user story from your current Epic
- Ensure acceptance criteria are clear

### 2. Create Feature Branch
```bash
# From main branch
git checkout main
git pull origin main

# Create branch linked to issue
# Naming: type/description
git checkout -b feat/auth0-integration
# OR from GitHub UI: Click "Create a branch" on the issue
```

**Branch naming conventions:**
- `feat/feature-name` - New features
- `fix/bug-description` - Bug fixes
- `docs/update-readme` - Documentation
- `refactor/improve-code` - Code refactoring
- `test/add-unit-tests` - Test additions

---

### 3. Implement Feature
Write code following tech stack best practices:

#### Next.js 15 App Router Patterns
```typescript
// Server Component (default)
// src/app/dashboard/page.tsx
export default async function DashboardPage() {
  // Fetch data directly
  const stores = await prisma.store.findMany()
  return <div>{/* Render */}</div>
}

// Client Component (interactive UI)
'use client'
import { useState } from 'react'
export function InteractiveComponent() {
  const [state, setState] = useState()
  return <button onClick={...}>...</button>
}
```

#### API Route Pattern
```typescript
// src/app/api/stores/route.ts
import { NextResponse } from 'next/server'
import { getSession } from '@auth0/nextjs-auth0'
import { prisma } from '@/lib/prisma'

export async function GET(request: Request) {
  const session = await getSession()
  if (!session) {
    return NextResponse.json({ error: 'Unauthorized' }, { status: 401 })
  }

  const stores = await prisma.store.findMany({
    where: { userId: session.user.dbId }
  })

  return NextResponse.json({ stores })
}
```

#### TanStack Query Hook Pattern
```typescript
// src/lib/api/stores.ts
import { useQuery } from '@tanstack/react-query'

export function useStores() {
  return useQuery({
    queryKey: ['stores'],
    queryFn: async () => {
      const res = await fetch('/api/stores')
      if (!res.ok) throw new Error('Failed to fetch stores')
      return res.json()
    }
  })
}
```

---

### 4. Make Atomic Commits

**Atomic Commit**: One logical change per commit

```bash
# Good examples
git commit -m "feat(auth): add Auth0 route handlers"
git commit -m "feat(auth): create middleware for route protection"
git commit -m "feat(auth): add UserProvider to root layout"

# Bad example
git commit -m "add auth and fix typo and update readme"
```

**Conventional Commit Format:**
```
<type>(<scope>): <description>

[optional body]

[optional footer]
```

**Types:**
- `feat`: New feature
- `fix`: Bug fix
- `docs`: Documentation only
- `style`: Formatting (no code change)
- `refactor`: Code change (no bug fix or feature)
- `test`: Adding tests
- `chore`: Build/dependency updates

Use `/commit` command for detailed guidance.

---

### 5. Push and Create PR

```bash
# Push feature branch
git push -u origin feat/auth0-integration
```

**On GitHub:**
1. Click "Create Pull Request"
2. Title: Use conventional commit format
3. Description template:
```markdown
## Description
Brief summary of what this PR implements.

## Related Issue
Closes #3

## Changes Made
- Added Auth0 route handlers
- Implemented middleware for route protection
- Created UserProvider wrapper

## Testing
- [ ] Tested sign-up flow
- [ ] Tested login flow
- [ ] Tested protected routes redirect
- [ ] Tested logout

## Screenshots
[Add relevant screenshots]

## Checklist
- [ ] Code follows project conventions
- [ ] Self-reviewed code
- [ ] All acceptance criteria met
- [ ] No console errors
```

---

### 6. Self-Review
This is your **quality gate**. Review your own code as if reviewing someone else's:

1. Navigate to "Files changed" tab
2. Read every line of code
3. Leave comments on your own PR where improvements needed
4. Push additional commits to address comments
5. Mark conversations as "Resolved"

Use `/review` command for detailed checklist.

---

### 7. Merge to Main

**After thorough self-review:**
1. Click "Squash and merge" (or "Merge pull request")
2. Verify commit message is clear and conventional
3. Click "Confirm merge"
4. Issue automatically closes (if linked with "Closes #X")
5. Delete feature branch

---

### 8. Cleanup Locally

```bash
git checkout main
git pull origin main
# Feature branch is deleted on GitHub
```

---

## 🎯 **Quality Standards**

Every PR must:
- ✅ Link to closing issue (`Closes #X` in description)
- ✅ Follow conventional commit format
- ✅ Include detailed PR description
- ✅ Pass self-review with no outstanding comments
- ✅ Satisfy all acceptance criteria from user story
- ✅ Have no TypeScript errors (`npm run typecheck`)
- ✅ Have no ESLint errors (`npm run lint`)

---

## 📝 **Git Commands Reference**

```bash
# Create and switch to new branch
git checkout -b feat/feature-name

# Stage changes
git add .
# OR stage specific files
git add src/app/api/stores/route.ts

# Commit with message
git commit -m "feat(stores): add store creation API endpoint"

# Push branch to remote
git push -u origin feat/feature-name

# Pull latest from main
git checkout main
git pull origin main

# Merge main into feature branch (if needed)
git checkout feat/feature-name
git merge main

# Delete local branch after merge
git branch -d feat/feature-name

# View commit history
git log --oneline --graph

# Undo last commit (keep changes)
git reset --soft HEAD~1
```

---

## ⚠️ **Important Rules**

- ❌ **NEVER commit directly to main** - Always use feature branches
- ❌ **NEVER push .env.local** - Contains secrets
- ❌ **NEVER skip self-review** - Quality gate before merge
- ❌ **NEVER use vague commit messages** - Be specific and conventional
- ✅ **ALWAYS link PRs to issues** - Closes #X in description
- ✅ **ALWAYS test before pushing** - Manual + TypeScript + ESLint

---

**Remember**: This workflow creates a professional paper trail that demonstrates your engineering discipline to potential employers.
