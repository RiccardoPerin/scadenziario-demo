# Constructions Company Expiries Tracker — Demo

A compliance and asset management system built for a construction company to track job sites, subcontractors, employees, vehicles, machinery, and all the associated documents that come with expiry dates — insurance, inspections, safety training, and so on.

This repository is a **public demo build**: almost same codebase running in production at the company, pointed at a separate backend seeded with fake data instead of real company records. No client data, employee names, or business information from the original deployment is included here.

**Live demo:** https://riccardoperin.github.io/scadenziario-demo/
Login: `demo@demo.it` / Password: `demodemo`

## Why this exists

The company was managing job site documentation — insurance certificates, machinery inspections, safety training records, first aid kit contents — across spreadsheets and paper, with no reliable way to know what was about to expire. Missing a renewal on a piece of certified equipment or an employee's safety course isn't just an inconvenience on a construction site, it's a compliance risk.

This app centralizes all of that, tracks expiry dates against configurable warning thresholds, and sends automated email digests when something needs attention.

## What it does

- Tracks construction sites, subcontractors and their employees, company employees, vehicles, machinery, fire extinguishers, first aid kits, and building systems — each with its own set of relevant expiry dates
- Every document upload is versioned; the app always resolves the latest version for expiry checks while keeping the full upload history
- Configurable warning thresholds per document type (a driving license might need a 120-day heads-up, a generic insurance renewal just 30)
- A "reserved" note mechanism: mark an expiring item as already being renewed and it stops generating alert emails, without touching the underlying date or hiding it from the UI
- PDF export for printable tables and reports
- Cascading deletion handled client-side where the backend doesn't enforce it natively
- Italian and English localization
- Two-factor authentication via email OTP on top of PocketBase's native auth

In the version actually deployed for the client, the app also sends a daily automated email digest summarizing upcoming and overdue items, routed differently depending on recipient: internal admin staff gets everything grouped by job site, while each subcontractor only receives their own documents and their employees'. That part is company-specific (it's wired to the client's real mailboxes) and isn't included in this public demo.

## Stack

- **Frontend:** Flutter Web, state management via `provider`, routing via `go_router`
- **Backend:** [PocketBase](https://pocketbase.io) (Go, SQLite) — self-hosted, no separate ORM or API layer needed
- **Production deployment (client):** PocketBase running on a VPS behind an nginx reverse proxy, handling TLS termination and routing
- **This demo's deployment:** PocketBase on Railway, Flutter Web build on GitHub Pages

Flutter Web plus PocketBase turned out to be a good combination for this kind of internal tool: PocketBase's admin UI gives the client a way to poke at the data directly if ever needed, and its schema migrations kept ~170 incremental changes to the data model traceable over the course of development, without needing to run a separate backend project.

## Running it yourself

Both frontend and backend live in this repository.

```bash
# Backend
cd backend
./pocketbase serve
# Admin UI at http://localhost:8090/_/

# Frontend
flutter pub get
flutter run -d chrome
```

Point `lib/services/pocketbase_service.dart` at your local PocketBase instance if it's not already on `localhost:8090`.

## A note on the demo data

Everything you'll see logged in as `demo@demo.it` — job sites, company names, employee records, expiry dates — is fabricated. The demo account has read access only; write access is restricted to an admin account so the seeded data stays intact between visits.

The email OTP step is disabled on this demo instance, since the demo login isn't a real mailbox that could receive a code. It's part of the actual production login flow.

## Status

In production use at the company since August 2026. Development is ongoing and its sections and features are still being refined based on how the office actually uses them day to day.
