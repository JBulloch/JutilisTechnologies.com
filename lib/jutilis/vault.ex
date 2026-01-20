defmodule Jutilis.Vault do
  @moduledoc """
  Cloak vault for encrypting sensitive data at rest.

  Uses AES-GCM encryption with keys configured from environment variables.
  """
  use Cloak.Vault, otp_app: :jutilis

  @impl GenServer
  def init(config) do
    config =
      Keyword.put(config, :ciphers,
        default: {
          Cloak.Ciphers.AES.GCM,
          tag: "AES.GCM.V1",
          key: decode_env!("CLOAK_KEY"),
          iv_length: 12
        }
      )

    {:ok, config}
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
