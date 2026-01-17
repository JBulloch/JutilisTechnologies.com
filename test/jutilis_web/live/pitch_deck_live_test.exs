defmodule JutilisWeb.PitchDeckLiveTest do
  use JutilisWeb.ConnCase

  import Phoenix.LiveViewTest
  import Jutilis.PitchDecksFixtures

  @create_attrs %{
    status: "some status",
    description: "some description",
    title: "some title",
    file_url: "some file_url",
    venture: "some venture"
  }
  @update_attrs %{
    status: "some updated status",
    description: "some updated description",
    title: "some updated title",
    file_url: "some updated file_url",
    venture: "some updated venture"
  }
  @invalid_attrs %{status: nil, description: nil, title: nil, file_url: nil, venture: nil}

  setup :register_and_log_in_user

  defp create_pitch_deck(%{scope: scope}) do
    pitch_deck = pitch_deck_fixture(scope)

    %{pitch_deck: pitch_deck}
  end

  describe "Index" do
    setup [:create_pitch_deck]

    test "lists all pitch_decks", %{conn: conn, pitch_deck: pitch_deck} do
      {:ok, _index_live, html} = live(conn, ~p"/pitch_decks")

      assert html =~ "Listing Pitch decks"
      assert html =~ pitch_deck.title
    end

    test "saves new pitch_deck", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, ~p"/pitch_decks")

      assert {:ok, form_live, _} =
               index_live
               |> element("a", "New Pitch deck")
               |> render_click()
               |> follow_redirect(conn, ~p"/pitch_decks/new")

      assert render(form_live) =~ "New Pitch deck"

      assert form_live
             |> form("#pitch_deck-form", pitch_deck: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#pitch_deck-form", pitch_deck: @create_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/pitch_decks")

      html = render(index_live)
      assert html =~ "Pitch deck created successfully"
      assert html =~ "some title"
    end

    test "updates pitch_deck in listing", %{conn: conn, pitch_deck: pitch_deck} do
      {:ok, index_live, _html} = live(conn, ~p"/pitch_decks")

      assert {:ok, form_live, _html} =
               index_live
               |> element("#pitch_decks-#{pitch_deck.id} a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/pitch_decks/#{pitch_deck}/edit")

      assert render(form_live) =~ "Edit Pitch deck"

      assert form_live
             |> form("#pitch_deck-form", pitch_deck: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, index_live, _html} =
               form_live
               |> form("#pitch_deck-form", pitch_deck: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/pitch_decks")

      html = render(index_live)
      assert html =~ "Pitch deck updated successfully"
      assert html =~ "some updated title"
    end

    test "deletes pitch_deck in listing", %{conn: conn, pitch_deck: pitch_deck} do
      {:ok, index_live, _html} = live(conn, ~p"/pitch_decks")

      assert index_live |> element("#pitch_decks-#{pitch_deck.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#pitch_decks-#{pitch_deck.id}")
    end
  end

  describe "Show" do
    setup [:create_pitch_deck]

    test "displays pitch_deck", %{conn: conn, pitch_deck: pitch_deck} do
      {:ok, _show_live, html} = live(conn, ~p"/pitch_decks/#{pitch_deck}")

      assert html =~ "Show Pitch deck"
      assert html =~ pitch_deck.title
    end

    test "updates pitch_deck and returns to show", %{conn: conn, pitch_deck: pitch_deck} do
      {:ok, show_live, _html} = live(conn, ~p"/pitch_decks/#{pitch_deck}")

      assert {:ok, form_live, _} =
               show_live
               |> element("a", "Edit")
               |> render_click()
               |> follow_redirect(conn, ~p"/pitch_decks/#{pitch_deck}/edit?return_to=show")

      assert render(form_live) =~ "Edit Pitch deck"

      assert form_live
             |> form("#pitch_deck-form", pitch_deck: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert {:ok, show_live, _html} =
               form_live
               |> form("#pitch_deck-form", pitch_deck: @update_attrs)
               |> render_submit()
               |> follow_redirect(conn, ~p"/pitch_decks/#{pitch_deck}")

      html = render(show_live)
      assert html =~ "Pitch deck updated successfully"
      assert html =~ "some updated title"
    end
  end
end
