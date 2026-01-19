defmodule Jutilis.Repo.Migrations.CreateLaunchpadCategories do
  use Ecto.Migration

  def change do
    create table(:launchpad_categories) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :description, :text
      add :icon, :string
      add :phase, :string, null: false
      add :display_order, :integer, default: 0
      add :is_active, :boolean, default: true

      timestamps(type: :utc_datetime)
    end

    create unique_index(:launchpad_categories, [:slug])
    create index(:launchpad_categories, [:phase])
    create index(:launchpad_categories, [:phase, :display_order])
  end
end
