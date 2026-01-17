# JutilisTechnologies.com

A Phoenix LiveView showcase website for Jutilis Technologies, a SaaS incubator specializing in multi-tenant platforms for promising market ventures. Features pitch deck management and investor engagement tools. Built with Phoenix 1.8, LiveView 1.1, and PostgreSQL. Deployed on Fly.io.

## Ventures

### Cards Co-op
A cooperative platform for trading card enthusiasts. Connect with collectors, trade cards, and build your collection in a community-driven marketplace.
- **Website:** [cards-co-op.com](https://cards-co-op.com)
- **Status:** Active
- **Focus:** Community-Driven Trading Card Marketplace

### Go Derby
A comprehensive platform for roller derby leagues and fans. From event discovery to driver rankings, GoDerby handles the entire derby experience.
- **Website:** [go-derby.com](https://go-derby.com)
- **Status:** Active
- **Focus:** Demolition Derby Coordination Platform
- **Features:** Event discovery, driver rankings, pit passes & tickets, heat management, car registration, live event tracking, QR code validation

## Project Overview

- **App name:** `jutilis`
- **Module prefix:** `Jutilis` (domain), `JutilisWeb` (web)
- **Database:** PostgreSQL
- **Framework:** Phoenix 1.8 with LiveView 1.1
- **Hosting:** Fly.io
- **Authentication:** Phoenix generated auth with bcrypt

## Key Features

- **Venture Showcase:** Professional landing page highlighting active ventures
- **Pitch Deck Management:** Admin dashboard for managing investor pitch decks
- **Investor Portal:** Secure access for approved investors to view pitch decks
- **Admin Authentication:** Role-based access control (admin/investor flags)
- **Mobile-Responsive Design:** Tailwind CSS with mobile-first approach
- **Real-time Updates:** LiveView for dynamic content

## Tech Stack

- **Backend:** Elixir 1.16, Phoenix 1.8
- **Frontend:** Phoenix LiveView 1.1, Tailwind CSS, DaisyUI
- **Database:** PostgreSQL 15
- **Version Management:** asdf
- **Deployment:** Fly.io

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

# Interactive menu (includes server, tests, deploy, etc.)
./bin/repo-menu.sh
```

Visit [http://localhost:4000](http://localhost:4000)

### Admin Login

```
Email: Jbulloch@jutilitstechnologies.com
Password: admin123456789
```

**⚠️ Change password immediately at:** [/users/settings](/users/settings)

## Project Structure

```
lib/
├── jutilis/                    # Domain logic (contexts)
│   ├── accounts/               # User authentication & management
│   ├── pitch_decks/            # Pitch deck CRUD operations
│   └── investors/              # Investor management (future)
├── jutilis_web/                # Web layer
│   ├── components/             # Reusable LiveView components
│   ├── controllers/            # HTTP controllers (auth, pages)
│   ├── live/                   # LiveView modules
│   │   └── pitch_deck_live/    # Admin pitch deck management
│   └── router.ex

test/
├── jutilis/                    # Context tests
├── jutilis_web/                # Web layer tests
└── support/
    ├── fixtures/               # Test data factories
    ├── conn_case.ex            # Controller test setup
    └── data_case.ex            # Database test setup

priv/
├── repo/
│   ├── migrations/             # Database migrations
│   └── seeds.exs               # Seed data (admin user)
└── static/                     # Static assets

assets/                         # Frontend assets
├── css/                        # Tailwind styles
├── js/                         # JavaScript
└── vendor/                     # Third-party assets

bin/                            # Executable scripts
├── setup.sh                    # Automated project setup
├── repo-menu.sh                # Interactive development menu
└── deploy.sh                   # Versioned deployment script
```

## Development Commands

```bash
# Database
mix ecto.create                 # Create database
mix ecto.migrate                # Run migrations
mix ecto.reset                  # Drop, create, migrate, seed
mix ecto.rollback               # Rollback last migration
mix run priv/repo/seeds.exs     # Run seeds

# Code Quality
mix format                      # Format code
mix compile --warnings-as-errors # Strict compilation
mix precommit                   # Run all checks (format, compile, test)

# Testing
mix test                        # Run all tests
mix test --failed               # Run previously failed tests
mix test test/path_test.exs     # Run specific file
mix test --cover                # Run with coverage

# Assets
mix assets.setup                # Install Tailwind & esbuild
mix assets.build                # Build assets for development
mix assets.deploy               # Build & minify for production

# Server
mix phx.server                  # Start server
iex -S mix phx.server           # Start with IEx shell

# Deployment
./bin/deploy.sh patch           # Deploy with patch version bump (1.0.0 -> 1.0.1)
./bin/deploy.sh minor           # Deploy with minor version bump (1.0.0 -> 1.1.0)
./bin/deploy.sh major           # Deploy with major version bump (1.0.0 -> 2.0.0)
```

## Routes

### Public Routes
- `/` - Home page with venture showcase
- `/users/register` - User registration
- `/users/log-in` - User login

### Authenticated Routes
- `/users/settings` - User account settings

### Admin Routes
- `/admin/pitch-decks` - Manage pitch decks
- `/admin/pitch-decks/new` - Create new pitch deck
- `/admin/pitch-decks/:id` - View pitch deck details
- `/admin/pitch-decks/:id/edit` - Edit pitch deck

### Investor Routes (Future)
- `/investors/signup` - Investor registration
- `/investors/pitch-decks` - View published pitch decks

## Deployment (Fly.io)

### Initial Setup

```bash
# Install flyctl
curl -L https://fly.io/install.sh | sh

# Login
fly auth login

# Launch app (creates fly.toml)
fly launch

# Create and attach PostgreSQL
fly postgres create
fly postgres attach <postgres-app-name>
```

### Environment Variables

```bash
# Set secrets
fly secrets set SECRET_KEY_BASE=$(mix phx.gen.secret)
fly secrets set DATABASE_URL=<your-database-url>
```

### Deploy

```bash
# Using deployment script (recommended)
./bin/deploy.sh patch           # Bumps version and deploys

# Or manually
fly deploy                      # Deploy current code
```

### Monitoring

```bash
fly status                      # Check app status
fly logs                        # View logs
fly logs -a <app-name>          # View logs for specific app
fly ssh console                 # SSH into running app
fly postgres connect -a <db>    # Connect to database
```

## Code Standards

See [agents.md](agents.md) for detailed coding standards and patterns.

**Key Principles:**
- Always run `mix format` before committing
- Always run `mix precommit` when done with changes
- Follow Phoenix and Elixir conventions
- Use `Scope` pattern for authorization
- Use LiveView streams for collections
- Never use `else if` - use `cond` instead
- Keep functions small and focused

## User Roles

| Role | Flag | Capabilities |
|------|------|--------------|
| User | (default) | View public ventures |
| Investor | `investor_flag` | Access published pitch decks |
| Admin | `admin_flag` | Full pitch deck management, user management |

## Pitch Deck Statuses

| Status | Description | Visibility |
|--------|-------------|------------|
| `draft` | Work in progress | Admin only |
| `published` | Ready for investors | Admin + Investors |
| `archived` | No longer active | Admin only |

## Contributing

1. Follow the code standards in [agents.md](agents.md)
2. Run `mix precommit` before committing
3. Write tests for new features
4. Update documentation as needed

## License

Copyright © 2025 Jutilis Technologies. All rights reserved.

## Support

For questions or issues, contact [Jbulloch@jutilitstechnologies.com](mailto:Jbulloch@jutilitstechnologies.com)
