# Shopify-Like E-Commerce Platform

A full-stack, multi-tenant e-commerce platform built with modern web technologies. This project demonstrates professional development practices, system architecture, and domain expertise in e-commerce.

## Project Status
🚧 **In Development** - Phase 1: Project Initialization

## Tech Stack

### Frontend
- **Framework:** Next.js 15 (App Router)
- **Language:** TypeScript (strict mode)
- **Styling:** Tailwind CSS 4
- **State Management:** TanStack Query v5

### Backend
- **Database:** Supabase (PostgreSQL)
- **ORM:** Prisma
- **Authentication:** Auth0
- **File Storage:** Cloudinary

### DevOps
- **Hosting:** Vercel
- **Version Control:** GitHub Flow
- **Project Management:** GitHub Projects + Issues

## Project Structure

```
shopify-clone/
├── docs/
│   ├── adr/              # Architectural Decision Records
│   └── planning/         # Project plans and checklists
├── src/
│   ├── app/              # Next.js App Router
│   ├── components/       # React components
│   ├── lib/              # Utility functions
│   └── types/            # TypeScript types
└── prisma/
    └── schema.prisma     # Database schema
```

## Development Workflow

This project follows professional development practices:
- **GitHub Flow:** Feature branches + Pull Requests
- **Conventional Commits:** Semantic commit messages
- **Atomic Commits:** One logical change per commit
- **Self-Reviewed PRs:** Quality gate before merge
- **ADRs:** Documented architectural decisions

## Getting Started

_Installation instructions will be added after Phase 1 setup_

## Features

### MVP Scope (Weeks 1-5)
- [ ] Admin authentication via Auth0
- [ ] Multi-store management dashboard
- [ ] Product CRUD operations
- [ ] Public storefront with product display
- [ ] Shopping cart (localStorage)
- [ ] Simulated checkout process
- [ ] Order management for admins

### Post-MVP Features
- Theme customization engine
- Staff permissions and roles
- Real payment integration (Stripe)
- Inventory tracking
- Analytics dashboard
- Email notifications

## Project Management

- **Issues:** [GitHub Issues](https://github.com/YOUR_USERNAME/shopify-clone/issues)
- **Project Board:** [GitHub Projects](https://github.com/YOUR_USERNAME/shopify-clone/projects)
- **ADRs:** [docs/adr/](./docs/adr/)

## Architectural Decisions

Key technical decisions are documented in ADRs:
- [ADR 0001: Auth0 for Authentication](./docs/adr/0001-use-auth0-for-authentication.md)
- [ADR 0002: Supabase with Row-Level Security](./docs/adr/0002-use-supabase-with-row-level-security.md)

## Developer

**Background:** MERN stack developer with real-world Shopify admin experience (Eleve Dancewear). Former ballet dancer with the National Ballet of Cuba, bringing operations and analytical mindset to software development.

## License

MIT License - See LICENSE file for details

---

_This project is part of a professional portfolio demonstrating full-stack capabilities, system design, and e-commerce domain expertise._
```