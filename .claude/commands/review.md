# Shopify Clone - Self-Review Checklist

## 🔍 **Pre-Merge Quality Gate**

Self-review is your **quality gate** before merging. Review your own code as critically as you would review someone else's.

---

## **Self-Review Process**

### 1. Navigate to PR
- Go to your Pull Request on GitHub
- Click the **"Files changed"** tab
- Review every single line

### 2. Review Systematically
Go through each file and ask yourself these questions:

---

## **Code Quality Checklist**

### ✅ **Functionality**
- [ ] Does the code do what the user story requires?
- [ ] Are all acceptance criteria met?
- [ ] Have you tested the happy path?
- [ ] Have you tested error cases?
- [ ] Does the feature work as expected in the browser?

### ✅ **TypeScript**
- [ ] Are all variables and functions properly typed?
- [ ] Are there any `any` types that should be specific?
- [ ] Does `npm run typecheck` pass without errors?
- [ ] Are Prisma types used correctly?
- [ ] Are Zod schemas defined for form inputs?

### ✅ **Code Structure**
- [ ] Is the code DRY (Don't Repeat Yourself)?
- [ ] Are functions small and focused (single responsibility)?
- [ ] Are variable names descriptive and clear?
- [ ] Is the file structure logical?
- [ ] Are imports organized (React, Next, external, internal)?

### ✅ **Error Handling**
- [ ] Are API errors caught and handled gracefully?
- [ ] Are error messages user-friendly?
- [ ] Is loading state shown during async operations?
- [ ] Are edge cases handled (empty lists, null values)?
- [ ] Do API routes return appropriate status codes?

### ✅ **Security**
- [ ] Are user inputs validated (Zod schemas)?
- [ ] Are Auth0 sessions checked in protected routes?
- [ ] Are database queries safe from injection?
- [ ] Is `.env.local` NOT committed?
- [ ] Are no secrets hardcoded in the code?

### ✅ **Performance**
- [ ] Are Server Components used where appropriate?
- [ ] Are Client Components marked with `'use client'`?
- [ ] Are images optimized with Next.js `<Image>`?
- [ ] Are there unnecessary re-renders?
- [ ] Is data fetched efficiently (no N+1 queries)?

### ✅ **UI/UX**
- [ ] Is the UI responsive (mobile, tablet, desktop)?
- [ ] Are loading states shown during data fetching?
- [ ] Are error messages displayed to users?
- [ ] Are success messages shown (toasts)?
- [ ] Is the design consistent with existing pages?
- [ ] Are buttons and forms accessible?

### ✅ **Testing**
- [ ] Have you manually tested the feature?
- [ ] Have you tested in the browser (not just code review)?
- [ ] Have you tested form validation?
- [ ] Have you tested with invalid data?
- [ ] Does the feature work after page refresh?

### ✅ **Documentation**
- [ ] Are complex functions commented?
- [ ] Is the PR description clear and complete?
- [ ] Are breaking changes documented?
- [ ] Is the README updated if needed?
- [ ] Are new environment variables documented?

### ✅ **Git & Commits**
- [ ] Are commit messages following conventional commits?
- [ ] Are commits atomic (one logical change each)?
- [ ] Is the PR linked to the correct issue?
- [ ] Is the PR title descriptive?
- [ ] Are there no merge conflicts?

---

## **Commenting on Your Own PR**

Leave comments on your own code where:
- You considered alternative approaches
- The code is complex and needs explanation
- You're unsure about a decision
- You want to highlight something clever
- You plan to refactor in a future PR

### Example Comments

```markdown
💡 **Design Decision**: I chose to use localStorage for the cart
instead of database storage because customers don't need accounts
for MVP. This will need to change when we add user accounts.

⚠️ **Known Issue**: This doesn't handle concurrent store creation
by the same user. Added TODO to add rate limiting in future PR.

🤔 **Question**: Is this the right place to sync Auth0 user to
database, or should this be in middleware?

✨ **Optimization**: Using Prisma's include here reduces database
roundtrips from 3 to 1.
```

---

## **Review Categories**

### 🟢 **Approve & Merge**
All checklist items passed, no outstanding concerns

**Actions:**
1. Resolve all self-review comments
2. Confirm all tests pass
3. Merge with squash
4. Delete branch

### 🟡 **Request Changes (to yourself)**
Found issues that need fixing

**Actions:**
1. Leave comments on problematic code
2. Push additional commits addressing issues
3. Re-review after fixes
4. Mark conversations as "Resolved"

### 🔴 **Needs Major Refactor**
Fundamental issues with approach

**Actions:**
1. Consider closing PR
2. Discuss architectural concerns
3. Potentially create new branch
4. Re-implement with better design

---

## **Common Issues to Watch For**

### TypeScript
```typescript
// ❌ Bad - using 'any'
const handleSubmit = (data: any) => { ... }

// ✅ Good - specific type
const handleSubmit = (data: CreateStoreInput) => { ... }
```

### Error Handling
```typescript
// ❌ Bad - unhandled promise rejection
const stores = await fetch('/api/stores')

// ✅ Good - proper error handling
try {
  const res = await fetch('/api/stores')
  if (!res.ok) throw new Error('Failed to fetch')
  const stores = await res.json()
} catch (error) {
  console.error(error)
  toast.error('Failed to load stores')
}
```

### Server vs Client Components
```typescript
// ❌ Bad - using useState in Server Component
export default function Page() {
  const [state, setState] = useState() // ERROR!
}

// ✅ Good - extract to Client Component
'use client'
export function InteractiveComponent() {
  const [state, setState] = useState() // OK!
}
```

### Security
```typescript
// ❌ Bad - no session check in API route
export async function DELETE(request: Request) {
  await prisma.store.delete({ where: { id } })
}

// ✅ Good - verify authentication
export async function DELETE(request: Request) {
  const session = await getSession()
  if (!session) return new Response('Unauthorized', { status: 401 })

  // Verify user owns this store
  const store = await prisma.store.findUnique({
    where: { id, userId: session.user.dbId }
  })
  if (!store) return new Response('Forbidden', { status: 403 })

  await prisma.store.delete({ where: { id } })
}
```

### Validation
```typescript
// ❌ Bad - no validation
const { name, price } = await request.json()
await prisma.product.create({ data: { name, price } })

// ✅ Good - Zod validation
const body = await request.json()
const validated = createProductSchema.parse(body)
await prisma.product.create({ data: validated })
```

---

## **Self-Review Questions**

Ask yourself:

### About the Code
1. Would I understand this code in 6 months?
2. Is there a simpler way to accomplish this?
3. Have I over-engineered this?
4. Is this code testable?
5. Does this follow project conventions?

### About the Feature
1. Does this solve the user's problem?
2. What edge cases might I have missed?
3. How would this break?
4. What happens if the user does something unexpected?
5. Is the UX intuitive?

### About the Process
1. Is my commit history clean?
2. Are my commit messages clear?
3. Is the PR description complete?
4. Have I linked the correct issue?
5. Am I proud to show this to potential employers?

---

## **Before Clicking "Merge"**

### Final Verification
```bash
# 1. Pull latest main
git checkout main && git pull origin main

# 2. Merge main into your branch
git checkout your-branch
git merge main

# 3. Verify no conflicts

# 4. Run checks
npm run typecheck
npm run lint

# 5. Test in browser one more time

# 6. Push if changes were made
git push origin your-branch
```

### Merge Checklist
- [ ] All self-review comments resolved
- [ ] All acceptance criteria met
- [ ] No TypeScript errors
- [ ] No ESLint errors
- [ ] Manual testing completed
- [ ] PR description complete
- [ ] Issue linked with "Closes #X"
- [ ] Ready to deploy to production

---

## **After Merge**

### Immediate Actions
1. **Verify merge** - Check GitHub that PR is closed
2. **Verify issue closed** - Issue should auto-close
3. **Pull latest main** - `git checkout main && git pull`
4. **Delete branch** - GitHub usually does this automatically
5. **Update project board** - Move issue to "Done"

### Update Documentation
- [ ] Update Phase status if phase is complete
- [ ] Mark todos as done in planning docs
- [ ] Add screenshots to README if UI feature
- [ ] Create ADR if architectural decision made

---

## **Self-Review Red Flags**

If you see these, pause and reconsider:

🚩 **"I'll fix this later"** → Fix it now or create an issue
🚩 **Commented-out code** → Delete it (it's in git history)
🚩 **TODO comments** → Either fix now or create GitHub issue
🚩 **console.log for debugging** → Remove before merge
🚩 **Hardcoded values** → Move to constants or config
🚩 **Giant functions (>50 lines)** → Break into smaller functions
🚩 **Copy-pasted code** → Extract to reusable utility
🚩 **No error handling** → Add try-catch and user feedback

---

## **Remember**

> "Code is read more than it is written. Make it readable."

Your self-review is demonstrating to future employers that you:
- ✅ Care about code quality
- ✅ Think critically about your own work
- ✅ Understand trade-offs and edge cases
- ✅ Follow professional standards
- ✅ Take ownership of your work

**This PR is part of your portfolio. Make it excellent.**
