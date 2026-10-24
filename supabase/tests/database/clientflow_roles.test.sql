-- ClientFlow roles: a Marketing user sees only the companies assigned to them,
-- those companies' contacts, notes and tasks, and never deals or amounts.
-- Run with: npx supabase test db
begin;
create extension if not exists pgtap with schema extensions;
select plan(24);

-- Fixtures, created as the database owner (RLS does not apply).
insert into auth.users (id, email, raw_user_meta_data) values
  ('00000000-0000-0000-0000-0000000000a1', 'team-test@example.com', '{"first_name":"Team","last_name":"Test"}'),
  ('00000000-0000-0000-0000-0000000000b2', 'marketing-test@example.com', '{"first_name":"Marketing","last_name":"Test"}');
update public.sales set role = 'marketing' where email = 'marketing-test@example.com';

insert into public.companies (id, name, marketer_id) values
  (900001, 'Assigned Co', (select id from public.sales where email = 'marketing-test@example.com')),
  (900002, 'Other Co', null);
insert into public.contacts (id, first_name, company_id) values
  (900011, 'Assigned', 900001),
  (900012, 'Other', 900002);
insert into public.deals (id, name, company_id, stage, amount) values
  (900021, 'Assigned deal', 900001, 'new-enquiry', 5000),
  (900022, 'Other deal', 900002, 'new-enquiry', 7000);
insert into public.deal_notes (deal_id, text) values (900021, 'Price agreed at 5000');
insert into public.contact_notes (id, contact_id, text, sales_id) values
  (900031, 900011, 'Note on assigned contact', (select id from public.sales where email = 'team-test@example.com')),
  (900032, 900012, 'Note on other contact', (select id from public.sales where email = 'team-test@example.com'));
insert into public.tasks (contact_id, text) values (900011, 'Assigned task'), (900012, 'Other task');

-- Act as the Marketing user.
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-0000000000b2","role":"authenticated"}', true);

select ok(public.is_marketing(), 'marketing user is recognised');
select is((select count(*) from public.companies where id >= 900001)::int, 1, 'marketing sees only the assigned company');
select is((select name from public.companies where id >= 900001), 'Assigned Co', 'the visible company is the assigned one');
select is((select count(*) from public.contacts where id >= 900011)::int, 1, 'marketing sees only contacts of the assigned company');
select is((select count(*) from public.deals)::int, 0, 'marketing sees no deals at all');
select is((select count(*) from public.deal_notes)::int, 0, 'marketing sees no deal notes');
select is((select count(*) from public.contact_notes where id >= 900031)::int, 1, 'marketing sees notes of visible contacts only');
select is((select count(*) from public.tasks where contact_id >= 900011)::int, 1, 'marketing sees tasks of visible contacts only');
select is((select count(*) from public.companies_summary where id >= 900001)::int, 1, 'companies_summary is filtered too');
select is((select nb_deals from public.companies_summary where id = 900001)::int, 0, 'companies_summary does not count hidden deals');
select is((select count(*) from public.contacts_summary where id >= 900011)::int, 1, 'contacts_summary is filtered too');
select is((select count(*) from public.activity_log where deal is not null or deal_note is not null)::int, 0, 'activity log has no deal entries');
select is((select count(*) from public.global_search('Assigned deal'))::int, 0, 'global search does not return deals');

select lives_ok($$ insert into public.contacts (first_name, company_id) values ('New', 900001) $$, 'marketing can add a contact to an assigned company');
select throws_ok($$ insert into public.contacts (first_name, company_id) values ('Sneaky', 900002) $$, '42501', null, 'marketing cannot add a contact to another company');
select throws_ok($$ insert into public.deals (name, company_id, stage, amount) values ('Sneaky', 900001, 'new-enquiry', 1) $$, '42501', null, 'marketing cannot create deals');
select throws_ok($$ insert into public.companies (name) values ('Sneaky Co') $$, '42501', null, 'marketing cannot create companies');
select lives_ok($$ insert into public.contact_notes (contact_id, text) values (900011, 'Called them') $$, 'marketing can add a note to a visible contact');

update public.companies set name = 'Renamed' where id = 900001;
update public.sales set role = 'team' where email = 'marketing-test@example.com';
update public.contact_notes set text = 'Edited' where id = 900031;
delete from public.contacts where id = 900011;

-- Back to the database owner to check that nothing changed.
reset role;
select is((select name from public.companies where id = 900001), 'Assigned Co', 'marketing cannot rename a company');
select is((select role from public.sales where email = 'marketing-test@example.com'), 'marketing', 'marketing cannot change their own role');
select is((select text from public.contact_notes where id = 900031), 'Note on assigned contact', 'marketing cannot edit someone else''s note');
select is((select count(*) from public.contacts where id = 900011)::int, 1, 'marketing cannot delete contacts');

-- Act as the Team user.
set local role authenticated;
select set_config('request.jwt.claims', '{"sub":"00000000-0000-0000-0000-0000000000a1","role":"authenticated"}', true);
select is((select count(*) from public.companies where id >= 900001)::int, 2, 'team sees every company');
select is((select sum(amount) from public.deals where id >= 900021)::int, 12000, 'team sees every deal and its amount');

select * from finish();
rollback;
