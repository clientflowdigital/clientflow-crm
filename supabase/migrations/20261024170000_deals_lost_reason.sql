-- Restore the lost reason (Atomic CRM added it on 2026-09-24, then reverted it).
-- ClientFlow records why each lost deal was lost.
alter table "public"."deals" add column "lost_reason" text;
