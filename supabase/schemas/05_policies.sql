--
-- Row Level Security
-- This file declares RLS policies for all tables.
--

-- Enable RLS on all tables
alter table public.companies enable row level security;
alter table public.contacts enable row level security;
alter table public.contact_notes enable row level security;
alter table public.deals enable row level security;
alter table public.deal_notes enable row level security;
alter table public.sales enable row level security;
alter table public.tags enable row level security;
alter table public.tasks enable row level security;
alter table public.configuration enable row level security;
alter table public.favicons_excluded_domains enable row level security;

-- Access rules: Team users (and the admin) see everything. Marketing users
-- (freelance partners) see only the companies assigned to them through
-- companies.marketer_id, those companies' contacts, notes and tasks, and never
-- deals, deal notes or amounts. Contact notes and tasks rely on the contacts
-- policy: a marketing user can only reach a note through a contact they see.

-- Companies (marketing: read their assigned companies only)
create policy "Enable read access for authenticated users" on public.companies for select to authenticated using (not public.is_marketing() or marketer_id = public.current_sales_id());
create policy "Enable insert for authenticated users only" on public.companies for insert to authenticated with check (not public.is_marketing());
create policy "Enable update for authenticated users only" on public.companies for update to authenticated using (not public.is_marketing()) with check (not public.is_marketing());
create policy "Company Delete Policy" on public.companies for delete to authenticated using (not public.is_marketing());

-- Contacts (marketing: read, add and edit contacts of their companies)
create policy "Enable read access for authenticated users" on public.contacts for select to authenticated using (not public.is_marketing() or company_id in (select c.id from public.companies c where c.marketer_id = public.current_sales_id()));
create policy "Enable insert for authenticated users only" on public.contacts for insert to authenticated with check (not public.is_marketing() or company_id in (select c.id from public.companies c where c.marketer_id = public.current_sales_id()));
create policy "Enable update for authenticated users only" on public.contacts for update to authenticated using (not public.is_marketing() or company_id in (select c.id from public.companies c where c.marketer_id = public.current_sales_id())) with check (not public.is_marketing() or company_id in (select c.id from public.companies c where c.marketer_id = public.current_sales_id()));
create policy "Contact Delete Policy" on public.contacts for delete to authenticated using (not public.is_marketing());

-- Contact Notes (marketing: read and add on visible contacts, change only their own)
create policy "Enable read access for authenticated users" on public.contact_notes for select to authenticated using (not public.is_marketing() or exists (select 1 from public.contacts co where co.id = contact_id));
create policy "Enable insert for authenticated users only" on public.contact_notes for insert to authenticated with check (not public.is_marketing() or exists (select 1 from public.contacts co where co.id = contact_id));
create policy "Contact Notes Update policy" on public.contact_notes for update to authenticated using (not public.is_marketing() or (sales_id = public.current_sales_id() and exists (select 1 from public.contacts co where co.id = contact_id))) with check (not public.is_marketing() or (sales_id = public.current_sales_id() and exists (select 1 from public.contacts co where co.id = contact_id)));
create policy "Contact Notes Delete Policy" on public.contact_notes for delete to authenticated using (not public.is_marketing() or (sales_id = public.current_sales_id() and exists (select 1 from public.contacts co where co.id = contact_id)));

-- Deals (never visible to marketing: they carry amounts)
create policy "Enable read access for authenticated users" on public.deals for select to authenticated using (not public.is_marketing());
create policy "Enable insert for authenticated users only" on public.deals for insert to authenticated with check (not public.is_marketing());
create policy "Enable update for authenticated users only" on public.deals for update to authenticated using (not public.is_marketing()) with check (not public.is_marketing());
create policy "Deals Delete Policy" on public.deals for delete to authenticated using (not public.is_marketing());

-- Deal Notes (never visible to marketing)
create policy "Enable read access for authenticated users" on public.deal_notes for select to authenticated using (not public.is_marketing());
create policy "Enable insert for authenticated users only" on public.deal_notes for insert to authenticated with check (not public.is_marketing());
create policy "Deal Notes Update Policy" on public.deal_notes for update to authenticated using (not public.is_marketing());
create policy "Deal Notes Delete Policy" on public.deal_notes for delete to authenticated using (not public.is_marketing());

-- Sales
create policy "Enable read access for authenticated users" on public.sales for select to authenticated using (true);

-- Tags (everyone reads, marketing cannot change them)
create policy "Enable read access for authenticated users" on public.tags for select to authenticated using (true);
create policy "Enable insert for authenticated users only" on public.tags for insert to authenticated with check (not public.is_marketing());
create policy "Enable update for authenticated users only" on public.tags for update to authenticated using (not public.is_marketing());
create policy "Enable delete for authenticated users only" on public.tags for delete to authenticated using (not public.is_marketing());

-- Tasks (marketing: read and add on visible contacts, change only their own)
create policy "Enable read access for authenticated users" on public.tasks for select to authenticated using (not public.is_marketing() or exists (select 1 from public.contacts co where co.id = contact_id));
create policy "Enable insert for authenticated users only" on public.tasks for insert to authenticated with check (not public.is_marketing() or exists (select 1 from public.contacts co where co.id = contact_id));
create policy "Task Update Policy" on public.tasks for update to authenticated using (not public.is_marketing() or (sales_id = public.current_sales_id() and exists (select 1 from public.contacts co where co.id = contact_id))) with check (not public.is_marketing() or (sales_id = public.current_sales_id() and exists (select 1 from public.contacts co where co.id = contact_id)));
create policy "Task Delete Policy" on public.tasks for delete to authenticated using (not public.is_marketing() or (sales_id = public.current_sales_id() and exists (select 1 from public.contacts co where co.id = contact_id)));

-- Configuration (admin-only for writes)
create policy "Enable read for authenticated" on public.configuration for select to authenticated using (true);
create policy "Enable insert for admins" on public.configuration for insert to authenticated with check (public.is_admin());
create policy "Enable update for admins" on public.configuration for update to authenticated using (public.is_admin()) with check (public.is_admin());

-- Favicons excluded domains
create policy "Enable access for authenticated users only" on public.favicons_excluded_domains to authenticated using (true) with check (true);
