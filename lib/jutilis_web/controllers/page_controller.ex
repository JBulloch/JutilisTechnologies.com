defmodule JutilisWeb.PageController do
  use JutilisWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
