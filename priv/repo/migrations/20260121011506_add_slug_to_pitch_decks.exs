defmodule Jutilis.Repo.Migrations.AddSlugToPitchDecks do
  use Ecto.Migration

  def change do
    alter table(:pitch_decks) do
      add :slug, :string
      add :access_code, :string
    end

    create unique_index(:pitch_decks, [:slug])

    # Backfill existing pitch decks with slugs based on their titles
    execute """
            UPDATE pitch_decks
            SET slug = LOWER(
              REGEXP_REPLACE(
                REGEXP_REPLACE(title, '[^a-zA-Z0-9\\s-]', '', 'g'),
                '\\s+', '-', 'g'
              )
            ) || '-' || id
            WHERE slug IS NULL
            """,
            ""
  end
end
