defmodule Jutilis.Repo do
  use Ecto.Repo,
    otp_app: :jutilis,
    adapter: Ecto.Adapters.Postgres
end
