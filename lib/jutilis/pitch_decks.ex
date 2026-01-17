defmodule Jutilis.PitchDecks do
  @moduledoc """
  The PitchDecks context.
  """

  import Ecto.Query, warn: false
  alias Jutilis.Repo
  alias Jutilis.Accounts.{Scope, User}
  alias Jutilis.PitchDecks.PitchDeck

  @doc """
  Returns the list of pitch_decks for the given scope.
  Admins see all pitch decks, investors see published ones.
  """
  def list_pitch_decks(%Scope{user: %User{admin_flag: true}}) do
    from(p in PitchDeck, order_by: [desc: p.inserted_at], preload: [:user])
    |> Repo.all()
  end

  def list_pitch_decks(%Scope{user: %User{investor_flag: true}}) do
    from(p in PitchDeck, where: p.status == "published", order_by: [desc: p.inserted_at])
    |> Repo.all()
  end

  def list_pitch_decks(_scope), do: []

  @doc """
  Gets a single pitch_deck for the given scope.
  Admins can see all, investors can see published ones.
  """
  def get_pitch_deck!(%Scope{user: %User{admin_flag: true}}, id) do
    Repo.get!(PitchDeck, id) |> Repo.preload(:user)
  end

  def get_pitch_deck!(%Scope{user: %User{investor_flag: true}}, id) do
    from(p in PitchDeck, where: p.id == ^id and p.status == "published")
    |> Repo.one!()
  end

  def get_pitch_deck!(_scope, _id), do: raise(Ecto.NoResultsError, queryable: PitchDeck)

  @doc """
  Creates a pitch_deck. Only admins can create.
  """
  def create_pitch_deck(%Scope{user: %User{admin_flag: true, id: user_id}}, attrs) do
    attrs = Map.put(attrs, "user_id", user_id)

    %PitchDeck{}
    |> PitchDeck.changeset(attrs)
    |> Repo.insert()
  end

  def create_pitch_deck(_scope, _attrs), do: {:error, :unauthorized}

  @doc """
  Updates a pitch_deck. Only admins can update.
  """
  def update_pitch_deck(%Scope{user: %User{admin_flag: true}}, %PitchDeck{} = pitch_deck, attrs) do
    pitch_deck
    |> PitchDeck.changeset(attrs)
    |> Repo.update()
  end

  def update_pitch_deck(_scope, _pitch_deck, _attrs), do: {:error, :unauthorized}

  @doc """
  Deletes a pitch_deck. Only admins can delete.
  """
  def delete_pitch_deck(%Scope{user: %User{admin_flag: true}}, %PitchDeck{} = pitch_deck) do
    Repo.delete(pitch_deck)
  end

  def delete_pitch_deck(_scope, _pitch_deck), do: {:error, :unauthorized}

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking pitch_deck changes.
  """
  def change_pitch_deck(%Scope{} = _scope, %PitchDeck{} = pitch_deck, attrs \\ %{}) do
    PitchDeck.changeset(pitch_deck, attrs)
  end

  @doc """
  Subscribe to pitch deck updates.
  """
  def subscribe_pitch_decks(_scope) do
    Phoenix.PubSub.subscribe(Jutilis.PubSub, "pitch_decks")
  end

  @doc """
  Broadcast pitch deck changes.
  """
  def broadcast_pitch_deck_change({:ok, pitch_deck}, event) do
    Phoenix.PubSub.broadcast(Jutilis.PubSub, "pitch_decks", {event, pitch_deck})
    {:ok, pitch_deck}
  end

  def broadcast_pitch_deck_change({:error, _reason} = error, _event), do: error
end
