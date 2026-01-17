defmodule Jutilis.PitchDecksFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Jutilis.PitchDecks` context.
  """

  @doc """
  Generate a pitch_deck.
  """
  def pitch_deck_fixture(attrs \\ %{}) do
    {:ok, pitch_deck} =
      attrs
      |> Enum.into(%{
        description: "some description",
        file_url: "some file_url",
        status: "some status",
        title: "some title",
        venture: "some venture"
      })
      |> Jutilis.PitchDecks.create_pitch_deck()

    pitch_deck
  end
end
