defmodule Jutilis.Repo.Migrations.AddHtmlContentToPitchDecks do
  use Ecto.Migration

  def change do
    alter table(:pitch_decks) do
      add :html_content, :text
    end
  end
end
