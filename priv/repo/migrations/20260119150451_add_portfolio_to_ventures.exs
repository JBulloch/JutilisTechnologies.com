defmodule Jutilis.Repo.Migrations.AddPortfolioToVentures do
  use Ecto.Migration

  def change do
    # Add portfolio_id to ventures (initially nullable for migration)
    alter table(:ventures) do
      add :portfolio_id, references(:portfolios, on_delete: :delete_all)
    end

    create index(:ventures, [:portfolio_id])
    create index(:ventures, [:portfolio_id, :status])

    # Add portfolio_id to subscribers
    alter table(:subscribers) do
      add :portfolio_id, references(:portfolios, on_delete: :delete_all)
    end

    create index(:subscribers, [:portfolio_id])
  end
end
