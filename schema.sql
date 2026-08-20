-- Khara Sauda production data model (PostgreSQL / Supabase)
create extension if not exists pgcrypto;

create table if not exists businesses (
  id uuid primary key default gen_random_uuid(),
  owner_id uuid,
  name text not null,
  slug text unique,
  category text not null,
  description text,
  location text,
  website text,
  phone text,
  verified boolean default false,
  created_at timestamptz default now()
);

create table if not exists business_products (
  id uuid primary key default gen_random_uuid(),
  business_id uuid not null references businesses(id) on delete cascade,
  name text not null,
  description text,
  type text default 'product',
  created_at timestamptz default now()
);

create table if not exists connections (
  id uuid primary key default gen_random_uuid(),
  requester_business_id uuid not null references businesses(id) on delete cascade,
  recipient_business_id uuid not null references businesses(id) on delete cascade,
  status text not null default 'pending' check (status in ('pending','accepted','rejected','blocked')),
  created_at timestamptz default now(),
  unique(requester_business_id, recipient_business_id)
);

create table if not exists messages (
  id uuid primary key default gen_random_uuid(),
  sender_business_id uuid not null references businesses(id) on delete cascade,
  recipient_business_id uuid not null references businesses(id) on delete cascade,
  body text not null,
  read_at timestamptz,
  created_at timestamptz default now()
);

create table if not exists deals (
  id uuid primary key default gen_random_uuid(),
  buyer_business_id uuid not null references businesses(id),
  seller_business_id uuid not null references businesses(id),
  title text not null,
  description text,
  amount numeric(14,2),
  currency text default 'INR',
  status text not null default 'enquiry' check (status in ('enquiry','negotiation','confirmed','completed','cancelled')),
  created_at timestamptz default now(),
  updated_at timestamptz default now()
);

create index if not exists businesses_category_idx on businesses(category);
create index if not exists businesses_location_idx on businesses(location);
create index if not exists messages_recipient_idx on messages(recipient_business_id, created_at);
create index if not exists deals_status_idx on deals(status);
