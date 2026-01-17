defmodule Jutilis.Repo.Migrations.CreateVentureLinks do
  use Ecto.Migration

  def change do
    create table(:venture_links) do
      add :name, :string, null: false
      add :url, :string, null: false
      add :category, :string, null: false
      add :description, :text
      add :icon, :string
      add :display_order, :integer, default: 0

      add :venture_id, references(:ventures, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:venture_links, [:venture_id])
    create index(:venture_links, [:venture_id, :category])
  end
end
