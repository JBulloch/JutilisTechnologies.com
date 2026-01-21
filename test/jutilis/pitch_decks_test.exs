defmodule Jutilis.PitchDecksTest do
  use Jutilis.DataCase

  alias Jutilis.PitchDecks
  alias Jutilis.Accounts.Scope

  describe "pitch_decks" do
    alias Jutilis.PitchDecks.PitchDeck

    import Jutilis.PitchDecksFixtures
    import Jutilis.AccountsFixtures

    @invalid_attrs %{"status" => nil, "description" => nil, "title" => nil}

    defp admin_scope do
      user = user_fixture(%{admin_flag: true})
      Scope.for_user(user)
    end

    test "list_pitch_decks/1 returns all pitch_decks for admin" do
      pitch_deck = pitch_deck_fixture()
      scope = admin_scope()
      pitch_decks = PitchDecks.list_pitch_decks(scope)
      assert Enum.any?(pitch_decks, fn pd -> pd.id == pitch_deck.id end)
    end

    test "get_pitch_deck!/2 returns the pitch_deck with given slug" do
      pitch_deck = pitch_deck_fixture()
      scope = admin_scope()
      assert PitchDecks.get_pitch_deck!(scope, pitch_deck.slug).id == pitch_deck.id
    end

    test "create_pitch_deck/2 with valid data creates a pitch_deck" do
      scope = admin_scope()

      valid_attrs = %{
        "status" => "draft",
        "description" => "some description",
        "title" => "some title",
        "venture" => "other"
      }

      assert {:ok, %PitchDeck{} = pitch_deck} = PitchDecks.create_pitch_deck(scope, valid_attrs)
      assert pitch_deck.status == "draft"
      assert pitch_deck.description == "some description"
      assert pitch_deck.title == "some title"
      assert pitch_deck.venture == "other"
    end

    test "create_pitch_deck/2 with invalid data returns error changeset" do
      scope = admin_scope()
      assert {:error, %Ecto.Changeset{}} = PitchDecks.create_pitch_deck(scope, @invalid_attrs)
    end

    test "update_pitch_deck/3 with valid data updates the pitch_deck" do
      pitch_deck = pitch_deck_fixture()
      scope = admin_scope()

      update_attrs = %{
        "status" => "published",
        "description" => "some updated description",
        "title" => "some updated title",
        "venture" => "cards-co-op"
      }

      assert {:ok, %PitchDeck{} = updated_pitch_deck} =
               PitchDecks.update_pitch_deck(scope, pitch_deck, update_attrs)

      assert updated_pitch_deck.status == "published"
      assert updated_pitch_deck.description == "some updated description"
      assert updated_pitch_deck.title == "some updated title"
      assert updated_pitch_deck.venture == "cards-co-op"
    end

    test "update_pitch_deck/3 with invalid data returns error changeset" do
      pitch_deck = pitch_deck_fixture()
      scope = admin_scope()

      assert {:error, %Ecto.Changeset{}} =
               PitchDecks.update_pitch_deck(scope, pitch_deck, @invalid_attrs)

      fetched = PitchDecks.get_pitch_deck!(scope, pitch_deck.slug)
      assert fetched.id == pitch_deck.id
    end

    test "delete_pitch_deck/2 deletes the pitch_deck" do
      pitch_deck = pitch_deck_fixture()
      scope = admin_scope()
      assert {:ok, %PitchDeck{}} = PitchDecks.delete_pitch_deck(scope, pitch_deck)

      assert_raise Ecto.NoResultsError, fn ->
        PitchDecks.get_pitch_deck!(scope, pitch_deck.slug)
      end
    end

    test "change_pitch_deck/2 returns a pitch_deck changeset" do
      pitch_deck = pitch_deck_fixture()
      scope = admin_scope()
      assert %Ecto.Changeset{} = PitchDecks.change_pitch_deck(scope, pitch_deck)
    end
  end
end
