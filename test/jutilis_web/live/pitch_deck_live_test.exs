defmodule JutilisWeb.PitchDeckLiveTest do
  use JutilisWeb.ConnCase

  import Phoenix.LiveViewTest
  import Jutilis.PitchDecksFixtures
  import Jutilis.AccountsFixtures

  setup %{conn: conn} do
    user = user_fixture(%{admin_flag: true})
    %{conn: log_in_user(conn, user), user: user}
  end

  defp create_pitch_deck(_context) do
    pitch_deck = pitch_deck_fixture()

    %{pitch_deck: pitch_deck}
  end

  describe "Index" do
    setup [:create_pitch_deck]

    test "lists all pitch_decks", %{conn: conn, pitch_deck: pitch_deck} do
      {:ok, _index_live, html} = live(conn, ~p"/admin/pitch-decks")

      assert html =~ "Pitch Decks"
      assert html =~ pitch_deck.title
    end

    test "deletes pitch_deck in listing", %{conn: conn, pitch_deck: pitch_deck} do
      {:ok, index_live, _html} = live(conn, ~p"/admin/pitch-decks")

      assert index_live
             |> element("#pitch_decks-#{pitch_deck.id} a", "Delete")
             |> render_click()

      refute has_element?(index_live, "#pitch_decks-#{pitch_deck.id}")
    end
  end

  describe "Show" do
    setup [:create_pitch_deck]

    test "displays pitch_deck", %{conn: conn, pitch_deck: pitch_deck} do
      {:ok, _show_live, html} = live(conn, ~p"/admin/pitch-decks/#{pitch_deck}")

      assert html =~ pitch_deck.title
    end
  end
end
