defmodule Jutilis.Repo.Migrations.CreateVentures do
  use Ecto.Migration

  def change do
    create table(:ventures) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :tagline, :string
      add :description, :text
      add :url, :string
      add :status, :string, default: "active", null: false
      add :icon_svg, :text
      add :color, :string
      add :badge_color, :string
      add :display_order, :integer, default: 0

      timestamps(type: :utc_datetime)
    end

    create unique_index(:ventures, [:slug])
    create index(:ventures, [:status])
  end
end
