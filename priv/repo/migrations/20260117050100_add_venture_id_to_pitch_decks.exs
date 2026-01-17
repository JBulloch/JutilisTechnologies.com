defmodule Jutilis.Repo.Migrations.AddVentureIdToPitchDecks do
  use Ecto.Migration

  def change do
    alter table(:pitch_decks) do
      add :venture_id, references(:ventures, on_delete: :nilify_all)
    end

    create index(:pitch_decks, [:venture_id])
  end
end
