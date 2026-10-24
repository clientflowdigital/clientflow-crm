# ClientFlow CRM

A CRM built by [ClientFlow Digital](https://github.com/clientflowdigital), tailored to how a small web agency works. It also captures leads from the websites we build.

> **Status:** early setup. The Atomic CRM base is in place. ClientFlow features start once the ClientFlow v2 website ships.

ClientFlow CRM is a fork of [Atomic CRM](https://github.com/marmelab/atomic-crm) by Marmelab (MIT). Upstream is tracked as the `upstream` git remote.

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

Atomic CRM already covers contacts, companies, the deal board, tasks, notes and login. The main work on top is multi-tenancy, the ClientFlow pipeline stages, website lead capture and branding.

## Stack

- **Frontend:** React, Vite, shadcn/ui, ra-core (react-admin's headless core)
- **Backend:** Supabase (PostgreSQL, auth, storage, edge functions)

Secrets live in environment variables and are never committed.

## Running locally

Requirements: Make, Node 24 LTS, and Docker (for the local Supabase instance).

```sh
make install   # frontend and backend dependencies, including local Supabase
make start     # Vite dev server, Supabase API and Postgres
```

Open <http://localhost:5173/> and create the first user. The local Supabase dashboard is at <http://localhost:54323/>.

## Tests

```sh
make test       # unit tests
make test-e2e   # end-to-end tests (Playwright)
```

## Pulling upstream updates

```sh
git fetch upstream
git merge upstream/main
```

Atomic CRM's own documentation is in [`doc/`](./doc/) and at <https://marmelab.com/atomic-crm/doc/>.

## Contributors

- [ClientFlow Digital](https://github.com/clientflowdigital) (owner)
- [Roy Chidhungwana](https://github.com/roychid)

## License

Atomic CRM is MIT licensed, © Francois Zaninotto, Marmelab. See [LICENSE.md](./LICENSE.md).
