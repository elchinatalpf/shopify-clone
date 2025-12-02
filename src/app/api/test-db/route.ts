import { NextResponse } from "next/server";
import { prisma } from "@/lib/prisma";


export async function GET() {
    try {
        // test the database connection
        await prisma.$queryRaw`SELECT 1`;

        // count tables
        const userCount = await prisma.user.count();
        const storeCount = await prisma.store.count();

        return NextResponse.json({
            status: 'success',
            message: 'Database connection successful',
            data: {
                users: userCount,
                stores: storeCount
            },
        });
    } catch (err) {
        console.error("Database connection error:", err);
        return NextResponse.json({
            status: 'error',
            message: 'Database connection failed',
            error: err instanceof Error ? err.message : String(err),
        }, { status: 500 }
        );
    }
}