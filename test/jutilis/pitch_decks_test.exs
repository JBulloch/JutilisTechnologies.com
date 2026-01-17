defmodule Jutilis.PitchDecksTest do
  use Jutilis.DataCase

  alias Jutilis.PitchDecks

  describe "pitch_decks" do
    alias Jutilis.PitchDecks.PitchDeck

    import Jutilis.PitchDecksFixtures

    @invalid_attrs %{status: nil, description: nil, title: nil, file_url: nil, venture: nil}

    test "list_pitch_decks/0 returns all pitch_decks" do
      pitch_deck = pitch_deck_fixture()
      assert PitchDecks.list_pitch_decks() == [pitch_deck]
    end

    test "get_pitch_deck!/1 returns the pitch_deck with given id" do
      pitch_deck = pitch_deck_fixture()
      assert PitchDecks.get_pitch_deck!(pitch_deck.id) == pitch_deck
    end

    test "create_pitch_deck/1 with valid data creates a pitch_deck" do
      valid_attrs = %{
        status: "some status",
        description: "some description",
        title: "some title",
        file_url: "some file_url",
        venture: "some venture"
      }

      assert {:ok, %PitchDeck{} = pitch_deck} = PitchDecks.create_pitch_deck(valid_attrs)
      assert pitch_deck.status == "some status"
      assert pitch_deck.description == "some description"
      assert pitch_deck.title == "some title"
      assert pitch_deck.file_url == "some file_url"
      assert pitch_deck.venture == "some venture"
    end

    test "create_pitch_deck/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = PitchDecks.create_pitch_deck(@invalid_attrs)
    end

    test "update_pitch_deck/2 with valid data updates the pitch_deck" do
      pitch_deck = pitch_deck_fixture()

      update_attrs = %{
        status: "some updated status",
        description: "some updated description",
        title: "some updated title",
        file_url: "some updated file_url",
        venture: "some updated venture"
      }

      assert {:ok, %PitchDeck{} = pitch_deck} =
               PitchDecks.update_pitch_deck(pitch_deck, update_attrs)

      assert pitch_deck.status == "some updated status"
      assert pitch_deck.description == "some updated description"
      assert pitch_deck.title == "some updated title"
      assert pitch_deck.file_url == "some updated file_url"
      assert pitch_deck.venture == "some updated venture"
    end

    test "update_pitch_deck/2 with invalid data returns error changeset" do
      pitch_deck = pitch_deck_fixture()

      assert {:error, %Ecto.Changeset{}} =
               PitchDecks.update_pitch_deck(pitch_deck, @invalid_attrs)

      assert pitch_deck == PitchDecks.get_pitch_deck!(pitch_deck.id)
    end

    test "delete_pitch_deck/1 deletes the pitch_deck" do
      pitch_deck = pitch_deck_fixture()
      assert {:ok, %PitchDeck{}} = PitchDecks.delete_pitch_deck(pitch_deck)
      assert_raise Ecto.NoResultsError, fn -> PitchDecks.get_pitch_deck!(pitch_deck.id) end
    end

    test "change_pitch_deck/1 returns a pitch_deck changeset" do
      pitch_deck = pitch_deck_fixture()
      assert %Ecto.Changeset{} = PitchDecks.change_pitch_deck(pitch_deck)
    end
  end
end
