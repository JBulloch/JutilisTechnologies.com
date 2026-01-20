# JutilisTechnologies.com

A SaaS incubator showcase platform built with Phoenix 1.8, LiveView 1.1, and PostgreSQL. Features venture portfolios, pitch deck management, investor engagement, and a SaaS Launchpad tool roadmap. Deployed on Fly.io.

**Version:** 1.7.0

---

## Key Features

| Feature | Description |
|---------|-------------|
| **Venture Showcase** | Professional landing pages for active ventures |
| **Pitch Deck Management** | Admin dashboard for investor pitch decks |
| **Investor Portal** | Secure access for approved investors |
| **Two-Factor Authentication** | TOTP (authenticator app) and Email OTP support |
| **Field Encryption** | AES-GCM-256 encryption for sensitive data |
| **SaaS Launchpad** | Tool recommendations organized by development phase |
| **Portfolio System** | Multi-tenant portfolios with custom domains |
| **Real-time Updates** | LiveView for dynamic content |

---

## Tech Stack

- **Backend:** Elixir 1.16, Phoenix 1.8, LiveView 1.1
- **Frontend:** Tailwind CSS, DaisyUI
- **Database:** PostgreSQL 15
- **Authentication:** Phoenix Auth + 2FA (NimbleTOTP, Cloak encryption)
- **Deployment:** Fly.io
- **Version Management:** asdf

---

## Quick Start

### Prerequisites

- [asdf](https://asdf-vm.com/) for version management
- PostgreSQL (via Docker or local install)

### Setup

```bash
# Run automated setup
./bin/setup.sh

# Or manually:
asdf install                    # Install Elixir, Erlang, Node.js
mix setup                       # Install deps, setup DB, build assets
```

### Development

```bash
# Start PostgreSQL (if using Docker)
docker-compose up -d db

# Start the Phoenix server
mix phx.server

# Or with interactive shell
iex -S mix phx.server

# Interactive menu
./bin/repo-menu.sh
```

Visit [http://localhost:4000](http://localhost:4000)

### Default Admin

```
Email: jbulloch@jutilistechnologies.com
Password: admin123456789
```

**Change password immediately at:** `/users/settings`

---

## Project Structure

```
lib/
├── jutilis/                      # Domain logic (contexts)
│   ├── accounts/                 # Users, auth, 2FA
│   ├── launchpad/                # SaaS tool roadmap
│   ├── pitch_decks/              # Investor pitch decks
│   ├── portfolios/               # User portfolios
│   ├── subscribers/              # Email subscribers
│   ├── ventures/                 # Venture showcase
│   ├── encrypted.ex              # Cloak encrypted types
│   ├── vault.ex                  # Encryption vault
│   └── release.ex                # Production release tasks
│
├── jutilis_web/                  # Web layer
│   ├── components/               # Reusable UI components
│   ├── controllers/              # HTTP controllers
│   ├── live/                     # LiveView modules
│   │   ├── admin_live/           # Admin dashboard
│   │   ├── investor_live/        # Investor views
│   │   ├── portfolio_live/       # Portfolio management
│   │   └── pitch_deck_live/      # Pitch deck views
│   └── router.ex

test/                             # Test suite
├── jutilis/                      # Context tests
├── jutilis_web/                  # Web layer tests
└── support/                      # Test helpers & fixtures

bin/                              # Scripts
├── setup.sh                      # Project setup
├── repo-menu.sh                  # Interactive menu
└── deploy.sh                     # Versioned deployment
```

---

## Routes

### Public
- `/` - Portfolio home page
- `/p/:slug` - Portfolio by slug
- `/investors/pitch-decks` - Public pitch deck listing

### Authentication
- `/users/register` - Registration
- `/users/log-in` - Login (supports magic link)
- `/users/two-factor` - 2FA verification
- `/users/settings` - Account settings
- `/users/settings/two-factor` - 2FA setup/management

### Portfolio Owner (`/portfolio/*`)
- `/portfolio` - Dashboard
- `/portfolio/ventures` - Manage ventures
- `/portfolio/pitch-decks` - Manage pitch decks

### Admin (`/admin/*`)
- `/admin/dashboard` - Admin dashboard
- `/admin/ventures` - Manage all ventures
- `/admin/pitch-decks` - Manage all pitch decks
- `/admin/launchpad/tools` - Manage SaaS tools
- `/admin/launchpad/categories` - Manage tool categories

---

## User Roles

| Role | Flag | Capabilities |
|------|------|--------------|
| User | (default) | View public content, manage own portfolio |
| Investor | `investor_flag` | Access published pitch decks |
| Admin | `admin_flag` | Full system access |

---

## Development Commands

```bash
# Code quality
mix format                      # Format code
mix precommit                   # Compile (strict), format, test

# Database
mix ecto.migrate                # Run migrations
mix ecto.reset                  # Drop, create, migrate, seed

# Testing
mix test                        # Run all tests
mix test --failed               # Run failed tests
mix test --cover                # Run with coverage

# Deployment
./bin/deploy.sh patch           # 1.7.0 -> 1.7.1
./bin/deploy.sh minor           # 1.7.0 -> 1.8.0
./bin/deploy.sh major           # 1.7.0 -> 2.0.0
```

---

## Environment Variables

### Development

```bash
DATABASE_URL=ecto://postgres:postgres@localhost/jutilis_dev
SECRET_KEY_BASE=<generated>
CLOAK_KEY=<generated>           # Required for 2FA encryption
```

### Production (Fly.io)

```bash
fly secrets set SECRET_KEY_BASE=<value>
fly secrets set DATABASE_URL=<value>
fly secrets set CLOAK_KEY=<value>
fly secrets set SMTP_HOST=<value>
fly secrets set SMTP_USERNAME=<value>
fly secrets set SMTP_PASSWORD=<value>
```

Generate CLOAK_KEY: `mix cloak.gen.key --length 32`

---

## Deployment (Fly.io)

### Initial Setup

```bash
fly auth login
fly launch
fly postgres create
fly postgres attach <postgres-app-name>
```

### Deploy

```bash
./bin/deploy.sh patch           # Recommended: versioned deploy
# or
fly deploy                      # Manual deploy
```

### Monitoring

```bash
fly status                      # Check app status
fly logs                        # View logs
fly ssh console                 # SSH into app
fly ssh console -C "/app/bin/jutilis remote"  # IEx console
```

### Run Seeds in Production

```bash
fly ssh console -C "/app/bin/jutilis remote"
# Then in IEx:
Jutilis.Release.seed()
```

---

## Two-Factor Authentication

The platform supports two 2FA methods:

1. **TOTP (Authenticator App)** - Google Authenticator, Authy, etc.
2. **Email OTP** - 6-digit codes sent via email

Setup: `/users/settings/two-factor`

Backup codes are generated during setup for account recovery.

---

## SaaS Launchpad

Tool recommendations for SaaS builders organized by development phase:

- **Planning Phase:** Legal, banking, domains, workspace setup
- **Building Phase:** Development tools, CI/CD, hosting, databases
- **Maintaining Phase:** Monitoring, analytics, customer support

Admins can manage tools at `/admin/launchpad/tools` with optional affiliate links.

---

## Code Standards

See [AGENTS.md](AGENTS.md) for detailed coding standards, patterns, and AI agent guidance.

**Key Principles:**
- Run `mix precommit` before committing
- Use `Scope` pattern for authorization
- Use LiveView streams for collections
- Never use `else if` - use `cond` instead
- Keep functions small and focused

---

## Contributing

1. Follow the code standards in [AGENTS.md](AGENTS.md)
2. Run `mix precommit` before committing
3. Write tests for new features
4. Update documentation as needed

---

## License

Copyright 2025 Jutilis Technologies. All rights reserved.

## Support

Contact: [jbulloch@jutilistechnologies.com](mailto:jbulloch@jutilistechnologies.com)
