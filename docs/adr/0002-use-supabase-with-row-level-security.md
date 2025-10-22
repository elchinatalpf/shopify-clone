# ADR 0002: Use Supabase PostgreSQL with Row-Level Security for Multi-Tenancy

**Date:** 2025-10-15  
**Status:** Accepted  
**Dependencies:** ADR 0001 (Auth0 Authentication)  
**Decision Makers:** Solo Developer  

---

## Context

The platform must support multi-tenancy where:
1. One Admin can create and manage multiple stores
2. Each store's data (products, orders) must be isolated from other stores
3. Admins can switch between their stores seamlessly
4. Future feature: Admins can invite staff with limited permissions to specific stores

### Multi-Tenancy Approaches

**Option A: Separate Database Per Store**
- Each store gets its own PostgreSQL database
- **Rejected:** 
  - Unscalable (Supabase free tier = 1 project)
  - Cross-store analytics impossible
  - Massive operational complexity
  - Cannot compare data across stores

**Option B: Single Database, Application-Level Filtering**
- All data in one database, app code filters by `store_id`
- **Rejected:**
  - Security risk: bugs in app code could leak data between stores
  - Developer must remember to add `WHERE store_id = ?` to every query
  - No database-level enforcement

**Option C: Single Database with Row-Level Security (RLS) Policies**
- PostgreSQL enforces data isolation at database level
- Policies filter rows automatically based on session context
- **Selected**

---

## Decision

**We will use a single Supabase PostgreSQL database with Row-Level Security (RLS) policies to enforce multi-tenancy isolation.**

### Architecture Overview
- Auth0 (Authentication)
- Next.js App (gets user's store_id from session)
- Prisma ORM (sets session variable: SET app.current_store_id = X)
- Supabase PostgreSQL (RLS policies filter rows automatically)
- Result: Only rows matching current_store_id are accessible

### Database Schema Pattern

Every multi-tenant table includes a `store_id` foreign key:
```sql
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  store_id INTEGER NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  price DECIMAL(10, 2) NOT NULL,
  -- other fields
);

-- Enable RLS on the table
ALTER TABLE products ENABLE ROW LEVEL SECURITY;

-- Create policy: Users can only access products from their current store
CREATE POLICY products_isolation_policy ON products
  USING (store_id = current_setting('app.current_store_id')::INTEGER);
```

### How It Works in Practice

1. User logs in via Auth0 â†' App queries database for stores owned by user
2. User selects a store from dashboard â†' App sets session variable:
```sql
   SET app.current_store_id = 123;
```
3. All subsequent queries automatically filter by `store_id = 123`
4. Even if malicious code tries `SELECT * FROM products WHERE store_id = 456`, PostgreSQL blocks rows where `store_id != 123`

---

## Consequences

### Positive

1. **Security:** Database-level enforcement prevents data leaks from application bugs
2. **Developer Experience:** Don't need to remember to add `WHERE store_id = ?` to every query
3. **Cross-Store Analytics:** Can still run aggregate queries across all stores for Admin dashboard
4. **Scalability:** Single database can handle thousands of stores (Shopify uses this pattern)
5. **Cost-Effective:** Supabase free tier supports 500MB storage + 2GB bandwidth (sufficient for MVP)
6. **Built-in Features:** Supabase includes:
   - Real-time subscriptions (useful for live order notifications)
   - Storage API (alternative to Cloudinary if needed)
   - Auto-generated REST API (not using, but available)
7. **PostgreSQL Expertise:** Leverages existing PostgreSQL knowledge
8. **Prisma Integration:** Works seamlessly with Prisma ORM for type-safe queries

### Negative

1. **Complexity:** RLS adds conceptual overhead compared to application-level filtering
2. **Debugging:** RLS policies can be confusing when troubleshooting query issues
3. **Session Management:** Must ensure `app.current_store_id` is set correctly for every request
4. **Performance:** RLS policies add slight overhead to queries (negligible for MVP scale)
5. **Migration Difficulty:** Changing RLS policies in production requires careful planning
6. **Limited Free Tier:** 500MB storage may become limiting with many product images (mitigated by using Cloudinary for images)

### Neutral

1. **PostgreSQL-Only:** RLS is PostgreSQL-specific, locks us into PostgreSQL (acceptable trade-off)
2. **Learning Curve:** Need to understand RLS concepts and syntax
3. **Testing Complexity:** Must test RLS policies to ensure data isolation works correctly

---

## Implementation Notes

### Supabase Setup

1. Create Supabase account at [https://supabase.com](https://supabase.com)
2. Create new project (choose region closest to target users)
3. Save credentials:
```env
   SUPABASE_URL=https://your-project.supabase.co
   SUPABASE_ANON_KEY=<public-anon-key>
   SUPABASE_SERVICE_ROLE_KEY=<secret-service-role-key>
   DATABASE_URL=postgresql://postgres:[password]@db.your-project.supabase.co:5432/postgres
```

### Prisma Integration
```bash
npm install prisma @prisma/client
npx prisma init
```

**prisma/schema.prisma:**
```prisma
datasource db {
  provider = "postgresql"
  url      = env("DATABASE_URL")
}

generator client {
  provider = "prisma-client-js"
}

model User {
  id           Int      @id @default(autoincrement())
  auth0UserId  String   @unique @map("auth0_user_id")
  email        String   @unique
  name         String?
  createdAt    DateTime @default(now()) @map("created_at")
  stores       Store[]
  
  @@map("users")
}

model Store {
  id           Int      @id @default(autoincrement())
  userId       Int      @map("user_id")
  storeName    String   @map("store_name")
  storeSlug    String   @unique @map("store_slug")
  createdAt    DateTime @default(now()) @map("created_at")
  
  user         User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  products     Product[]
  orders       Order[]
  
  @@map("stores")
}

model Product {
  id          Int      @id @default(autoincrement())
  storeId     Int      @map("store_id")
  name        String
  description String?
  price       Decimal  @db.Decimal(10, 2)
  imageUrls   Json     @default("[]") @map("image_urls")
  status      String   @default("draft")
  createdAt   DateTime @default(now()) @map("created_at")
  
  store       Store    @relation(fields: [storeId], references: [id], onDelete: Cascade)
  
  @@map("products")
}
```

### MVP RLS Policy (Permissive for Development)

For MVP, start with permissive policies and tighten later:
```sql
-- Allow all operations on products (for MVP development)
CREATE POLICY "Allow all operations on products" ON products
  FOR ALL USING (true) WITH CHECK (true);
```

**Post-MVP:** Replace with strict policies:
```sql
-- Only allow access to products from current store
CREATE POLICY "products_isolation_policy" ON products
  USING (store_id = current_setting('app.current_store_id')::INTEGER);
```

### Testing Checklist

- [ ] Can create product with `store_id = 1`
- [ ] Can query products and only see products from `store_id = 1`
- [ ] Cannot access products from `store_id = 2` when session is set to `store_id = 1`
- [ ] RLS policies prevent cross-store data access
- [ ] Prisma schema syncs correctly with `npx prisma db pull`

---

## References

- [Supabase Row-Level Security Documentation](https://supabase.com/docs/guides/database/postgres/row-level-security)
- [PostgreSQL RLS Documentation](https://www.postgresql.org/docs/current/ddl-rowsecurity.html)
- [Prisma Supabase Integration](https://www.prisma.io/docs/getting-started/setup-prisma/add-to-existing-project/relational-databases/connect-your-database-typescript-supabase)
- [Shopify Multi-Tenancy Architecture (Blog)](https://shopify.engineering/managing-multi-tenancy-in-cloud-native-environments)

---

## Revision History

- **2025-10-15:** Initial decision to use Supabase with RLS