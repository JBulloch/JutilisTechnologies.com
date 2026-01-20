# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Jutilis.Repo.insert!(%Jutilis.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Jutilis.Repo
alias Jutilis.Accounts.User
alias Jutilis.Portfolios.Portfolio
alias Jutilis.Ventures.Venture

# =============================================================================
# Admin User
# =============================================================================

admin_email = "jbulloch@jutilistechnologies.com"

admin =
  case Repo.get_by(User, email: admin_email) do
    nil ->
      {:ok, user} =
        %User{}
        |> User.email_changeset(%{email: admin_email})
        |> User.password_changeset(%{password: "admin123456789"})
        |> Ecto.Changeset.put_change(:admin_flag, true)
        |> Ecto.Changeset.put_change(:confirmed_at, DateTime.utc_now(:second))
        |> Repo.insert()

      IO.puts("✓ Created admin user:")
      IO.puts("  Email: #{user.email}")
      IO.puts("  Password: admin123456789")
      IO.puts("  IMPORTANT: Change this password after first login!")
      user

    existing ->
      IO.puts("⚠ Admin user already exists")
      existing
  end

# =============================================================================
# Flagship Portfolio
# =============================================================================

portfolio =
  case Repo.get_by(Portfolio, slug: "jutilis") do
    nil ->
      {:ok, p} =
        %Portfolio{}
        |> Portfolio.changeset(%{
          name: "Jutilis Technologies",
          slug: "jutilis",
          tagline: "SaaS Incubator",
          logo_text: "{JuT}",
          status: "published",
          is_flagship: true,
          user_id: admin.id,
          primary_color: "emerald",
          secondary_color: "amber",
          hero_title: "Jutilis",
          hero_subtitle: "Technologies",
          hero_description:
            "Building multi-tenant SaaS platforms for promising market ventures.",
          hero_badge_text: "SaaS Incubator",
          section_config: %{
            "about" => true,
            "acquired" => true,
            "active_ventures" => true,
            "coming_soon" => true,
            "consulting" => true,
            "hero" => true,
            "investment_cta" => true
          },
          about_title: "Building the Future of SaaS",
          about_description:
            "Jutilis Technologies is a SaaS incubator specializing in multi-tenant platforms for promising market ventures. We identify underserved markets and build scalable platforms that serve thriving communities.",
          investment_enabled: true,
          investment_title: "Partner With Us",
          investment_description:
            "Access exclusive pitch decks and investment opportunities. Join us in building the future of multi-tenant SaaS platforms.",
          consulting_enabled: true,
          consulting_email: "consulting@jutilistechnologies.com",
          consulting_title: "Expert Technical Consulting",
          consulting_description:
            "Leverage our expertise in building scalable SaaS platforms for your own projects. We offer consulting services to help fund and grow Jutilis Technologies ventures.",
          meta_title: "Jutilis Technologies - SaaS Incubator",
          meta_description:
            "Building multi-tenant SaaS platforms for promising market ventures. A SaaS incubator specializing in scalable platforms.",
          theme_color: "#10B981"
        })
        |> Repo.insert()

      IO.puts("✓ Created flagship portfolio: #{p.name}")
      p

    existing ->
      IO.puts("⚠ Portfolio already exists")
      existing
  end

# =============================================================================
# Ventures
# =============================================================================

cards_coop_svg = """
<svg viewBox="0 0 24 24" fill="currentColor">
  <path d="M3 8c0-1.1.9-2 2-2h2.5L9 4H7C4.8 4 3 5.8 3 8v8c0 2.2 1.8 4 4 4h10c2.2 0 4-1.8 4-4v-2.5l-2 1.5V16c0 1.1-.9 2-2 2H7c-1.1 0-2-.9-2-2V8zm18-2.5L15 10l6 4.5V5.5z"></path>
</svg>
"""

go_derby_svg = """
<svg viewBox="0 0 24 24" fill="none" stroke="currentColor">
  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2.5" d="M13 10V3L4 14h7v7l9-11h-7z"></path>
</svg>
"""

ventures = [
  %{
    name: "Cards Co-op",
    slug: "cards-co-op",
    tagline: "Community Trading Card Marketplace",
    description:
      "Create, share, and play custom card games in an innovative co-op experience. Connect with collectors, trade cards, and build your collection in a community-driven marketplace.",
    url: "https://cards-co-op.com",
    status: "active",
    icon_svg: cards_coop_svg,
    color: "amber",
    badge_color: "warning",
    display_order: 1,
    portfolio_id: portfolio.id
  },
  %{
    name: "GoDerby",
    slug: "go-derby",
    tagline: "Demolition Derby Platform",
    description:
      "Run your derby like a pro. The complete platform for demolition derby event management. Registration, payments, live timing, and results — all in one place.",
    url: "https://go-derby.com",
    status: "active",
    icon_svg: go_derby_svg,
    color: "emerald",
    badge_color: "success",
    display_order: 2,
    portfolio_id: portfolio.id
  }
]

for venture_attrs <- ventures do
  case Repo.get_by(Venture, slug: venture_attrs.slug) do
    nil ->
      {:ok, venture} =
        %Venture{}
        |> Venture.changeset(venture_attrs)
        |> Repo.insert()

      IO.puts("✓ Created venture: #{venture.name}")

    existing ->
      # Update portfolio_id if missing
      if is_nil(existing.portfolio_id) do
        existing
        |> Venture.changeset(%{portfolio_id: portfolio.id})
        |> Repo.update()

        IO.puts("✓ Updated venture #{existing.name} with portfolio_id")
      else
        IO.puts("⚠ Venture #{venture_attrs.name} already exists")
      end
  end
end

# =============================================================================
# Launchpad
# =============================================================================

IO.puts("\n--- Seeding Launchpad ---")
Jutilis.Launchpad.seed_defaults!()
IO.puts("✓ Seeded launchpad categories and tools")
