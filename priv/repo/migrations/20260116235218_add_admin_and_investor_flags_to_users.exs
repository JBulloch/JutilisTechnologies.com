defmodule Jutilis.Repo.Migrations.AddAdminAndInvestorFlagsToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add :admin_flag, :boolean, default: false, null: false
      add :investor_flag, :boolean, default: false, null: false
    end
  end
end
