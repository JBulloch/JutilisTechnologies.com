defmodule JutilisWeb.PortfolioController do
  use JutilisWeb, :controller

  alias Jutilis.Portfolios.Portfolio
  alias Jutilis.Ventures

  @doc """
  Renders the portfolio home page.

  The portfolio is resolved by the PortfolioResolver plug and available
  in conn.assigns[:portfolio].
  """
  def home(conn, _params) do
    case conn.assigns[:portfolio] do
      %Portfolio{status: "published"} = portfolio ->
        render_portfolio(conn, portfolio)

      %Portfolio{status: "draft"} = portfolio ->
        # Allow owner to preview their draft portfolio
        if can_preview?(conn, portfolio) do
          render_portfolio(conn, portfolio)
        else
          render_not_found(conn)
        end

      _ ->
        render_not_found(conn)
    end
  end

  defp render_portfolio(conn, portfolio) do
    # Load ventures for this portfolio
    active_ventures = Ventures.list_active_ventures_for_portfolio(portfolio.id)
    coming_soon_ventures = Ventures.list_coming_soon_ventures_for_portfolio(portfolio.id)
    acquired_ventures = Ventures.list_acquired_ventures_for_portfolio(portfolio.id)

    conn
    |> assign(:page_title, portfolio.meta_title || portfolio.name)
    |> assign(:meta_description, portfolio.meta_description || portfolio.hero_description)
    |> assign(:theme_color, portfolio.theme_color)
    |> render(:home,
      portfolio: portfolio,
      active_ventures: active_ventures,
      coming_soon_ventures: coming_soon_ventures,
      acquired_ventures: acquired_ventures
    )
  end

  defp render_not_found(conn) do
    conn
    |> put_status(:not_found)
    |> put_view(JutilisWeb.ErrorHTML)
    |> render(:"404")
  end

  defp can_preview?(conn, portfolio) do
    case conn.assigns[:current_scope] do
      %{user: user} when not is_nil(user) ->
        user.id == portfolio.user_id || user.admin_flag

      _ ->
        false
    end
  end
end
