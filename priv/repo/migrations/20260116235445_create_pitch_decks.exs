defmodule Jutilis.Repo.Migrations.CreatePitchDecks do
  use Ecto.Migration

  def change do
    create table(:pitch_decks) do
      add :title, :string, null: false
      add :description, :text
      add :file_url, :string
      add :status, :string, null: false, default: "draft"
      add :venture, :string
      add :user_id, references(:users, on_delete: :restrict), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:pitch_decks, [:user_id])
    create index(:pitch_decks, [:status])
    create index(:pitch_decks, [:venture])
  end
end
