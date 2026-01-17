defmodule Jutilis.PitchDecksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Jutilis.PitchDecks` context.
  """

  alias Jutilis.AccountsFixtures
  alias Jutilis.Accounts.Scope

  @doc """
  Generate a pitch_deck.
  """
  def pitch_deck_fixture(attrs \\ %{}) do
    user = AccountsFixtures.user_fixture(%{admin_flag: true})
    scope = Scope.for_user(user)

    {:ok, pitch_deck} =
      attrs
      |> Enum.into(%{
        "description" => "some description",
        "file_url" => "some file_url",
        "status" => "draft",
        "title" => "some title",
        "venture" => "other"
      })
      |> then(&Jutilis.PitchDecks.create_pitch_deck(scope, &1))

    pitch_deck
  end
end
