# JutilisTechnologies.com Development Guide

JutilisTechnologies.com is a showcase website for Jutilis ventures (cards-co-op.com, go-derby.com) with pitch deck sharing functionality for investors. Built with Phoenix 1.8, LiveView, and PostgreSQL.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Code Standards](#code-standards)
3. [Project Structure](#project-structure)
4. [Domain Concepts](#domain-concepts)
5. [Authentication & Authorization](#authentication--authorization)
6. [LiveView Patterns](#liveview-patterns)
7. [Testing](#testing)
8. [Development Commands](#development-commands)

---

## Project Overview

- **App name:** `jutilis`
- **Module prefix:** `Jutilis` (domain), `JutilisWeb` (web)
- **Database:** PostgreSQL
- **Framework:** Phoenix 1.8 with LiveView 1.1
- **Hosting:** Fly.io

### Key Features

- Venture showcase (cards-co-op.com, go-derby.com)
- Pitch deck library with secure sharing
- Investor signup and access management
- Email notifications for investor interest
- Responsive modern design

---

## Code Standards

**All code must be clean, readable, and follow established patterns.** This ensures humans can easily maintain and extend the codebase.

### Formatting & Style

- **Always** run `mix format` before committing
- **Always** run `mix precommit` when done with changes (runs compile with warnings as errors, format, and tests)
- Follow standard Elixir conventions and Credo defaults
- Use the existing `.formatter.exs` configuration

### Module Organization

```elixir
defmodule Jutilis.SomeContext do
  @moduledoc """
  Brief description of the context's purpose.
  """

  # 1. Module attributes and aliases
  import Ecto.Query, warn: false
  alias Jutilis.Repo
  alias Jutilis.SomeContext.Schema

  # 2. Public functions (grouped by entity)

  # 3. Private functions at the bottom
end
```

### Function Guidelines

- **Keep functions small and focused** - one function, one responsibility
- **Use descriptive names** - `list_investor_pitch_decks` not `get_decks`
- **Document public functions** with `@doc` when behavior isn't obvious
- **Pattern match in function heads** rather than conditionals when possible
- **Predicate functions** end with `?` (e.g., `investor_has_access?/1`)

### Naming Conventions

| Type | Convention | Example |
|------|------------|---------|
| Context modules | Plural noun | `Jutilis.PitchDecks` |
| Schema modules | Singular noun | `Jutilis.PitchDecks.PitchDeck` |
| LiveView modules | `*Live` suffix | `JutilisWeb.PitchDeckLive.Index` |
| Controller modules | `*Controller` suffix | `JutilisWeb.InvestorController` |

### Code Quality Rules

- **Never** nest multiple modules in the same file
- **Never** use `String.to_atom/1` on user input (memory leak risk)
- **Always** preload associations in queries when accessed in templates
- **Always** use `Ecto.Changeset.get_field/2` to access changeset fields
- **Never** use map access syntax on structs (e.g., `changeset[:field]`)
- **Always** set programmatic fields (like `user_id`) explicitly, not in `cast`

---

## Project Structure

```
lib/
├── jutilis/                    # Domain logic (contexts)
│   ├── accounts/               # User management, auth
│   ├── ventures/               # Venture showcase data
│   ├── pitch_decks/            # Pitch deck management
│   ├── investors/              # Investor signups and access
│   └── ...
├── jutilis_web/                # Web layer
│   ├── components/             # Reusable UI components
│   ├── controllers/            # HTTP controllers
│   ├── live/                   # LiveView modules
│   │   ├── venture_live/       # Venture showcase views
│   │   ├── pitch_deck_live/    # Pitch deck views
│   │   ├── investor_live/      # Investor management views
│   │   └── ...
│   └── router.ex

test/
├── jutilis/                    # Context tests
├── jutilis_web/                # Web layer tests
└── support/
    ├── fixtures/               # Test data factories
    ├── conn_case.ex            # Controller test setup
    └── data_case.ex            # Database test setup
```

---

## Domain Concepts

### User Roles

| Role | Flag | Capabilities |
|------|------|--------------|
| Guest | (none) | View ventures showcase |
| Investor | `investor_flag` | Access shared pitch decks, receive updates |
| Admin | `admin_flag` | Manage pitch decks, ventures, investor access |

### Pitch Deck Visibility

```
Draft → Published → Shared with Investors
        ↑
    (can be made private again)
```

### Investor Access Flow

```
1. Investor signs up with email and info
2. Admin reviews and approves
3. Investor receives access link via email
4. Investor can view approved pitch decks
5. Track viewing analytics
```

### Pitch Deck Statuses

| Status | Description |
|--------|-------------|
| `draft` | Work in progress, not visible |
| `published` | Available to approved investors |
| `archived` | No longer active |

---

## Authentication & Authorization

### Router Organization

**Public routes with optional auth** - use `live_session :current_user`:

```elixir
scope "/", JutilisWeb do
  pipe_through [:browser]

  live_session :current_user,
    on_mount: [{JutilisWeb.UserAuth, :mount_current_user}] do
    live "/", HomeLive, :index
    live "/ventures", VentureLive.Index, :index
    live "/ventures/:id", VentureLive.Show, :show
  end
end
```

**Investor routes** - use `live_session :require_investor`:

```elixir
scope "/investors", JutilisWeb do
  pipe_through [:browser, :require_authenticated_user]

  live_session :require_investor,
    on_mount: [{JutilisWeb.UserAuth, :require_investor}] do
    live "/pitch-decks", PitchDeckLive.Index, :index
    live "/pitch-decks/:id", PitchDeckLive.Show, :show
  end
end
```

**Admin routes** - use `live_session :require_admin_user`:

```elixir
scope "/admin", JutilisWeb do
  pipe_through [:browser, :require_authenticated_user, :require_admin]

  live_session :require_admin_user,
    on_mount: [{JutilisWeb.UserAuth, :require_admin}] do
    live "/pitch-decks", Admin.PitchDeckLive.Index, :index
    live "/investors", Admin.InvestorLive.Index, :index
  end
end
```

### Access Control in Contexts

```elixir
# Admin-only operations
def create_pitch_deck(%User{admin_flag: true} = user, attrs) do
  # ...
end

# Investor access check
def list_pitch_decks_for_investor(%User{investor_flag: true} = user) do
  from(p in PitchDeck,
    where: p.status == :published,
    order_by: [desc: p.inserted_at]
  )
  |> Repo.all()
end

def investor_can_access_pitch_deck?(%User{} = user, %PitchDeck{} = deck) do
  user.investor_flag and deck.status == :published
end
```

---

## LiveView Patterns

### Template Rules

- **Always** wrap content with `<.layout>` component
- **Always** use `@current_user` to access the current user
- **Always** use `<.form for={@form}>` with `to_form/2`, never raw changesets
- **Always** add unique DOM IDs to forms and key elements
- **Always** use `<.input>` component from `core_components.ex`
- **Always** use `<.icon name="hero-*">` for icons

### Streams for Collections

**Always** use streams for lists to prevent memory issues:

```elixir
# In mount/handle_event
socket
|> stream(:pitch_decks, pitch_decks)
|> stream(:pitch_decks, new_items, at: 0)  # prepend
|> stream(:pitch_decks, filtered, reset: true)  # filter/refresh

# In template
<div id="pitch-decks" phx-update="stream">
  <div :for={{id, deck} <- @streams.pitch_decks} id={id}>
    {deck.title}
  </div>
</div>
```

### Form Handling

```elixir
# In LiveView
def mount(_params, _session, socket) do
  changeset = PitchDecks.change_pitch_deck(%PitchDeck{})
  {:ok, assign(socket, form: to_form(changeset))}
end

def handle_event("validate", %{"pitch_deck" => params}, socket) do
  changeset =
    %PitchDeck{}
    |> PitchDeck.changeset(params)
    |> Map.put(:action, :validate)

  {:noreply, assign(socket, form: to_form(changeset))}
end

def handle_event("save", %{"pitch_deck" => params}, socket) do
  case PitchDecks.create_pitch_deck(socket.assigns.current_user, params) do
    {:ok, deck} ->
      {:noreply, push_navigate(socket, to: ~p"/admin/pitch-decks/#{deck}")}
    {:error, changeset} ->
      {:noreply, assign(socket, form: to_form(changeset))}
  end
end
```

### HEEx Syntax

```heex
<%!-- Attribute interpolation uses {} --%>
<div id={@id} class={["base", @active && "active"]}>

<%!-- Body interpolation uses {} for values --%>
{@user.name}

<%!-- Block constructs use <%= %> --%>
<%= if @show do %>
  <span>Visible</span>
<% end %>

<%!-- Multiple conditions use cond, never else if --%>
<%= cond do %>
  <% @status == :published -> %>
    <span class="text-green-500">Published</span>
  <% @status == :draft -> %>
    <span class="text-yellow-500">Draft</span>
  <% true -> %>
    <span>Unknown</span>
<% end %>

<%!-- Class lists with conditions --%>
<div class={[
  "px-4 py-2",
  @selected && "bg-blue-500",
  if(@disabled, do: "opacity-50", else: "hover:bg-gray-100")
]}>
```

---

## Testing

### Test Setup

```elixir
# Use DataCase for context tests
use Jutilis.DataCase, async: true

# Use ConnCase for controller/LiveView tests
use JutilisWeb.ConnCase, async: true
```

### Fixtures

```elixir
# Import fixtures in tests
import Jutilis.AccountsFixtures
import Jutilis.PitchDecksFixtures

# Create test data
user = user_fixture(%{admin_flag: true})
pitch_deck = pitch_deck_fixture(user)
investor = investor_fixture()
```

### Test Patterns

```elixir
# Context test
describe "create_pitch_deck/2" do
  test "creates pitch deck with valid data" do
    user = user_fixture(%{admin_flag: true})
    attrs = %{title: "Series A Deck", description: "...", file_url: "..."}

    assert {:ok, %PitchDeck{} = deck} = PitchDecks.create_pitch_deck(user, attrs)
    assert deck.title == "Series A Deck"
    assert deck.user_id == user.id
  end
end

# LiveView test
describe "PitchDeckLive.Index" do
  test "lists pitch decks for investors", %{conn: conn} do
    investor = investor_fixture()
    deck = pitch_deck_fixture(%{status: :published})

    {:ok, view, _html} =
      conn
      |> log_in_user(investor)
      |> live(~p"/investors/pitch-decks")

    assert has_element?(view, "#pitch-deck-#{deck.id}")
  end
end
```

### Running Tests

```bash
# Run all tests
mix test

# Run specific file
mix test test/jutilis/pitch_decks_test.exs

# Run previously failed tests
mix test --failed

# Run with coverage
mix test --cover
```

---

## Development Commands

### Common Tasks

```bash
# Setup project
mix setup

# Start server
mix phx.server

# or with iex
iex -S mix phx.server

# Pre-commit check (run before committing)
mix precommit

# Database operations
mix ecto.migrate
mix ecto.rollback
mix ecto.reset

# Generate migration
mix ecto.gen.migration add_field_to_table
```

### Asset Building

```bash
mix assets.build      # Development build
mix assets.deploy     # Production build (minified)
```

### Useful Aliases

Defined in `mix.exs`:
- `mix setup` - Full project setup
- `mix precommit` - Compile (warnings as errors), format, test
- `mix ecto.reset` - Drop, create, migrate, seed

---

## Additional Guidelines

### HTTP Requests

**Always** use the `Req` library for HTTP requests:

```elixir
Req.get!("https://api.example.com/data")
Req.post!("https://api.example.com/data", json: %{key: "value"})
```

**Never** use `:httpoison`, `:tesla`, or `:httpc`.

### Date/Time

Use Elixir's built-in modules:

```elixir
Date.utc_today()
DateTime.utc_now()
DateTime.diff(dt1, dt2, :second)
```

**Never** add dependencies for basic date/time operations.

### Elixir Gotchas

```elixir
# Lists don't support index access - use Enum.at
Enum.at(list, 0)  # correct
list[0]           # WRONG - won't work

# Block expressions must bind results
socket =
  if connected?(socket) do
    assign(socket, :live, true)
  else
    socket
  end

# Never use else if - use cond
cond do
  condition1 -> result1
  condition2 -> result2
  true -> default
end
```

### Security

- Validate user input at system boundaries
- Use parameterized queries (Ecto handles this)
- Never expose internal IDs in URLs (use UUIDs or slugs)
- Check authorization in context functions, not just routes
- Sanitize file uploads (pitch deck PDFs)
- Rate limit investor signup forms

### File Uploads

For pitch deck PDFs:
- Store in S3 or similar object storage
- Generate signed URLs with expiration
- Validate file type and size
- Scan for malware if possible

---

## Deployment (Fly.io)

### Initial Setup

```bash
# Install flyctl
curl -L https://fly.io/install.sh | sh

# Login
fly auth login

# Create app
fly launch

# Create Postgres database
fly postgres create
fly postgres attach <postgres-app-name>
```

### Deploy

```bash
# Deploy with version bump
./bin/deploy.sh patch   # 1.0.0 -> 1.0.1
./bin/deploy.sh minor   # 1.0.0 -> 1.1.0
./bin/deploy.sh major   # 1.0.0 -> 2.0.0
```

### Monitoring

```bash
# Check status
fly status

# View logs
fly logs

# SSH into app
fly ssh console

# Connect to database
fly postgres connect -a jutilis-db
```

---

## Environment Variables

### Development (.env)

```bash
DATABASE_URL=ecto://postgres:postgres@localhost/jutilis_dev
SECRET_KEY_BASE=your_secret_key_base
PHX_HOST=localhost
PORT=4000
```

### Production (Fly.io secrets)

```bash
fly secrets set SECRET_KEY_BASE=your_production_secret
fly secrets set DATABASE_URL=ecto://...
fly secrets set SMTP_HOST=smtp.sendgrid.net
fly secrets set SMTP_USERNAME=apikey
fly secrets set SMTP_PASSWORD=your_sendgrid_api_key
```

---

## Design Guidelines

### Tailwind CSS

- Use Tailwind utility classes for styling
- Follow mobile-first responsive design
- Use the project's color palette:
  - Primary: Blue (`bg-blue-600`, `text-blue-600`)
  - Success: Green (`bg-green-500`)
  - Warning: Yellow (`bg-yellow-500`)
  - Danger: Red (`bg-red-500`)

### Component Structure

```heex
<div class="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8">
  <div class="py-8">
    <%!-- Content --%>
  </div>
</div>
```

### Responsive Breakpoints

- `sm:` - 640px and up
- `md:` - 768px and up
- `lg:` - 1024px and up
- `xl:` - 1280px and up
- `2xl:` - 1536px and up
