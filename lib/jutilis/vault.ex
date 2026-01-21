defmodule Jutilis.Vault do
  @moduledoc """
  Cloak vault for encrypting sensitive data at rest.

  Uses AES-GCM encryption with keys configured from:
  - Application config `:cloak_key` (for development)
  - Environment variable `CLOAK_KEY` (for production)
  """
  use Cloak.Vault, otp_app: :jutilis

  @impl GenServer
  def init(config) do
    config =
      Keyword.put(config, :ciphers,
        default: {
          Cloak.Ciphers.AES.GCM,
          tag: "AES.GCM.V1", key: get_cloak_key!(), iv_length: 12
        }
      )

    {:ok, config}
  end

  defp get_cloak_key! do
    # First check application config (dev), then environment variable (prod)
    case Application.get_env(:jutilis, :cloak_key) do
      nil -> decode_env!("CLOAK_KEY")
      key -> Base.decode64!(key)
    end
  end

  defp decode_env!(var) do
    case System.get_env(var) do
      nil ->
        raise """
        Environment variable #{var} is not set!

        Generate a key with: mix cloak.gen.key --length 32
        Then set it: export CLOAK_KEY="<base64_encoded_key>"
        """

      value ->
        Base.decode64!(value)
    end
  end
end
