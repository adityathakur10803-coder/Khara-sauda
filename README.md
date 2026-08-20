# Khara Sauda

Khara Sauda is a B2B business network where businesses can discover one another, connect, communicate, send structured enquiries and turn accepted requirements into trackable deals.

## Current MVP

- Real Supabase authentication for business accounts
- Business profiles and public business pages
- Product/service catalog
- Searchable B2B marketplace
- Business verification request/status
- Connection requests
- Connection-based messaging foundation
- Structured buyer enquiries with quantity, unit, required date and budget
- Seller enquiry inbox with response and status actions
- Buyer enquiry tracking
- Enquiry → deal conversion
- Deal participants linked to buyer and seller business
- Deal lifecycle: proposed → negotiating → accepted → in progress → completed/cancelled/rejected
- Deal event/history timeline
- In-app notifications for enquiries and deal changes
- Row Level Security for business, catalog, verification, enquiry, notification and deal data
- Responsive mobile-first HTML/CSS/JS frontend

## Main pages

- `index.html` — public landing page
- `auth.html` — sign in / create business account
- `dashboard.html` — authenticated business dashboard
- `marketplace.html` — product/service discovery
- `business.html?id=...` — public business profile
- `catalog.html` — manage products/services
- `verification.html` — submit verification request
- `connections.html` — connections and messaging
- `enquiry.html?...` — send a structured enquiry
- `my-enquiries.html` — buyer enquiry tracking
- `enquiries.html` — seller enquiry inbox
- `deal-from-enquiry.html?id=...` — convert an accepted enquiry to a deal
- `deals.html` — deal list
- `deal.html?id=...` — deal lifecycle and history
- `notifications.html` — notification center

## Supabase

The browser uses only the Supabase project URL and a publishable/anon key. Never put a service-role/secret key in `config.js`.

`config.js` is configured for the current Supabase project. `config.example.js` is provided as a template for another deployment.

The current database includes RLS-protected tables for businesses, products/services, business verification, connections, messages, enquiries, deals, deal events and notifications.

## Business flow

`Discover → Business Profile → Connect / Enquire → Respond → Negotiate → Deal → Complete`

## Before public commercial launch

This MVP still needs production-grade additions such as:

- Business/KYC document review and admin tooling
- Phone/email verification and account recovery UX
- Rate limiting, abuse prevention and moderation
- Secure file uploads for documents/images
- Legal terms, privacy policy and consent flows
- Payment/escrow integration with verified webhooks
- Invoicing, tax/GST workflows and transaction reconciliation
- Delivery/fulfilment tracking
- Automated testing and CI/CD
- Backup, monitoring and audit/incident processes
