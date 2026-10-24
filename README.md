# ClientFlow CRM

ClientFlow Digital's own CRM, tailored to how we work as a small web agency. It also captures leads from the websites we build.

> **Status:** in active development, starting from the Atomic CRM base.

ClientFlow CRM is a fork of [Atomic CRM](https://github.com/marmelab/atomic-crm) by Marmelab (MIT). Upstream is tracked as the `upstream` git remote.

## Scope

This repo is for ClientFlow's internal use only: one company, no multi-tenancy. If we later sell a CRM to clients, that product will be a separate fork of this repo.

## First version scope

**In:**

- Contacts and companies
- Deal pipeline: lead → contacted → proposal → won / lost
- Notes and follow-up reminders
- Website leads arriving automatically from the ClientFlow v2 contact form and chatbot
- Login for the ClientFlow team

**Out for now:** reports and dashboards, email sync, invoicing, mobile app, integrations marketplace.

Atomic CRM already covers contacts, companies, the deal board, tasks, notes and login. ClientFlow branding and pipeline stages are in place. The main remaining work is website lead capture and a production setup with public signups turned off.

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
