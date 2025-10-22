# ADR 0001: Use Auth0 for Authentication

**Date:** 2025-10-15  
**Status:** Accepted  
**Decision Makers:** Solo Developer  

---

## Context

The Shopify-like platform requires secure authentication for Admin users who will manage stores, products, and orders. Key requirements:

1. **Security:** Authentication must follow industry best practices (OAuth 2.0, secure token handling)
2. **Scalability:** Must support future features like social logins (Google, GitHub) and Multi-Factor Authentication (MFA)
3. **Time Constraint:** As a solo developer building a portfolio project, I need to minimize time spent on auth infrastructure
4. **Cost:** Must be free or low-cost for MVP with room to scale

### Alternatives Considered

**Option A: Custom JWT Authentication**
- Build from scratch using Next.js API routes + JWT tokens
- Full control over implementation
- **Rejected:** High time investment, security risks, no MFA/OAuth support

**Option B: NextAuth.js (Auth.js)**
- Open-source authentication for Next.js
- Free, integrates well with Next.js
- **Rejected:** Requires managing session database, more complex setup for JWT strategy, less feature-complete than Auth0

**Option C: Supabase Auth**
- Built into Supabase (already using for database)
- Free tier, includes social logins
- **Rejected:** While viable, Auth0 has better documentation, larger community, and more enterprise-ready for portfolio showcase

**Option D: Auth0**
- Industry-standard authentication platform
- Free tier: 7,000 active users, unlimited logins
- Built-in support for OAuth, MFA, social logins
- Excellent Next.js SDK and documentation
- **Selected**

---

## Decision

**We will use Auth0 as the authentication provider for all user authentication and session management.**

### Implementation Approach

1. Use `@auth0/nextjs-auth0` SDK for seamless Next.js App Router integration
2. Store Auth0 user ID (`sub` claim) as foreign key in PostgreSQL `users` table
3. Use Auth0's Universal Login for authentication flow (no custom login UI needed for MVP)
4. Protect routes using Next.js middleware with `withMiddlewareAuthRequired`
5. Access user session in:
   - **Client components:** `useUser()` hook
   - **Server components:** `getSession()` function
   - **API routes:** `getSession()` function

### Integration Flow
- User clicks "Sign Up"
- Redirect to Auth0 Universal Login (/api/auth/login)
- User authenticates with email/password
- Auth0 redirects to callback (/api/auth/callback)
- Create user record in database if new user
- Set encrypted session cookie
- Redirect to /dashboard

---

## Consequences

### Positive

1. **Security:** Auth0 handles security best practices automatically (password hashing, token refresh, CSRF protection)
2. **Time Savings:** Eliminates 1-2 weeks of auth development and testing
3. **Professional Credibility:** Using Auth0 signals familiarity with enterprise-grade tools
4. **Future-Proof:** Easy to add OAuth providers (Google, GitHub) and MFA without code changes
5. **Developer Experience:** Excellent TypeScript support and Next.js App Router compatibility
6. **Free Tier:** 7,000 active users is sufficient for MVP and beyond
7. **JWT Tokens:** Stateless authentication works well with Next.js API routes and external services

### Negative

1. **Vendor Lock-In:** Switching to another provider later would require significant refactoring
2. **External Dependency:** Auth0 downtime affects the platform (mitigated by 99.99% SLA)
3. **Cost at Scale:** Beyond 7,000 users, pricing starts at $35/month for Essentials plan
4. **Limited Free Tier:** Only 2 social connections on free tier (sufficient for MVP)
5. **Data Sovereignty:** User authentication data stored on Auth0 servers (acceptable for this use case)
6. **Learning Curve:** Need to understand Auth0 concepts (tenants, applications, connections)

### Neutral

1. **Split User Data:** User identity in Auth0, application data in PostgreSQL (standard pattern)
2. **Configuration Required:** Need to set up Auth0 application and configure callback URLs
3. **Environment Variables:** 4 additional environment variables required (`AUTH0_SECRET`, `AUTH0_CLIENT_ID`, `AUTH0_CLIENT_SECRET`, `AUTH0_ISSUER_BASE_URL`)

---

## Implementation Notes

### Environment Variables Required
```env
AUTH0_SECRET=<generated-with-openssl-rand-hex-32>
AUTH0_BASE_URL=http://localhost:3000
AUTH0_ISSUER_BASE_URL=https://your-tenant.auth0.com
AUTH0_CLIENT_ID=<from-auth0-dashboard>
AUTH0_CLIENT_SECRET=<from-auth0-dashboard>
```

### Database Schema Consideration

The `users` table must include:
```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  auth0_user_id TEXT UNIQUE NOT NULL,  -- Links to Auth0 'sub' claim
  email TEXT UNIQUE NOT NULL,
  name TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

### Testing Checklist

- [ ] User can sign up with email/password
- [ ] User is redirected to dashboard after signup
- [ ] User record created in database with correct `auth0_user_id`
- [ ] Protected routes redirect to login when unauthenticated
- [ ] User can log out and session is cleared
- [ ] Middleware protects `/dashboard/*` routes

---

## References

- [Auth0 Next.js Quickstart](https://auth0.com/docs/quickstart/webapp/nextjs)
- [Auth0 Pricing](https://auth0.com/pricing)
- [@auth0/nextjs-auth0 GitHub](https://github.com/auth0/nextjs-auth0)
- [Next.js 15 Middleware Documentation](https://nextjs.org/docs/app/building-your-application/routing/middleware)

---

## Revision History

- **2025-10-15:** Initial decision to use Auth0