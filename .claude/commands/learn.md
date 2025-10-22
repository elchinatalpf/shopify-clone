# Shopify Clone - Learning Resources

## 📚 **Tech Stack Documentation**

### Next.js 15
- **Official Docs**: https://nextjs.org/docs
- **App Router Guide**: https://nextjs.org/docs/app
- **Server Components**: https://nextjs.org/docs/app/building-your-application/rendering/server-components
- **API Routes**: https://nextjs.org/docs/app/building-your-application/routing/route-handlers
- **Middleware**: https://nextjs.org/docs/app/building-your-application/routing/middleware
- **Best Practices**: Server vs Client Components, data fetching patterns

### TypeScript
- **Handbook**: https://www.typescriptlang.org/docs/handbook/
- **React + TypeScript**: https://react-typescript-cheatsheet.netlify.app/
- **Strict Mode**: Essential for catching bugs early
- **Type Inference**: Let TypeScript infer types from Prisma/Zod

### Auth0
- **Next.js SDK**: https://auth0.com/docs/quickstart/webapp/nextjs
- **Authentication Flow**: https://auth0.com/docs/get-started/authentication-and-authorization-flow
- **Session Management**: https://auth0.com/docs/manage-users/sessions
- **Key Concepts**: JWT tokens, session cookies, middleware protection

### Supabase + PostgreSQL
- **Supabase Docs**: https://supabase.com/docs
- **PostgreSQL Tutorial**: https://www.postgresql.org/docs/current/tutorial.html
- **Row-Level Security**: https://supabase.com/docs/guides/auth/row-level-security
- **Multi-Tenancy Pattern**: Database-level data isolation

### Prisma ORM
- **Documentation**: https://www.prisma.io/docs
- **Schema Definition**: https://www.prisma.io/docs/concepts/components/prisma-schema
- **Prisma Client**: https://www.prisma.io/docs/concepts/components/prisma-client
- **Relations**: https://www.prisma.io/docs/concepts/components/prisma-schema/relations
- **Best Practices**: Type-safe queries, connection pooling

### TanStack Query v5
- **Documentation**: https://tanstack.com/query/latest
- **Queries**: https://tanstack.com/query/latest/docs/react/guides/queries
- **Mutations**: https://tanstack.com/query/latest/docs/react/guides/mutations
- **Optimistic Updates**: https://tanstack.com/query/latest/docs/react/guides/optimistic-updates
- **DevTools**: Essential for debugging cache behavior

### Zod Validation
- **Documentation**: https://zod.dev/
- **Schema Definition**: Runtime type checking + TypeScript types
- **React Hook Form Integration**: https://react-hook-form.com/get-started#SchemaValidation
- **Error Handling**: Detailed validation error messages

### React Hook Form
- **Documentation**: https://react-hook-form.com/
- **Get Started**: https://react-hook-form.com/get-started
- **Controller**: For controlled components (Cloudinary widget)
- **Performance**: Uncontrolled inputs for better performance

### Tailwind CSS 4
- **Documentation**: https://tailwindcss.com/docs
- **Utility Classes**: https://tailwindcss.com/docs/utility-first
- **Responsive Design**: https://tailwindcss.com/docs/responsive-design
- **Components**: Build reusable components with utility classes

### Cloudinary
- **Next.js Integration**: https://cloudinary.com/documentation/nextjs_integration
- **Upload Widget**: https://cloudinary.com/documentation/upload_widget
- **Transformations**: Image optimization and resizing

---

## 🎓 **Phase-Based Learning Path**

### Phase 1: Foundation (Week 1)
**Focus**: Project setup, environment configuration
- [ ] Next.js 15 project structure
- [ ] Environment variables management
- [ ] Prisma schema design
- [ ] Database connection testing

**Resources**:
- Next.js: Installation and setup
- Prisma: Getting started guide
- PostgreSQL: Basic SQL commands

---

### Phase 2: Authentication (Week 1-2)
**Focus**: Auth0 integration, protected routes
- [ ] Auth0 route handlers (`/api/auth/[auth0]`)
- [ ] Session management with cookies
- [ ] Middleware for route protection
- [ ] User synchronization to database

**Resources**:
- Auth0 Next.js quickstart
- Next.js middleware documentation
- Session vs JWT tokens

**Code Patterns**:
```typescript
// Middleware pattern
import { withMiddlewareAuthRequired } from '@auth0/nextjs-auth0/edge'

export default withMiddlewareAuthRequired()

export const config = {
  matcher: ['/dashboard/:path*']
}
```

---

### Phase 3: Data Management (Week 3)
**Focus**: TanStack Query, API routes, CRUD operations
- [ ] QueryClient setup with providers
- [ ] useQuery for data fetching
- [ ] useMutation for create/update/delete
- [ ] Optimistic updates for better UX

**Resources**:
- TanStack Query: React Query essentials
- Next.js: API route patterns
- Prisma: CRUD operations

**Code Patterns**:
```typescript
// Query hook pattern
export function useStores() {
  return useQuery({
    queryKey: ['stores'],
    queryFn: async () => {
      const res = await fetch('/api/stores')
      return res.json()
    }
  })
}

// Mutation with optimistic update
const mutation = useMutation({
  mutationFn: createStore,
  onMutate: async (newStore) => {
    await queryClient.cancelQueries({ queryKey: ['stores'] })
    const previousStores = queryClient.getQueryData(['stores'])
    queryClient.setQueryData(['stores'], old => [...old, newStore])
    return { previousStores }
  },
  onError: (err, newStore, context) => {
    queryClient.setQueryData(['stores'], context.previousStores)
  }
})
```

---

### Phase 4: Forms & Validation (Week 3-4)
**Focus**: React Hook Form, Zod schemas, file uploads
- [ ] Zod schema definitions
- [ ] Form validation with error messages
- [ ] Cloudinary image upload widget
- [ ] Form state management

**Resources**:
- Zod: Schema definition guide
- React Hook Form: Controller API
- Cloudinary: Upload widget integration

**Code Patterns**:
```typescript
// Zod schema
import { z } from 'zod'

export const createProductSchema = z.object({
  name: z.string().min(1, 'Product name required'),
  price: z.number().positive('Price must be positive'),
  description: z.string().optional(),
  imageUrls: z.array(z.string().url())
})

export type CreateProductInput = z.infer<typeof createProductSchema>
```

---

### Phase 5: Storefront (Week 4-5)
**Focus**: Public pages, dynamic routing, SEO
- [ ] Dynamic routes (`/store/[slug]`)
- [ ] Server Components for SEO
- [ ] Client Components for interactivity
- [ ] Image optimization with Next.js Image

**Resources**:
- Next.js: Dynamic routing
- Next.js: Image optimization
- React: Server vs Client Components

---

### Phase 6: Deployment (Week 6)
**Focus**: Vercel deployment, environment variables
- [ ] Vercel project setup
- [ ] Environment variables configuration
- [ ] Database connection pooling
- [ ] Production testing

**Resources**:
- Vercel: Deployment documentation
- Next.js: Environment variables
- Supabase: Connection pooling for serverless

---

## 🎯 **E-Commerce Domain Concepts**

### Multi-Tenancy
- **Pattern**: Single database with Row-Level Security
- **Implementation**: `store_id` foreign key on all tables
- **Security**: Database-enforced data isolation

### Shopify Architecture Insights
- **Admin vs Storefront**: Separate interfaces, same data
- **Slug-based Routing**: `/store/my-shop` for SEO-friendly URLs
- **Theme Engine**: Customizable store appearance (post-MVP)
- **Product Variants**: Colors, sizes, SKUs (post-MVP)

### Order Management
- **Cart**: localStorage for MVP (no auth required)
- **Checkout**: Form validation, order creation
- **Order Items**: Snapshot product data at purchase time
- **Status Tracking**: pending → processing → shipped → delivered

---

## 💡 **Best Practices**

### TypeScript Strict Mode
```typescript
// tsconfig.json
{
  "compilerOptions": {
    "strict": true,
    "noUnusedLocals": true,
    "noUnusedParameters": true
  }
}
```

### Error Handling
```typescript
// API route pattern
try {
  const data = await prisma.store.findMany()
  return NextResponse.json({ success: true, data })
} catch (error) {
  console.error('Store fetch error:', error)
  return NextResponse.json(
    { success: false, error: 'Failed to fetch stores' },
    { status: 500 }
  )
}
```

### Environment Variables
- **Public**: `NEXT_PUBLIC_*` (client-side accessible)
- **Private**: No prefix (server-side only)
- **Never commit**: `.env.local` in `.gitignore`

---

## 🛠️ **Development Tools**

- **Prisma Studio**: `npx prisma studio` - Visual database editor
- **TanStack Query DevTools**: Debug cache behavior
- **React DevTools**: Component tree inspection
- **Auth0 Dashboard**: User management, application settings
- **Supabase Dashboard**: Database tables, SQL editor
- **Cloudinary Dashboard**: Media library, transformations

---

## 📖 **Recommended Reading**

1. **Shopify Architecture**: https://shopify.engineering/
2. **Multi-Tenancy Patterns**: https://learn.microsoft.com/en-us/azure/architecture/patterns/
3. **Next.js E-Commerce**: https://nextjs.org/commerce
4. **PostgreSQL Performance**: https://www.postgresql.org/docs/current/performance-tips.html

---

**Remember**: This is a learning project. Take time to understand each concept rather than rushing through implementation.
