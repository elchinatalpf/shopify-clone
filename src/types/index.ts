import { Prisma } from "@/generated/prisma";

// User types
export type User = Prisma.UserGetPayload<{}>;
export type UserWithStores = Prisma.UserGetPayload<{
    include: { stores: true }
}>;

// Store types
export type Store = Prisma.StoreGetPayload<{}>;
export type StoreWithProducts = Prisma.StoreGetPayload<{
    include: { products: true }
}>;

// Product types
export type Product = Prisma.ProductGetPayload<{}>;
export type ProductWithStore = Prisma.ProductGetPayload<{
    include: { store: true }
}>;

// Order types
export type Order = Prisma.OrderGetPayload<{}>;
export type OrderWithItems = Prisma.OrderGetPayload<{
    include: { orderItems: { include: { product: true } } }
}>;

// Order Item types
export type OrderItem = Prisma.OrderItemGetPayload<{}>;

//API Responses types
export interface ApiResponse<T = unknown> {
    success: boolean
    data?: T
    error?: string
    message?: string
};

// Form types
export interface CreateStoreInput {
    storeName: string
    storeSlug: string
    description?: string
};

export interface CreateProductInput {
    storeId: number
    name: string
    description?: string
    price: number
    stockQuantity?: number
    imageUrls: string[]
    status?: 'draft' | 'active' | 'archived'
};

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