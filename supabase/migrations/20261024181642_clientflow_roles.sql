-- ClientFlow roles: Team users see everything; Marketing users (freelance
-- partners) see only the companies assigned to them via companies.marketer_id,
-- those companies' contacts, notes and tasks, and never deals or amounts.
-- Hand-edited after `supabase db diff`: removed an unrelated "drop extension
-- pgjwt" and the recreation of activity_log, companies_summary and
-- contacts_summary, which dropped their security_invoker option and would
-- have let those views bypass these policies.

drop policy "Company Delete Policy" on "public"."companies";

drop policy "Enable insert for authenticated users only" on "public"."companies";

drop policy "Enable read access for authenticated users" on "public"."companies";

drop policy "Enable update for authenticated users only" on "public"."companies";

drop policy "Contact Notes Delete Policy" on "public"."contact_notes";

drop policy "Contact Notes Update policy" on "public"."contact_notes";

drop policy "Enable insert for authenticated users only" on "public"."contact_notes";

drop policy "Enable read access for authenticated users" on "public"."contact_notes";

drop policy "Contact Delete Policy" on "public"."contacts";

drop policy "Enable insert for authenticated users only" on "public"."contacts";

drop policy "Enable read access for authenticated users" on "public"."contacts";

drop policy "Enable update for authenticated users only" on "public"."contacts";

drop policy "Deal Notes Delete Policy" on "public"."deal_notes";

drop policy "Deal Notes Update Policy" on "public"."deal_notes";

drop policy "Enable insert for authenticated users only" on "public"."deal_notes";

drop policy "Enable read access for authenticated users" on "public"."deal_notes";

drop policy "Deals Delete Policy" on "public"."deals";

drop policy "Enable insert for authenticated users only" on "public"."deals";

drop policy "Enable read access for authenticated users" on "public"."deals";

drop policy "Enable update for authenticated users only" on "public"."deals";

drop policy "Enable delete for authenticated users only" on "public"."tags";

drop policy "Enable insert for authenticated users only" on "public"."tags";

drop policy "Enable update for authenticated users only" on "public"."tags";

drop policy "Enable insert for authenticated users only" on "public"."tasks";

drop policy "Enable read access for authenticated users" on "public"."tasks";

drop policy "Task Delete Policy" on "public"."tasks";

drop policy "Task Update Policy" on "public"."tasks";

alter table "public"."companies" add column "marketer_id" bigint;

alter table "public"."sales" add column "role" text not null default 'team'::text;

alter table "public"."companies" add constraint "companies_marketer_id_fkey" FOREIGN KEY (marketer_id) REFERENCES public.sales(id) ON DELETE SET NULL not valid;

alter table "public"."companies" validate constraint "companies_marketer_id_fkey";

alter table "public"."sales" add constraint "sales_role_check" CHECK ((role = ANY (ARRAY['team'::text, 'marketing'::text]))) not valid;

alter table "public"."sales" validate constraint "sales_role_check";

set check_function_bodies = off;

CREATE OR REPLACE FUNCTION public.current_sales_id()
 RETURNS bigint
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select id from public.sales where user_id = auth.uid();
$function$
;

CREATE OR REPLACE FUNCTION public.is_marketing()
 RETURNS boolean
 LANGUAGE sql
 STABLE SECURITY DEFINER
 SET search_path TO ''
AS $function$
  select exists (
    select 1 from public.sales where user_id = auth.uid() and role = 'marketing'
  );
$function$
;


  create policy "Company Delete Policy"
  on "public"."companies"
  as permissive
  for delete
  to authenticated
using ((NOT public.is_marketing()));



  create policy "Enable insert for authenticated users only"
  on "public"."companies"
  as permissive
  for insert
  to authenticated
with check ((NOT public.is_marketing()));



  create policy "Enable read access for authenticated users"
  on "public"."companies"
  as permissive
  for select
  to authenticated
using (((NOT public.is_marketing()) OR (marketer_id = public.current_sales_id())));



  create policy "Enable update for authenticated users only"
  on "public"."companies"
  as permissive
  for update
  to authenticated
using ((NOT public.is_marketing()))
with check ((NOT public.is_marketing()));



  create policy "Contact Notes Delete Policy"
  on "public"."contact_notes"
  as permissive
  for delete
  to authenticated
using (((NOT public.is_marketing()) OR ((sales_id = public.current_sales_id()) AND (EXISTS ( SELECT 1
   FROM public.contacts co
  WHERE (co.id = contact_notes.contact_id))))));



  create policy "Contact Notes Update policy"
  on "public"."contact_notes"
  as permissive
  for update
  to authenticated
using (((NOT public.is_marketing()) OR ((sales_id = public.current_sales_id()) AND (EXISTS ( SELECT 1
   FROM public.contacts co
  WHERE (co.id = contact_notes.contact_id))))))
with check (((NOT public.is_marketing()) OR ((sales_id = public.current_sales_id()) AND (EXISTS ( SELECT 1
   FROM public.contacts co
  WHERE (co.id = contact_notes.contact_id))))));



  create policy "Enable insert for authenticated users only"
  on "public"."contact_notes"
  as permissive
  for insert
  to authenticated
with check (((NOT public.is_marketing()) OR (EXISTS ( SELECT 1
   FROM public.contacts co
  WHERE (co.id = contact_notes.contact_id)))));



  create policy "Enable read access for authenticated users"
  on "public"."contact_notes"
  as permissive
  for select
  to authenticated
using (((NOT public.is_marketing()) OR (EXISTS ( SELECT 1
   FROM public.contacts co
  WHERE (co.id = contact_notes.contact_id)))));



  create policy "Contact Delete Policy"
  on "public"."contacts"
  as permissive
  for delete
  to authenticated
using ((NOT public.is_marketing()));



  create policy "Enable insert for authenticated users only"
  on "public"."contacts"
  as permissive
  for insert
  to authenticated
with check (((NOT public.is_marketing()) OR (company_id IN ( SELECT c.id
   FROM public.companies c
  WHERE (c.marketer_id = public.current_sales_id())))));



  create policy "Enable read access for authenticated users"
  on "public"."contacts"
  as permissive
  for select
  to authenticated
using (((NOT public.is_marketing()) OR (company_id IN ( SELECT c.id
   FROM public.companies c
  WHERE (c.marketer_id = public.current_sales_id())))));



  create policy "Enable update for authenticated users only"
  on "public"."contacts"
  as permissive
  for update
  to authenticated
using (((NOT public.is_marketing()) OR (company_id IN ( SELECT c.id
   FROM public.companies c
  WHERE (c.marketer_id = public.current_sales_id())))))
with check (((NOT public.is_marketing()) OR (company_id IN ( SELECT c.id
   FROM public.companies c
  WHERE (c.marketer_id = public.current_sales_id())))));



  create policy "Deal Notes Delete Policy"
  on "public"."deal_notes"
  as permissive
  for delete
  to authenticated
using ((NOT public.is_marketing()));



  create policy "Deal Notes Update Policy"
  on "public"."deal_notes"
  as permissive
  for update
  to authenticated
using ((NOT public.is_marketing()));



  create policy "Enable insert for authenticated users only"
  on "public"."deal_notes"
  as permissive
  for insert
  to authenticated
with check ((NOT public.is_marketing()));



  create policy "Enable read access for authenticated users"
  on "public"."deal_notes"
  as permissive
  for select
  to authenticated
using ((NOT public.is_marketing()));



  create policy "Deals Delete Policy"
  on "public"."deals"
  as permissive
  for delete
  to authenticated
using ((NOT public.is_marketing()));



  create policy "Enable insert for authenticated users only"
  on "public"."deals"
  as permissive
  for insert
  to authenticated
with check ((NOT public.is_marketing()));



  create policy "Enable read access for authenticated users"
  on "public"."deals"
  as permissive
  for select
  to authenticated
using ((NOT public.is_marketing()));



  create policy "Enable update for authenticated users only"
  on "public"."deals"
  as permissive
  for update
  to authenticated
using ((NOT public.is_marketing()))
with check ((NOT public.is_marketing()));



  create policy "Enable delete for authenticated users only"
  on "public"."tags"
  as permissive
  for delete
  to authenticated
using ((NOT public.is_marketing()));



  create policy "Enable insert for authenticated users only"
  on "public"."tags"
  as permissive
  for insert
  to authenticated
with check ((NOT public.is_marketing()));



  create policy "Enable update for authenticated users only"
  on "public"."tags"
  as permissive
  for update
  to authenticated
using ((NOT public.is_marketing()));



  create policy "Enable insert for authenticated users only"
  on "public"."tasks"
  as permissive
  for insert
  to authenticated
with check (((NOT public.is_marketing()) OR (EXISTS ( SELECT 1
   FROM public.contacts co
  WHERE (co.id = tasks.contact_id)))));



  create policy "Enable read access for authenticated users"
  on "public"."tasks"
  as permissive
  for select
  to authenticated
using (((NOT public.is_marketing()) OR (EXISTS ( SELECT 1
   FROM public.contacts co
  WHERE (co.id = tasks.contact_id)))));



  create policy "Task Delete Policy"
  on "public"."tasks"
  as permissive
  for delete
  to authenticated
using (((NOT public.is_marketing()) OR ((sales_id = public.current_sales_id()) AND (EXISTS ( SELECT 1
   FROM public.contacts co
  WHERE (co.id = tasks.contact_id))))));



  create policy "Task Update Policy"
  on "public"."tasks"
  as permissive
  for update
  to authenticated
using (((NOT public.is_marketing()) OR ((sales_id = public.current_sales_id()) AND (EXISTS ( SELECT 1
   FROM public.contacts co
  WHERE (co.id = tasks.contact_id))))))
with check (((NOT public.is_marketing()) OR ((sales_id = public.current_sales_id()) AND (EXISTS ( SELECT 1
   FROM public.contacts co
  WHERE (co.id = tasks.contact_id))))));



