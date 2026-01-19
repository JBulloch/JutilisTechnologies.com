defmodule Jutilis.Repo.Migrations.MigrateVentureLinkCategories do
  use Ecto.Migration

  def change do
    # Map old categories to new launchpad-aligned categories
    # development -> code-repos
    # business -> legal
    # mdm -> other (no direct equivalent)
    execute(
      "UPDATE venture_links SET category = 'code-repos' WHERE category = 'development'",
      "UPDATE venture_links SET category = 'development' WHERE category = 'code-repos'"
    )

    execute(
      "UPDATE venture_links SET category = 'legal' WHERE category = 'business'",
      "UPDATE venture_links SET category = 'business' WHERE category = 'legal'"
    )

    execute(
      "UPDATE venture_links SET category = 'other' WHERE category = 'mdm'",
      "UPDATE venture_links SET category = 'mdm' WHERE category = 'other'"
    )
  end
end
