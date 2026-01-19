defmodule JutilisWeb.PageControllerTest do
  use JutilisWeb.ConnCase

  import Jutilis.AccountsFixtures

  setup do
    user = user_fixture()
    # Create a flagship portfolio for the home page
    Jutilis.Repo.insert!(%Jutilis.Portfolios.Portfolio{
      name: "Jutilis Technologies",
      slug: "jutilis",
      user_id: user.id,
      status: "published",
      is_flagship: true,
      hero_title: "Jutilis",
      hero_subtitle: "Technologies"
    })

    :ok
  end

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert html_response(conn, 200) =~ "Jutilis"
    assert html_response(conn, 200) =~ "Technologies"
  end
end
