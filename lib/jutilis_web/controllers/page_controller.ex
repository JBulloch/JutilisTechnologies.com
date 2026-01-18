defmodule JutilisWeb.PageController do
  use JutilisWeb, :controller

  alias Jutilis.Ventures

  def home(conn, _params) do
    active_ventures = Ventures.list_active_ventures()
    coming_soon_ventures = Ventures.list_coming_soon_ventures()
    acquired_ventures = Ventures.list_acquired_ventures()
    venture_count = length(active_ventures) + length(coming_soon_ventures)

    render(conn, :home,
      current_scope: conn.assigns[:current_scope],
      active_ventures: active_ventures,
      coming_soon_ventures: coming_soon_ventures,
      acquired_ventures: acquired_ventures,
      venture_count: venture_count
    )
  end
end
