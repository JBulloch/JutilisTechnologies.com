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
alias Jutilis.PitchDecks.PitchDeck

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
          hero_description: "Building multi-tenant SaaS platforms for promising market ventures.",
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

jut_svg = """
<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 100 100" width="100" height="100">
  <!-- Rounded square background -->
  <rect x="5" y="5" width="90" height="90" rx="18" ry="18" fill="#2A9D8F"/>

  <!-- {JuT} text -->
  <text x="50" y="62"
        font-family="system-ui, -apple-system, 'Segoe UI', sans-serif"
        font-size="32"
        font-weight="600"
        fill="white"
        text-anchor="middle">
    {JuT}
  </text>
</svg>
"""

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
    name: "{JuT}",
    slug: "{JuT}",
    tagline: "{JuT} SaaS incubation and launchpad - VC microSaaS marketplace",
    description:
      "Organize and have a branded SaaS portfolio, a.k.a. a {JuT}. \nKeep all of your SaaS, business assets, and tools in one integrated location.",
    url: "https://jutilistechnologies.com",
    status: "active",
    icon_svg: jut_svg,
    color: "emerald",
    badge_color: "primary",
    display_order: 0,
    portfolio_id: portfolio.id
  },
  %{
    name: "Cards Co-op",
    slug: "cards-co-op",
    tagline: "Community Created Card Game Marketplace",
    description:
      "Create, share, and play custom card games in an innovative co-op experience. Connect with collectors, trade cards, and build your collection in a community-driven marketplace.",
    url: "https://cards-co-op.com",
    status: "coming_soon",
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

created_ventures =
  for venture_attrs <- ventures do
    case Repo.get_by(Venture, slug: venture_attrs.slug) do
      nil ->
        {:ok, venture} =
          %Venture{}
          |> Venture.changeset(venture_attrs)
          |> Repo.insert()

        IO.puts("✓ Created venture: #{venture.name}")
        venture

      existing ->
        # Update portfolio_id if missing
        if is_nil(existing.portfolio_id) do
          {:ok, updated} =
            existing
            |> Venture.changeset(%{portfolio_id: portfolio.id})
            |> Repo.update()

          IO.puts("✓ Updated venture #{existing.name} with portfolio_id")
          updated
        else
          IO.puts("⚠ Venture #{venture_attrs.name} already exists")
          existing
        end
    end
  end

# =============================================================================
# Pitch Decks
# =============================================================================

# Load {JuT} pitch deck from file
jut_pitch_deck_path = Path.join([__DIR__, "pitch_decks", "jutilis_technologies_pitch.html"])

jut_pitch_deck_html =
  if File.exists?(jut_pitch_deck_path) do
    File.read!(jut_pitch_deck_path)
  else
    IO.puts("⚠ {JuT} pitch deck file not found at #{jut_pitch_deck_path}")
    nil
  end

# Find the {JuT} venture for linking
jut_venture = Enum.find(created_ventures, fn v -> v.slug == "{JuT}" end)
go_derby_venture = Enum.find(created_ventures, fn v -> v.slug == "go-derby" end)

if jut_pitch_deck_html && jut_venture do
  case Repo.get_by(PitchDeck, title: "{JuT}") do
    nil ->
      {:ok, pitch_deck} =
        %PitchDeck{}
        |> PitchDeck.changeset(%{
          title: "{JuT}",
          description:
            "A SaaS incubation and roadmap tool for aspiring engineers, looking to grow their own companies. All while at the same time presenting any users SaaS portfolio as a VC marketplace.",
          html_content: jut_pitch_deck_html,
          status: "published",
          venture: "other",
          user_id: admin.id
        })
        |> Repo.insert()

      # Update venture with featured pitch deck
      jut_venture
      |> Venture.changeset(%{featured_pitch_deck_id: pitch_deck.id})
      |> Repo.update()

      IO.puts("✓ Created {JuT} pitch deck and linked to venture")

    existing ->
      IO.puts("⚠ {JuT} pitch deck already exists")
  end
end

# =============================================================================
# Launchpad
# =============================================================================

IO.puts("\n--- Seeding Launchpad ---")
Jutilis.Launchpad.seed_defaults!()
IO.puts("✓ Seeded launchpad categories and tools")

IO.puts("\n✅ Seeding complete!")
