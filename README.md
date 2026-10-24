# ClientFlow CRM

A CRM built by [ClientFlow Digital](https://github.com/clientflowdigital), tailored to how a small web agency works. It also captures leads from the websites we build.

> **Status:** planning. Building starts once the ClientFlow v2 website ships.

## Roadmap

1. **Internal tool:** ClientFlow uses it every day.
2. **Pilot:** a few friendly clients, ideally ones whose websites we build.
3. **Product:** sold more widely once the pilot shows people will pay.

Each phase starts only when the one before it is working.

## First version scope

**In:**

- Contacts and companies
- Deal pipeline: lead → contacted → proposal → won / lost
- Notes and follow-up reminders
- Website leads arriving automatically from the ClientFlow v2 contact form and chatbot
- Login, with each company's data kept separate (multi-tenant from day one)

**Out for now:** reports and dashboards, email sync, invoicing, mobile app, integrations marketplace.

## Planned stack

Not final. Forking an open-source CRM such as Atomic CRM would mean Supabase instead of a custom backend.

- **Backend:** TypeScript (Node, Fastify) with PostgreSQL
- **Frontend:** React / Next.js with Tailwind
- **Mobile, later:** Flutter or React Native

Secrets live in environment variables and are never committed.

## Contributors

- [ClientFlow Digital](https://github.com/clientflowdigital) (owner)
- [Roy Chidhungwana](https://github.com/roychid)
