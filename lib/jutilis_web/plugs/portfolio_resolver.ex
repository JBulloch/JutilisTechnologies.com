defmodule JutilisWeb.Plugs.PortfolioResolver do
  @moduledoc """
  Plug that resolves the current portfolio based on the request context.

  Resolution order:
  1. Custom domain - e.g., jutilistechnologies.com → Jutilis portfolio
  2. Path-based slug - e.g., /p/jutilis → Jutilis portfolio (handled by router params)
  3. Flagship default - / on main domain → Flagship portfolio

  The resolved portfolio is stored in conn.assigns[:portfolio] for use in controllers
  and templates.
  """

  import Plug.Conn
  alias Jutilis.Portfolios

  @behaviour Plug

  @impl true
  def init(opts), do: opts

  @impl true
  def call(conn, _opts) do
    case resolve_portfolio(conn) do
      {:ok, portfolio} ->
        assign(conn, :portfolio, portfolio)

      {:error, :not_found} ->
        assign(conn, :portfolio, nil)
    end
  end

  @doc """
  Resolves a portfolio from the request context.

  Returns {:ok, portfolio} if found, {:error, :not_found} otherwise.
  """
  def resolve_portfolio(conn) do
    host = get_host(conn)

    cond do
      # Check for path-based slug first (from router params)
      slug = conn.params["portfolio_slug"] ->
        case Portfolios.get_published_portfolio_by_slug(slug) do
          nil -> {:error, :not_found}
          portfolio -> {:ok, portfolio}
        end

      # Check for custom domain
      portfolio = Portfolios.get_portfolio_by_custom_domain(host) ->
        {:ok, portfolio}

      # Check if this is a main domain (fallback to flagship)
      main_domain?(host) ->
        case Portfolios.get_flagship_portfolio() do
          nil -> {:error, :not_found}
          portfolio -> {:ok, portfolio}
        end

      # Unknown domain - try to find by custom domain anyway
      true ->
        {:error, :not_found}
    end
  end

  defp get_host(conn) do
    # Get the host from the request, stripping port if present
    conn.host
    |> String.downcase()
    |> String.replace(~r/:\d+$/, "")
  end

  defp main_domain?(host) do
    main_domains = Application.get_env(:jutilis, :main_domains, default_main_domains())
    host in main_domains or dynamic_main_domain?(host)
  end

  defp default_main_domains do
    [
      "localhost",
      "127.0.0.1",
      "jutilistechnologies.com",
      "www.jutilistechnologies.com",
      "jutilis.fly.dev",
      # Test hosts
      "www.example.com",
      "example.com"
    ]
  end

  # Allow PHX_HOST env var and common dev environments (Codespaces, Gitpod, etc.)
  defp dynamic_main_domain?(host) do
    phx_host = System.get_env("PHX_HOST")

    cond do
      phx_host && host == phx_host -> true
      String.ends_with?(host, ".app.github.dev") -> true
      String.ends_with?(host, ".gitpod.io") -> true
      String.ends_with?(host, ".preview.app.github.dev") -> true
      true -> false
    end
  end
end
