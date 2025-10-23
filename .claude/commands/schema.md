# Shopify Clone - Database Schema & Prisma Reference

## 🗄️ **Database Overview**

**Database**: PostgreSQL (via Supabase)
**ORM**: Prisma
**Multi-Tenancy**: Row-Level Security (RLS)
**Tables**: 5 main tables

---

## **Entity Relationship Diagram**

```
┌─────────────┐
│    users    │
│             │
│ id (PK)     │
│ auth0_user_id UNIQUE
│ email       │
│ name        │
└─────┬───────┘
      │
      │ 1:N
      ↓
┌─────────────┐
│   stores    │
│             │
│ id (PK)     │
│ user_id (FK)│
│ store_name  │
│ store_slug  │ UNIQUE
│ subdomain   │ UNIQUE (optional)
└─────┬───────┘
      │
      │ 1:N
      ├───────────────────┐
      ↓                   ↓
┌─────────────┐    ┌─────────────┐
│  products   │    │   orders    │
│             │    │             │
│ id (PK)     │    │ id (PK)     │
│ store_id (FK)    │ store_id (FK)
│ name        │    │ customer_name
│ description │    │ customer_email
│ price       │    │ total_amount│
│ image_urls  │    │ status      │
│ status      │    └─────┬───────┘
└─────┬───────┘          │
      │                  │ 1:N
      │                  ↓
      │            ┌─────────────┐
      │            │ order_items │
      │            │             │
      └────────────┤ product_id (FK)
                   │ order_id (FK)
                   │ product_name│
                   │ quantity    │
                   │ price_at_purchase
                   └─────────────┘
```

---

## **Table Schemas**

### 1. users
**Purpose**: Store Admin user data synced from Auth0

```sql
CREATE TABLE users (
  id SERIAL PRIMARY KEY,
  auth0_user_id TEXT UNIQUE NOT NULL,  -- Auth0 'sub' claim
  email TEXT UNIQUE NOT NULL,
  name TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

**Prisma Model**:
```prisma
model User {
  id          Int      @id @default(autoincrement())
  auth0UserId String   @unique @map("auth0_user_id")
  email       String   @unique
  name        String?
  createdAt   DateTime @default(now()) @map("created_at")
  updatedAt   DateTime @updatedAt @map("updated_at")

  stores      Store[]

  @@map("users")
}
```

**Key Points**:
- `auth0_user_id` links to Auth0's `sub` claim
- One user can have many stores
- Email is unique for lookups

---

### 2. stores
**Purpose**: Multi-tenant store data (one admin can have multiple stores)

```sql
CREATE TABLE stores (
  id SERIAL PRIMARY KEY,
  user_id INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
  store_name TEXT NOT NULL,
  store_slug TEXT UNIQUE NOT NULL,        -- URL-safe identifier
  subdomain TEXT UNIQUE,                  -- Optional: my-store.platform.com
  description TEXT,
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

**Prisma Model**:
```prisma
model Store {
  id          Int      @id @default(autoincrement())
  userId      Int      @map("user_id")
  storeName   String   @map("store_name")
  storeSlug   String   @unique @map("store_slug")
  subdomain   String?  @unique
  description String?
  createdAt   DateTime @default(now()) @map("created_at")
  updatedAt   DateTime @updatedAt @map("updated_at")

  user        User     @relation(fields: [userId], references: [id], onDelete: Cascade)
  products    Product[]
  orders      Order[]

  @@map("stores")
}
```

**Key Points**:
- `store_slug` is used for public URLs: `/store/my-shop-slug`
- Deleting user cascades to delete all their stores
- Subdomain is optional (post-MVP feature)

---

### 3. products
**Purpose**: Store-specific products (multi-tenant via store_id)

```sql
CREATE TABLE products (
  id SERIAL PRIMARY KEY,
  store_id INTEGER NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  price DECIMAL(10, 2) NOT NULL,           -- 2 decimal places
  image_urls JSONB DEFAULT '[]',           -- Array of Cloudinary URLs
  status TEXT DEFAULT 'draft' CHECK (status IN ('draft', 'published')),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

**Prisma Model**:
```prisma
model Product {
  id          Int      @id @default(autoincrement())
  storeId     Int      @map("store_id")
  name        String
  description String?
  price       Decimal  @db.Decimal(10, 2)
  imageUrls   Json     @default("[]") @map("image_urls")
  status      String   @default("draft")
  createdAt   DateTime @default(now()) @map("created_at")
  updatedAt   DateTime @updatedAt @map("updated_at")

  store       Store    @relation(fields: [storeId], references: [id], onDelete: Cascade)
  orderItems  OrderItem[]

  @@map("products")
}
```

**Key Points**:
- `status`: "draft" (admin-only) or "published" (public)
- `image_urls`: JSONB array of Cloudinary URLs
- Decimal type ensures precise price calculations

---

### 4. orders
**Purpose**: Customer orders for each store

```sql
CREATE TABLE orders (
  id SERIAL PRIMARY KEY,
  store_id INTEGER NOT NULL REFERENCES stores(id) ON DELETE CASCADE,
  customer_name TEXT NOT NULL,
  customer_email TEXT NOT NULL,
  shipping_address JSONB NOT NULL,         -- {street, city, state, zip, country}
  total_amount DECIMAL(10, 2) NOT NULL,
  status TEXT DEFAULT 'pending' CHECK (status IN
    ('pending', 'processing', 'shipped', 'delivered', 'cancelled')),
  created_at TIMESTAMP DEFAULT NOW(),
  updated_at TIMESTAMP DEFAULT NOW()
);
```

**Prisma Model**:
```prisma
model Order {
  id              Int      @id @default(autoincrement())
  storeId         Int      @map("store_id")
  customerName    String   @map("customer_name")
  customerEmail   String   @map("customer_email")
  shippingAddress Json     @map("shipping_address")
  totalAmount     Decimal  @db.Decimal(10, 2) @map("total_amount")
  status          String   @default("pending")
  createdAt       DateTime @default(now()) @map("created_at")
  updatedAt       DateTime @updatedAt @map("updated_at")

  store           Store    @relation(fields: [storeId], references: [id], onDelete: Cascade)
  orderItems      OrderItem[]

  @@map("orders")
}
```

**Key Points**:
- No customer authentication for MVP
- `shipping_address` is JSONB for flexibility
- Order status tracks fulfillment

---

### 5. order_items
**Purpose**: Line items in an order (snapshot of product at purchase time)

```sql
CREATE TABLE order_items (
  id SERIAL PRIMARY KEY,
  order_id INTEGER NOT NULL REFERENCES orders(id) ON DELETE CASCADE,
  product_id INTEGER NOT NULL REFERENCES products(id),
  product_name TEXT NOT NULL,              -- Snapshot at purchase
  quantity INTEGER NOT NULL CHECK (quantity > 0),
  price_at_purchase DECIMAL(10, 2) NOT NULL,
  created_at TIMESTAMP DEFAULT NOW()
);
```

**Prisma Model**:
```prisma
model OrderItem {
  id              Int      @id @default(autoincrement())
  orderId         Int      @map("order_id")
  productId       Int      @map("product_id")
  productName     String   @map("product_name")
  quantity        Int
  priceAtPurchase Decimal  @db.Decimal(10, 2) @map("price_at_purchase")
  createdAt       DateTime @default(now()) @map("created_at")

  order           Order    @relation(fields: [orderId], references: [id], onDelete: Cascade)
  product         Product  @relation(fields: [productId], references: [id])

  @@map("order_items")
}
```

**Key Points**:
- Stores product name and price **at purchase time**
- Even if product is deleted/updated, order history is preserved
- `quantity` must be positive (CHECK constraint)

---

## **Prisma Commands**

### Generate Prisma Client
```bash
# After changing schema.prisma
npx prisma generate
```

### Database Operations
```bash
# Pull schema from existing database
npx prisma db pull

# Push schema changes to database
npx prisma db push

# Open Prisma Studio (GUI)
npx prisma studio
```

### Migrations (Production)
```bash
# Create migration
npx prisma migrate dev --name add_subdomain_to_stores

# Apply migrations
npx prisma migrate deploy
```

---

## **Common Prisma Queries**

### Create User
```typescript
const user = await prisma.user.create({
  data: {
    auth0UserId: session.user.sub,
    email: session.user.email,
    name: session.user.name
  }
})
```

### Find User with Stores
```typescript
const user = await prisma.user.findUnique({
  where: { auth0UserId: session.user.sub },
  include: { stores: true }
})
```

### Create Store
```typescript
const store = await prisma.store.create({
  data: {
    userId: user.id,
    storeName: "My Shop",
    storeSlug: "my-shop",
    description: "Welcome to my store"
  }
})
```

### Find Store by Slug
```typescript
const store = await prisma.store.findUnique({
  where: { storeSlug: "my-shop" },
  include: {
    products: {
      where: { status: "published" }
    }
  }
})
```

### Create Product
```typescript
const product = await prisma.product.create({
  data: {
    storeId: store.id,
    name: "T-Shirt",
    description: "Comfortable cotton t-shirt",
    price: 29.99,
    imageUrls: ["https://res.cloudinary.com/..."],
    status: "draft"
  }
})
```

### Get Store Products
```typescript
const products = await prisma.product.findMany({
  where: {
    storeId: store.id,
    status: "published"
  },
  orderBy: { createdAt: 'desc' }
})
```

### Create Order with Items
```typescript
const order = await prisma.order.create({
  data: {
    storeId: store.id,
    customerName: "John Doe",
    customerEmail: "john@example.com",
    shippingAddress: {
      street: "123 Main St",
      city: "San Francisco",
      state: "CA",
      zipCode: "94102",
      country: "USA"
    },
    totalAmount: 59.98,
    orderItems: {
      create: [
        {
          productId: product1.id,
          productName: product1.name,
          quantity: 2,
          priceAtPurchase: product1.price
        }
      ]
    }
  },
  include: {
    orderItems: true
  }
})
```

### Get Store Orders
```typescript
const orders = await prisma.order.findMany({
  where: { storeId: store.id },
  include: {
    orderItems: {
      include: { product: true }
    }
  },
  orderBy: { createdAt: 'desc' }
})
```

---

## **Multi-Tenancy Queries**

### Ensure Data Isolation
```typescript
// ✅ Good - Filter by storeId
const products = await prisma.product.findMany({
  where: {
    storeId: currentStoreId,  // Always filter by store
    status: "published"
  }
})

// ❌ Bad - Missing storeId filter (data leak!)
const products = await prisma.product.findMany({
  where: { status: "published" }
})
```

### Verify Ownership
```typescript
// Before deleting/updating, verify user owns the store
const store = await prisma.store.findFirst({
  where: {
    id: storeId,
    userId: session.user.dbId
  }
})

if (!store) {
  throw new Error('Unauthorized')
}
```

---

## **Row-Level Security (RLS)**

### Current Implementation (MVP)
```sql
-- Permissive policies for MVP (all operations allowed)
CREATE POLICY "Allow all operations on products" ON products
  FOR ALL USING (true) WITH CHECK (true);
```

### Production Implementation (Post-MVP)
```sql
-- Restrict based on session context
CREATE POLICY "Users can only see their store's products" ON products
  FOR SELECT USING (store_id = current_setting('app.current_store_id')::int);

CREATE POLICY "Users can only insert into their stores" ON products
  FOR INSERT WITH CHECK (store_id = current_setting('app.current_store_id')::int);
```

**Setting Session Context**:
```typescript
// Before queries
await prisma.$executeRaw`SET app.current_store_id = ${storeId}`
```

---

## **Database Indexes**

### Existing Indexes
```sql
CREATE INDEX idx_users_auth0_id ON users(auth0_user_id);
CREATE INDEX idx_stores_user_id ON stores(user_id);
CREATE INDEX idx_stores_slug ON stores(store_slug);
CREATE INDEX idx_products_store_id ON products(store_id);
CREATE INDEX idx_products_status ON products(status);
CREATE INDEX idx_orders_store_id ON orders(store_id);
CREATE INDEX idx_order_items_order_id ON order_items(order_id);
```

**Purpose**: Speed up common queries by store_id, slug, and status

---

## **Quick Reference**

### Find Operations
```typescript
findUnique()   // By unique field (@unique or @id)
findFirst()    // First match (can use any field)
findMany()     // All matches
```

### Create/Update/Delete
```typescript
create()       // Create one record
createMany()   // Create multiple records
update()       // Update one record
updateMany()   // Update multiple records
delete()       // Delete one record
deleteMany()   // Delete multiple records
```

### Relations
```typescript
include: { stores: true }              // Eager load relation
select: { id: true, name: true }       // Select specific fields
where: { stores: { some: { ... } } }   // Filter by relation
```

---

## **Prisma Studio**

Visual database editor:
```bash
npx prisma studio
```

Opens at `http://localhost:5555`:
- View all tables
- Edit records directly
- Test queries visually
- Explore relations

---

## **TypeScript Types**

Prisma generates types automatically:
```typescript
import { User, Store, Product, Order, OrderItem } from '@prisma/client'

// Include relations
import { Prisma } from '@prisma/client'

type StoreWithProducts = Prisma.StoreGetPayload<{
  include: { products: true }
}>

type OrderWithItems = Prisma.OrderGetPayload<{
  include: {
    orderItems: {
      include: { product: true }
    }
  }
}>
```

---

**Remember**: Always filter queries by `storeId` to maintain multi-tenant data isolation. The database structure is designed to support multiple stores per user with proper data segregation.
