-- Khara Sauda production schema
-- Apply this file through Supabase migrations in production.
create extension if not exists pgcrypto;

create table if not exists public.businesses (id uuid primary key default gen_random_uuid(), owner_id uuid not null references auth.users(id) on delete cascade, name text not null, category text not null, description text, location text, phone text, website text, created_at timestamptz not null default now(), updated_at timestamptz not null default now(), unique(owner_id));
create table if not exists public.connections (id uuid primary key default gen_random_uuid(), requester_id uuid not null references auth.users(id) on delete cascade, recipient_id uuid not null references auth.users(id) on delete cascade, status text not null default 'pending' check(status in ('pending','accepted','rejected','blocked')), created_at timestamptz not null default now(), updated_at timestamptz not null default now(), unique(requester_id,recipient_id), check(requester_id<>recipient_id));
create table if not exists public.messages (id uuid primary key default gen_random_uuid(), connection_id uuid not null references public.connections(id) on delete cascade, sender_id uuid not null references auth.users(id) on delete cascade, body text not null, created_at timestamptz not null default now());
create table if not exists public.deals (id uuid primary key default gen_random_uuid(), connection_id uuid not null references public.connections(id) on delete cascade, created_by uuid not null references auth.users(id) on delete cascade, title text not null, description text, value numeric(14,2), status text not null default 'enquiry' check(status in ('enquiry','negotiation','confirmed','completed','cancelled')), created_at timestamptz not null default now(), updated_at timestamptz not null default now());

create index if not exists businesses_category_idx on public.businesses(category);
create index if not exists businesses_location_idx on public.businesses(location);
create index if not exists connections_requester_idx on public.connections(requester_id);
create index if not exists connections_recipient_idx on public.connections(recipient_id);
create index if not exists messages_connection_idx on public.messages(connection_id,created_at);
create index if not exists deals_connection_idx on public.deals(connection_id);

alter table public.businesses enable row level security;
alter table public.connections enable row level security;
alter table public.messages enable row level security;
alter table public.deals enable row level security;

create policy "businesses public read" on public.businesses for select to authenticated using (true);
create policy "business owners insert" on public.businesses for insert to authenticated with check ((select auth.uid())=owner_id);
create policy "business owners update" on public.businesses for update to authenticated using ((select auth.uid())=owner_id) with check ((select auth.uid())=owner_id);
create policy "business owners delete" on public.businesses for delete to authenticated using ((select auth.uid())=owner_id);

create policy "participants read connections" on public.connections for select to authenticated using ((select auth.uid())=requester_id or (select auth.uid())=recipient_id);
create policy "requester creates connection" on public.connections for insert to authenticated with check ((select auth.uid())=requester_id);
create policy "participants update connection" on public.connections for update to authenticated using ((select auth.uid())=requester_id or (select auth.uid())=recipient_id) with check ((select auth.uid())=requester_id or (select auth.uid())=recipient_id);
create policy "requester deletes connection" on public.connections for delete to authenticated using ((select auth.uid())=requester_id);

create policy "participants read messages" on public.messages for select to authenticated using (exists(select 1 from public.connections c where c.id=connection_id and ((select auth.uid())=c.requester_id or (select auth.uid())=c.recipient_id)));
create policy "participants send messages" on public.messages for insert to authenticated with check ((select auth.uid())=sender_id and exists(select 1 from public.connections c where c.id=connection_id and c.status='accepted' and ((select auth.uid())=c.requester_id or (select auth.uid())=c.recipient_id)));

create policy "participants read deals" on public.deals for select to authenticated using (exists(select 1 from public.connections c where c.id=connection_id and ((select auth.uid())=c.requester_id or (select auth.uid())=c.recipient_id)));
create policy "participants create deals" on public.deals for insert to authenticated with check ((select auth.uid())=created_by and exists(select 1 from public.connections c where c.id=connection_id and c.status='accepted' and ((select auth.uid())=c.requester_id or (select auth.uid())=c.recipient_id)));
create policy "deal participants update" on public.deals for update to authenticated using (exists(select 1 from public.connections c where c.id=connection_id and ((select auth.uid())=c.requester_id or (select auth.uid())=c.recipient_id))) with check (exists(select 1 from public.connections c where c.id=connection_id and ((select auth.uid())=c.requester_id or (select auth.uid())=c.recipient_id)));

alter table public.messages replica identity full;
alter table public.connections replica identity full;
alter table public.deals replica identity full;