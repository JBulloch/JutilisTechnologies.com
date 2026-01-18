defmodule Jutilis.Repo.Migrations.AddFeaturedPitchDeckToVentures do
  use Ecto.Migration

  def change do
    alter table(:ventures) do
      add :featured_pitch_deck_id, references(:pitch_decks, on_delete: :nilify_all)
      add :acquired_date, :date
      add :acquired_by, :string
    end

    create index(:ventures, [:featured_pitch_deck_id])
  end
end
