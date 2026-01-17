defmodule Jutilis.PitchDecks.PitchDeck do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_statuses ["draft", "published", "archived"]
  @valid_ventures ["cards-co-op", "go-derby", "other"]

  schema "pitch_decks" do
    field :title, :string
    field :description, :string
    field :file_url, :string
    field :html_content, :string
    field :status, :string, default: "draft"
    field :venture, :string

    belongs_to :user, Jutilis.Accounts.User
    belongs_to :venture_record, Jutilis.Ventures.Venture, foreign_key: :venture_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pitch_deck, attrs) do
    pitch_deck
    |> cast(attrs, [:title, :description, :file_url, :html_content, :status, :venture, :venture_id, :user_id])
    |> validate_required([:title, :status, :user_id])
    |> validate_inclusion(:status, @valid_statuses)
    |> validate_length(:title, min: 3, max: 255)
    |> validate_length(:description, max: 5000)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:venture_id)
  end

  @doc """
  Returns the list of valid statuses.
  """
  def valid_statuses, do: @valid_statuses

  @doc """
  Returns the list of valid ventures.
  """
  def valid_ventures, do: @valid_ventures
end
