defmodule Jutilis.Repo.Migrations.CreateSubscribers do
  use Ecto.Migration

  def change do
    create table(:subscribers) do
      add :email, :string, null: false
      add :name, :string
      add :subscribed_at, :utc_datetime

      timestamps(type: :utc_datetime)
    end

    create unique_index(:subscribers, [:email])
  end
end
