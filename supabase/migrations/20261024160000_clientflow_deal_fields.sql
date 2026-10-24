-- ClientFlow deal fields: where the lead came from, the package sold,
-- one-time or monthly revenue, and the currency (USD or ZWG, shown as ZiG).
alter table "public"."deals" add column "lead_source" text;
alter table "public"."deals" add column "package" text;
alter table "public"."deals" add column "revenue_type" text not null default 'one-time';
alter table "public"."deals" add column "currency" text not null default 'USD';
alter table "public"."deals" add constraint "deals_revenue_type_check" check (revenue_type in ('one-time', 'recurring'));
alter table "public"."deals" add constraint "deals_currency_check" check (currency in ('USD', 'ZWG'));
