# JutilisTechnologies.com - AI Agent Guide

This guide is for AI agents (Claude, Copilot, etc.) working on this codebase. It contains project-specific context, patterns, and guidelines.

## Project Overview

**JutilisTechnologies.com** is a SaaS incubator showcase platform built with Phoenix 1.8 and LiveView 1.1.

- **App name:** `jutilis`
- **Module prefix:** `Jutilis` (domain), `JutilisWeb` (web)
- **Database:** PostgreSQL
- **Hosting:** Fly.io
- **Current Version:** 1.7.0

### Active Ventures

| Venture | Domain | Description |
|---------|--------|-------------|
| Cards Co-op | cards-co-op.com | Community trading card marketplace |
| GoDerby | go-derby.com | Demolition derby coordination platform |

---

## Key Features

### Two-Factor Authentication (2FA)

Fully implemented 2FA system with two methods:

- **TOTP (Authenticator App):** Uses `NimbleTOTP` for code generation/verification
- **Email OTP:** 6-digit codes sent via email, valid for 10 minutes
- **Backup Codes:** 8 single-use recovery codes generated on 2FA setup

**Key files:**
- `lib/jutilis/accounts.ex` - 2FA context functions
- `lib/jutilis/accounts/user_totp.ex` - TOTP schema (encrypted)
- `lib/jutilis/accounts/user_backup_code.ex` - Backup codes schema
- `lib/jutilis/accounts/user_otp_code.ex` - Email OTP schema
- `lib/jutilis_web/live/user_two_factor_live.ex` - 2FA verification during login
- `lib/jutilis_web/live/user_settings_two_factor_live.ex` - 2FA setup/management

**Login flow with 2FA:**
1. User submits credentials
2. If 2FA enabled, redirected to `/users/two-factor` with `pending_2fa_user_id` in session
3. User enters TOTP/Email code or backup code
4. On success, redirected to `/users/two-factor/complete` which creates session token
5. User is fully authenticated

### Field Encryption (Cloak)

Sensitive fields are encrypted at rest using `Cloak` with AES-GCM-256:

- **Encrypted fields:** TOTP secrets, backup codes
- **Vault module:** `lib/jutilis/vault.ex`
- **Custom types:** `lib/jutilis/encrypted.ex`

**Required environment variable:** `CLOAK_KEY` (base64-encoded 32-byte key)

```bash
# Generate key
mix cloak.gen.key --length 32

# Set in Fly.io
fly secrets set CLOAK_KEY="<base64_key>"
```

### SaaS Launchpad Roadmap

Tool recommendation system for SaaS builders organized by development phases:

- **Phases:** Planning, Building, Maintaining
- **Categories:** 17 tool categories (domains, hosting, CI/CD, etc.)
- **Affiliate Links:** Optional affiliate URLs for monetization

**Key files:**
- `lib/jutilis/launchpad.ex` - Launchpad context
- `lib/jutilis/launchpad/category.ex` - Category schema
- `lib/jutilis/launchpad/tool.ex` - Tool schema
- `lib/jutilis/launchpad/templates.ex` - Default seed data
- `lib/jutilis_web/components/launchpad_components.ex` - UI components
- `lib/jutilis_web/live/admin_live/launchpad_*.ex` - Admin management

**Displayed on:** Venture detail pages under "SaaS Launchpad" tab

### Portfolio System

Multi-tenant portfolio support with custom domains:

- Users can have their own portfolio
- Portfolios can have custom slugs (`/p/:slug`)
- Ventures belong to portfolios
- Pitch decks can be associated with ventures

---

## Project Structure

```
lib/
├── jutilis/                      # Domain logic (contexts)
│   ├── accounts/                 # Users, auth, 2FA
│   │   ├── scope.ex              # Authorization scope
│   │   ├── user.ex               # User schema
│   │   ├── user_token.ex         # Session/email tokens
│   │   ├── user_totp.ex          # TOTP 2FA (encrypted)
│   │   ├── user_backup_code.ex   # Backup codes
│   │   └── user_otp_code.ex      # Email OTP codes
│   ├── launchpad/                # SaaS tool roadmap
│   │   ├── category.ex           # Tool categories
│   │   ├── tool.ex               # Individual tools
│   │   └── templates.ex          # Seed data templates
│   ├── pitch_decks/              # Investor pitch decks
│   ├── portfolios/               # User portfolios
│   ├── subscribers/              # Email subscribers
│   ├── ventures/                 # Venture showcase
│   ├── encrypted.ex              # Cloak encrypted types
│   ├── vault.ex                  # Encryption vault
│   └── release.ex                # Production release tasks
│
├── jutilis_web/                  # Web layer
│   ├── components/
│   │   ├── core_components.ex    # Base UI components
│   │   ├── auth_components.ex    # 2FA UI components
│   │   ├── launchpad_components.ex
│   │   └── portfolio_components.ex
│   ├── controllers/
│   │   ├── user_session_controller.ex  # Login, 2FA completion
│   │   └── ...
│   ├── live/
│   │   ├── admin_live/           # Admin dashboard views
│   │   │   ├── dashboard.ex
│   │   │   ├── venture_*.ex
│   │   │   └── launchpad_*.ex
│   │   ├── investor_live/        # Public investor views
│   │   ├── pitch_deck_live/      # Pitch deck management
│   │   ├── portfolio_live/       # Portfolio owner views
│   │   ├── user_two_factor_live.ex       # 2FA verification
│   │   └── user_settings_two_factor_live.ex  # 2FA setup
│   └── router.ex
```

---

## User Roles & Authorization

| Role | Flag | Capabilities |
|------|------|--------------|
| User | (default) | View public content, manage own portfolio |
| Investor | `investor_flag` | Access published pitch decks |
| Admin | `admin_flag` | Full system access, manage all content |

### Scope Pattern

All context functions receive a `Scope` struct as the first argument:

```elixir
# Admin-only operation
def create_tool(%Scope{user: %{admin_flag: true}}, attrs) do
  # ...
end

# Any authenticated user
def list_user_ventures(%Scope{user: user}) do
  Venture |> where(user_id: ^user.id) |> Repo.all()
end
```

---

## Routes Overview

### Public Routes
- `/` - Portfolio home (resolved by domain or flagship)
- `/p/:slug` - Portfolio by slug
- `/investors/pitch-decks` - Public pitch deck listing

### Authentication Routes
- `/users/register` - Registration
- `/users/log-in` - Login (supports magic link)
- `/users/two-factor` - 2FA verification
- `/users/settings` - Account settings
- `/users/settings/two-factor` - 2FA setup

### Portfolio Owner Routes (`/portfolio/*`)
- `/portfolio` - Dashboard
- `/portfolio/ventures` - Manage ventures
- `/portfolio/pitch-decks` - Manage pitch decks

### Admin Routes (`/admin/*`)
- `/admin/dashboard` - Admin dashboard
- `/admin/ventures` - Manage all ventures
- `/admin/pitch-decks` - Manage all pitch decks
- `/admin/launchpad/tools` - Manage launchpad tools
- `/admin/launchpad/categories` - Manage tool categories

---

## Development Commands

```bash
# Setup
mix setup                    # Full project setup

# Development
mix phx.server               # Start server
iex -S mix phx.server        # Start with IEx
./bin/repo-menu.sh           # Interactive menu

# Code quality
mix format                   # Format code
mix precommit                # Compile (strict), format, test

# Database
mix ecto.migrate             # Run migrations
mix ecto.reset               # Drop, create, migrate, seed

# Testing
mix test                     # Run all tests
mix test --failed            # Run failed tests
mix test path/to/test.exs    # Run specific file

# Deployment
./bin/deploy.sh patch        # Deploy with patch bump (1.7.0 -> 1.7.1)
./bin/deploy.sh minor        # Deploy with minor bump (1.7.0 -> 1.8.0)
```

---

## Code Standards

### General Rules

- **Always** run `mix precommit` before committing
- **Always** use `Scope` pattern for authorization
- **Never** nest multiple modules in the same file
- **Never** use `String.to_atom/1` on user input

### LiveView Patterns

- **Always** use streams for collections (not lists)
- **Always** use `to_form/2` for forms, never raw changesets
- **Always** add unique DOM IDs to forms and key elements
- **Always** use `<.input>` component from `core_components.ex`
- **Never** use `else if` - use `cond` instead

### Component Organization

Keep components focused and reusable:
- `core_components.ex` - Base UI (buttons, inputs, modals)
- `auth_components.ex` - Authentication UI (2FA forms, code inputs)
- `launchpad_components.ex` - Launchpad roadmap UI
- `portfolio_components.ex` - Portfolio showcase UI

### DateTime Handling

Ecto's `:utc_datetime` requires second precision:

```elixir
# Correct
DateTime.utc_now() |> DateTime.truncate(:second)
DateTime.utc_now(:second)

# Wrong - will raise error
DateTime.utc_now()  # has microseconds
```

---

## Phoenix 1.8 Guidelines

- **Always** wrap LiveView templates with `<Layouts.app flash={@flash} ...>`
- **Always** pass `current_scope` to layouts when needed
- **Always** use `@current_scope.user` to access current user (not `@current_user`)
- **Never** call `<.flash_group>` outside of `layouts.ex`

### Router Live Sessions

```elixir
# Public routes with optional auth
live_session :public, on_mount: [{JutilisWeb.UserAuth, :mount_current_scope}]

# Authenticated routes
live_session :authenticated, on_mount: [{JutilisWeb.UserAuth, :ensure_authenticated}]

# Admin routes
live_session :admin, on_mount: [{JutilisWeb.UserAuth, :ensure_admin}]
```

---

## Form Handling

```elixir
# In LiveView mount
def mount(_params, _session, socket) do
  changeset = Context.change_schema(%Schema{})
  {:ok, assign(socket, form: to_form(changeset))}
end

# Validation
def handle_event("validate", %{"schema" => params}, socket) do
  changeset =
    %Schema{}
    |> Schema.changeset(params)
    |> Map.put(:action, :validate)
  {:noreply, assign(socket, form: to_form(changeset))}
end

# Save
def handle_event("save", %{"schema" => params}, socket) do
  case Context.create(socket.assigns.current_scope, params) do
    {:ok, record} -> {:noreply, push_navigate(socket, to: ~p"/path")}
    {:error, changeset} -> {:noreply, assign(socket, form: to_form(changeset))}
  end
end
```

---

## HEEx Syntax Quick Reference

```heex
<%!-- Attribute interpolation --%>
<div id={@id} class={["base", @active && "active"]}>

<%!-- Body interpolation --%>
{@user.name}

<%!-- Block constructs --%>
<%= if @show do %>
  <span>Visible</span>
<% end %>

<%!-- Multiple conditions (NEVER use else if) --%>
<%= cond do %>
  <% @status == :published -> %>
    <span>Published</span>
  <% true -> %>
    <span>Unknown</span>
<% end %>

<%!-- Streams --%>
<div id="items" phx-update="stream">
  <div :for={{id, item} <- @streams.items} id={id}>
    {item.name}
  </div>
</div>
```

---

## Testing Patterns

```elixir
# Context test
describe "create_venture/2" do
  test "creates venture for admin" do
    user = user_fixture(%{admin_flag: true})
    scope = %Scope{user: user}

    assert {:ok, venture} = Ventures.create_venture(scope, valid_attrs())
  end
end

# LiveView test
describe "VentureIndex" do
  test "lists ventures", %{conn: conn} do
    admin = user_fixture(%{admin_flag: true})
    venture = venture_fixture()

    {:ok, view, _html} =
      conn
      |> log_in_user(admin)
      |> live(~p"/admin/ventures")

    assert has_element?(view, "#venture-#{venture.id}")
  end
end
```

---

## Environment Variables

### Development
Set in `.env` or export directly:
```bash
DATABASE_URL=ecto://postgres:postgres@localhost/jutilis_dev
SECRET_KEY_BASE=<generated>
CLOAK_KEY=<generated>
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

---

## Production Deployment

### Release Tasks

Located in `lib/jutilis/release.ex`:

```elixir
# Run migrations
Jutilis.Release.migrate()

# Seed data (admin, ventures, launchpad)
Jutilis.Release.seed()
```

### Fly.io Commands

```bash
fly status                   # Check app status
fly logs                     # View logs
fly ssh console              # SSH into app
fly ssh console -C "/app/bin/jutilis remote"  # IEx console
fly secrets list             # List secrets
fly secrets set KEY=value    # Set secret
```

---

## Common Issues & Solutions

### "No CLOAK_KEY" in production
Set the encryption key: `fly secrets set CLOAK_KEY="<base64_key>"`

### LiveView reconnection loops
Usually caused by crash in mount. Check:
1. Database queries returning nil
2. Missing required data (run seeds)
3. DateTime precision issues

### Duplicate emails on 2FA
Fixed by checking `connected?(socket)` before sending and tracking `email_sent` assign.

### DateTime microseconds error
Use `DateTime.truncate(:second)` or `DateTime.utc_now(:second)` for Ecto `:utc_datetime` fields.
