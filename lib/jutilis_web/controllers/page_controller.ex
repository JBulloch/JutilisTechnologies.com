defmodule JutilisWeb.PageController do
  use JutilisWeb, :controller

  alias Jutilis.Ventures

  def home(conn, _params) do
    ventures = Ventures.list_active_ventures()
    venture_count = length(ventures)

    render(conn, :home,
      current_scope: conn.assigns[:current_scope],
      ventures: ventures,
      venture_count: venture_count
    )
  end
end
