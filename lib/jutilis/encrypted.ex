defmodule Jutilis.Encrypted do
  @moduledoc """
  Encrypted field types for Ecto schemas.

  These types automatically encrypt data when writing to the database
  and decrypt when reading from the database.
  """

  defmodule Binary do
    @moduledoc "Encrypted binary field"
    use Cloak.Ecto.Binary, vault: Jutilis.Vault
  end

  defmodule StringType do
    @moduledoc "Encrypted string field"
    use Cloak.Ecto.Binary, vault: Jutilis.Vault

    def cast(value) when is_binary(value), do: {:ok, value}
    def cast(_), do: :error

    def dump(value), do: Jutilis.Encrypted.Binary.dump(value)
    def load(value), do: Jutilis.Encrypted.Binary.load(value)
  end

  defmodule Map do
    @moduledoc "Encrypted map field (stored as JSON)"
    use Cloak.Ecto.Map, vault: Jutilis.Vault
  end

  defmodule IntegerList do
    @moduledoc "Encrypted list of integers (for backup codes)"
    use Cloak.Ecto.Binary, vault: Jutilis.Vault

    def cast(value) when is_list(value), do: {:ok, value}
    def cast(_), do: :error

    def dump(value) when is_list(value) do
      value
      |> Jason.encode!()
      |> Jutilis.Encrypted.Binary.dump()
    end

    def dump(_), do: :error

    def load(nil), do: {:ok, nil}

    def load(value) do
      case Jutilis.Encrypted.Binary.load(value) do
        {:ok, nil} -> {:ok, nil}
        {:ok, json} -> {:ok, Jason.decode!(json)}
        :error -> :error
      end
    end
  end
end
