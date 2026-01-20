defmodule Jutilis.Accounts.UserOtpCode do
  @moduledoc """
  Schema for storing temporary OTP codes for email-based 2FA.

  Codes are hashed before storage and have a short expiration time.
  """
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  @hash_algorithm :sha256
  @code_length 6
  @code_validity_minutes 10

  schema "user_otp_codes" do
    field :code_hash, :binary
    field :context, :string
    field :expires_at, :utc_datetime
    field :used_at, :utc_datetime

    belongs_to :user, Jutilis.Accounts.User

    timestamps(type: :utc_datetime, updated_at: false)
  end

  @doc """
  Generates a random numeric OTP code.
  """
  def generate_code do
    # Generate a random 6-digit code
    :crypto.strong_rand_bytes(4)
    |> :binary.decode_unsigned()
    |> rem(1_000_000)
    |> Integer.to_string()
    |> String.pad_leading(@code_length, "0")
  end

  @doc """
  Builds an OTP code token for the given user and context.
  Returns {code, changeset} where code is the plain-text code to send to the user.
  """
  def build_otp_token(user, context) when context in ["login", "setup"] do
    code = generate_code()
    hashed = hash_code(code)
    expires_at =
      DateTime.utc_now()
      |> DateTime.add(@code_validity_minutes, :minute)
      |> DateTime.truncate(:second)

    changeset =
      %__MODULE__{}
      |> change()
      |> put_change(:user_id, user.id)
      |> put_change(:code_hash, hashed)
      |> put_change(:context, context)
      |> put_change(:expires_at, expires_at)

    {code, changeset}
  end

  @doc """
  Verifies an OTP code for the given user and context.
  Returns {:ok, otp_record} if valid, :error otherwise.
  """
  def verify_code_query(user, code, context) do
    hashed = hash_code(code)
    now = DateTime.utc_now(:second)

    from(o in __MODULE__,
      where: o.user_id == ^user.id,
      where: o.context == ^context,
      where: o.code_hash == ^hashed,
      where: o.expires_at > ^now,
      where: is_nil(o.used_at),
      order_by: [desc: o.inserted_at],
      limit: 1
    )
  end

  @doc """
  Marks an OTP code as used.
  """
  def mark_used_changeset(otp_code) do
    change(otp_code, used_at: DateTime.utc_now(:second))
  end

  @doc """
  Query to delete expired or used OTP codes for cleanup.
  """
  def expired_codes_query do
    now = DateTime.utc_now(:second)

    from(o in __MODULE__,
      where: o.expires_at < ^now or not is_nil(o.used_at)
    )
  end

  @doc """
  Query to delete all OTP codes for a user in a given context.
  """
  def user_codes_query(user, context) do
    from(o in __MODULE__,
      where: o.user_id == ^user.id,
      where: o.context == ^context
    )
  end

  defp hash_code(code) do
    :crypto.hash(@hash_algorithm, code)
  end
end
