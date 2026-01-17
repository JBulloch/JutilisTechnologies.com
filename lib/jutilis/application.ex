defmodule Jutilis.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      JutilisWeb.Telemetry,
      Jutilis.Repo,
      {DNSCluster, query: Application.get_env(:jutilis, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Jutilis.PubSub},
      # Start a worker by calling: Jutilis.Worker.start_link(arg)
      # {Jutilis.Worker, arg},
      # Start to serve requests, typically the last entry
      JutilisWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Jutilis.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    JutilisWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
