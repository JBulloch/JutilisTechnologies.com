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
  Gets a single pitch_deck by slug for the given scope.
  Admins can see all, investors can see published ones.
  """
  def get_pitch_deck!(%Scope{user: %User{admin_flag: true}}, slug) do
    Repo.get_by!(PitchDeck, slug: slug) |> Repo.preload(:user)
  end

  def get_pitch_deck!(%Scope{user: %User{investor_flag: true}}, slug) do
    from(p in PitchDeck, where: p.slug == ^slug and p.status == "published")
    |> Repo.one!()
  end

  def get_pitch_deck!(_scope, _slug), do: raise(Ecto.NoResultsError, queryable: PitchDeck)

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

  @doc """
  Returns the list of published pitch_decks for public/investor viewing.
  """
  def list_published_pitch_decks do
    from(p in PitchDeck,
      where: p.status == "published",
      order_by: [desc: p.inserted_at]
    )
    |> Repo.all()
  end

  @doc """
  Gets a single published pitch_deck by slug for public/investor viewing.
  Returns nil if not found or not published.
  """
  def get_published_pitch_deck(slug) do
    from(p in PitchDeck,
      where: p.slug == ^slug and p.status == "published"
    )
    |> Repo.one()
  end

  @doc """
  Gets a single viewable pitch_deck by slug for direct URL access.
  Returns pitch decks with status "published" or "private".
  Private pitch decks can be viewed via direct link but don't appear in listings.
  Returns nil if not found or status is draft/archived.
  """
  def get_viewable_pitch_deck(slug) do
    from(p in PitchDeck,
      where: p.slug == ^slug and p.status in ["published", "private"]
    )
    |> Repo.one()
  end

  @doc """
  Verifies access code for a private pitch deck.
  Returns true if the pitch deck is published (no code needed),
  or if the access code matches (case-insensitive).
  Returns false if the pitch deck is private and code doesn't match.
  """
  def verify_access(pitch_deck, provided_code) do
    cond do
      pitch_deck.status == "published" ->
        true

      is_nil(pitch_deck.access_code) or pitch_deck.access_code == "" ->
        true

      is_nil(provided_code) ->
        false

      true ->
        String.downcase(pitch_deck.access_code) == String.downcase(provided_code)
    end
  end

  @doc """
  Generates a random access code for private pitch decks.
  """
  def generate_access_code do
    :crypto.strong_rand_bytes(4)
    |> Base.encode32(case: :lower, padding: false)
    |> String.slice(0, 6)
  end
end
