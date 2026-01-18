defmodule Jutilis.Release do
  @moduledoc """
  Used for executing DB release tasks when run in production without Mix installed.
  """
  @app :jutilis

  def migrate do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :up, all: true))
    end
  end

  def rollback(repo, version) do
    load_app()
    {:ok, _, _} = Ecto.Migrator.with_repo(repo, &Ecto.Migrator.run(&1, :down, to: version))
  end

  def seed do
    load_app()

    for repo <- repos() do
      {:ok, _, _} = Ecto.Migrator.with_repo(repo, fn _repo ->
        seed_admin()
        seed_ventures()
      end)
    end
  end

  defp seed_admin do
    alias Jutilis.Repo
    alias Jutilis.Accounts.User

    admin_email = "jbulloch@jutilistechnologies.com"

    unless Repo.get_by(User, email: admin_email) do
      {:ok, admin} =
        %User{}
        |> User.email_changeset(%{email: admin_email})
        |> User.password_changeset(%{password: "admin123456789"})
        |> Ecto.Changeset.put_change(:admin_flag, true)
        |> Ecto.Changeset.put_change(:confirmed_at, DateTime.utc_now(:second))
        |> Repo.insert()

      IO.puts("Created admin user: #{admin.email}")
      IO.puts("Password: admin123456789")
      IO.puts("IMPORTANT: Change this password after first login!")
    else
      IO.puts("Admin user already exists")
    end
  end

  defp seed_ventures do
    alias Jutilis.Repo
    alias Jutilis.Ventures.Venture

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
        description: "Create, share, and play custom card games in an innovative co-op experience. Connect with collectors, trade cards, and build your collection in a community-driven marketplace.",
        url: "https://cards-co-op.com",
        status: "active",
        icon_svg: cards_coop_svg,
        color: "amber",
        badge_color: "warning",
        display_order: 1
      },
      %{
        name: "GoDerby",
        slug: "go-derby",
        tagline: "Demolition Derby Platform",
        description: "Run your derby like a pro. The complete platform for demolition derby event management. Registration, payments, live timing, and results — all in one place.",
        url: "https://go-derby.com",
        status: "active",
        icon_svg: go_derby_svg,
        color: "emerald",
        badge_color: "success",
        display_order: 2
      }
    ]

    for venture_attrs <- ventures do
      unless Repo.get_by(Venture, slug: venture_attrs.slug) do
        {:ok, venture} =
          %Venture{}
          |> Venture.changeset(venture_attrs)
          |> Repo.insert()

        IO.puts("Created venture: #{venture.name}")
      else
        IO.puts("Venture #{venture_attrs.name} already exists")
      end
    end
  end

  defp repos do
    Application.fetch_env!(@app, :ecto_repos)
  end

  defp load_app do
    Application.load(@app)
  end
end
