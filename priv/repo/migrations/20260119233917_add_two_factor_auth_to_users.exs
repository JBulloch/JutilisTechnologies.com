defmodule Jutilis.Repo.Migrations.AddTwoFactorAuthToUsers do
  use Ecto.Migration

  def change do
    alter table(:users) do
      # 2FA settings
      add :two_factor_enabled, :boolean, default: false, null: false
      add :two_factor_method, :string  # "totp" or "email"

      # TOTP (authenticator app) - encrypted at rest
      add :totp_secret_encrypted, :binary
      add :totp_confirmed_at, :utc_datetime

      # Backup codes - encrypted at rest (stored as JSON array)
      add :backup_codes_encrypted, :binary
      add :backup_codes_generated_at, :utc_datetime
    end

    # Email OTP tokens table for temporary codes
    create table(:user_otp_codes) do
      add :user_id, references(:users, on_delete: :delete_all), null: false
      add :code_hash, :binary, null: false
      add :context, :string, null: false  # "login", "setup"
      add :expires_at, :utc_datetime, null: false
      add :used_at, :utc_datetime

      timestamps(type: :utc_datetime, updated_at: false)
    end

    create index(:user_otp_codes, [:user_id])
    create index(:user_otp_codes, [:user_id, :context])
  end
end
