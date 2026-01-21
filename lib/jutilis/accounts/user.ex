defmodule Jutilis.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @two_factor_methods ["totp", "email"]

  schema "users" do
    field :email, :string
    field :password, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :utc_datetime
    field :authenticated_at, :utc_datetime, virtual: true
    field :admin_flag, :boolean, default: false
    field :investor_flag, :boolean, default: false

    # Two-factor authentication
    field :two_factor_enabled, :boolean, default: false
    # "totp" or "email"
    field :two_factor_method, :string

    # TOTP (authenticator app) - encrypted at rest
    field :totp_secret_encrypted, Jutilis.Encrypted.Binary, redact: true
    field :totp_secret, :string, virtual: true, redact: true
    field :totp_confirmed_at, :utc_datetime

    # Backup codes - encrypted at rest
    field :backup_codes_encrypted, Jutilis.Encrypted.IntegerList, redact: true
    field :backup_codes, {:array, :integer}, virtual: true, redact: true
    field :backup_codes_generated_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  def two_factor_methods, do: @two_factor_methods

  @doc """
  A user changeset for registering or changing the email.

  It requires the email to change otherwise an error is added.

  ## Options

    * `:validate_unique` - Set to false if you don't want to validate the
      uniqueness of the email, useful when displaying live validations.
      Defaults to `true`.
  """
  def email_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:email])
    |> validate_email(opts)
  end

  defp validate_email(changeset, opts) do
    changeset =
      changeset
      |> validate_required([:email])
      |> validate_format(:email, ~r/^[^@,;\s]+@[^@,;\s]+$/,
        message: "must have the @ sign and no spaces"
      )
      |> validate_length(:email, max: 160)

    if Keyword.get(opts, :validate_unique, true) do
      changeset
      |> unsafe_validate_unique(:email, Jutilis.Repo)
      |> unique_constraint(:email)
      |> validate_email_changed()
    else
      changeset
    end
  end

  defp validate_email_changed(changeset) do
    if get_field(changeset, :email) && get_change(changeset, :email) == nil do
      add_error(changeset, :email, "did not change")
    else
      changeset
    end
  end

  @doc """
  A user changeset for changing the password.

  It is important to validate the length of the password, as long passwords may
  be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(user, attrs, opts \\ []) do
    user
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    # Examples of additional password validation:
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      # Hashing could be done with `Ecto.Changeset.prepare_changes/2`, but that
      # would keep the database transaction open longer and hurt performance.
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(user) do
    now = DateTime.utc_now(:second)
    change(user, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no user or the user doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Jutilis.Accounts.User{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  # =============================================================================
  # Two-Factor Authentication
  # =============================================================================

  @doc """
  Changeset for enabling TOTP-based 2FA.
  Encrypts and stores the TOTP secret.
  """
  def enable_totp_changeset(user, secret) when is_binary(secret) do
    now = DateTime.utc_now(:second)

    user
    |> change()
    |> put_change(:totp_secret_encrypted, secret)
    |> put_change(:totp_confirmed_at, now)
    |> put_change(:two_factor_enabled, true)
    |> put_change(:two_factor_method, "totp")
  end

  @doc """
  Changeset for enabling email-based 2FA.
  """
  def enable_email_2fa_changeset(user) do
    user
    |> change()
    |> put_change(:two_factor_enabled, true)
    |> put_change(:two_factor_method, "email")
  end

  @doc """
  Changeset for disabling 2FA entirely.
  Clears all 2FA-related fields.
  """
  def disable_2fa_changeset(user) do
    user
    |> change()
    |> put_change(:two_factor_enabled, false)
    |> put_change(:two_factor_method, nil)
    |> put_change(:totp_secret_encrypted, nil)
    |> put_change(:totp_confirmed_at, nil)
    |> put_change(:backup_codes_encrypted, nil)
    |> put_change(:backup_codes_generated_at, nil)
  end

  @doc """
  Changeset for storing encrypted backup codes.
  """
  def backup_codes_changeset(user, codes) when is_list(codes) do
    now = DateTime.utc_now(:second)

    user
    |> change()
    |> put_change(:backup_codes_encrypted, codes)
    |> put_change(:backup_codes_generated_at, now)
  end

  @doc """
  Verifies a TOTP code against the user's secret.
  Returns true if the code is valid.
  """
  def valid_totp?(%__MODULE__{totp_secret_encrypted: secret}, code)
      when is_binary(secret) and is_binary(code) do
    NimbleTOTP.valid?(secret, code)
  end

  def valid_totp?(_, _), do: false

  @doc """
  Checks if a backup code is valid and returns the remaining codes.
  Returns {:ok, remaining_codes} if valid, :error if invalid.
  """
  def use_backup_code(%__MODULE__{backup_codes_encrypted: codes}, code)
      when is_list(codes) and is_integer(code) do
    if code in codes do
      {:ok, List.delete(codes, code)}
    else
      :error
    end
  end

  def use_backup_code(%__MODULE__{backup_codes_encrypted: codes}, code)
      when is_list(codes) and is_binary(code) do
    case Integer.parse(code) do
      {int_code, ""} -> use_backup_code(%__MODULE__{backup_codes_encrypted: codes}, int_code)
      _ -> :error
    end
  end

  def use_backup_code(_, _), do: :error

  @doc """
  Returns true if the user has 2FA enabled.
  """
  def two_factor_enabled?(%__MODULE__{two_factor_enabled: true}), do: true
  def two_factor_enabled?(_), do: false

  @doc """
  Returns true if the user uses TOTP for 2FA.
  """
  def uses_totp?(%__MODULE__{two_factor_enabled: true, two_factor_method: "totp"}), do: true
  def uses_totp?(_), do: false

  @doc """
  Returns true if the user uses email OTP for 2FA.
  """
  def uses_email_otp?(%__MODULE__{two_factor_enabled: true, two_factor_method: "email"}), do: true
  def uses_email_otp?(_), do: false
end
