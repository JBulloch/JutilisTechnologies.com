defmodule Jutilis.Repo.Migrations.CreateLaunchpadTools do
  use Ecto.Migration

  def change do
    create table(:launchpad_tools) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :description, :text
      add :factoid, :text
      add :url, :string, null: false
      add :affiliate_url, :string
      add :logo_url, :string
      add :icon, :string
      add :pricing_info, :string
      add :display_order, :integer, default: 0
      add :is_featured, :boolean, default: false
      add :is_active, :boolean, default: true

      add :category_id, references(:launchpad_categories, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create unique_index(:launchpad_tools, [:slug])
    create index(:launchpad_tools, [:category_id])
    create index(:launchpad_tools, [:category_id, :display_order])
  end
end
