# Khara Sauda

Khara Sauda is a B2B network for discovering businesses, connecting directly, communicating, and turning relationships into deals.

## Current MVP
- Responsive landing page
- Business discovery search and category filters
- Business profile creation prototype
- Connection and enquiry flow
- Local prototype persistence
- Mobile-first UI

## Production data model
`schema.sql` defines the core PostgreSQL model for businesses, products/services, connections, messages, and deals.

## Recommended production stack
- Next.js/React frontend
- Supabase/PostgreSQL for authentication and data
- Realtime messaging
- Object storage for business documents and images
- Payment provider for transactions

## Business flow
`Discover → Connect → Enquire → Negotiate → Confirm Deal → Complete`

## Security before launch
- Server-side authorization and row-level security
- Email/phone verification
- Business verification workflow
- Rate limiting and anti-spam controls
- Audit logs for deals and account actions
- Payment webhook verification
