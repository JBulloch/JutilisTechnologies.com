defmodule Jutilis.PitchDecks.PitchDeck do
  use Ecto.Schema
  import Ecto.Changeset

  @valid_statuses ["draft", "published", "private", "archived"]

  @derive {Phoenix.Param, key: :slug}

  schema "pitch_decks" do
    field :title, :string
    field :slug, :string
    field :description, :string
    field :file_url, :string
    field :html_content, :string
    field :status, :string, default: "draft"
    field :venture, :string
    field :access_code, :string

    belongs_to :user, Jutilis.Accounts.User
    belongs_to :venture_record, Jutilis.Ventures.Venture, foreign_key: :venture_id

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(pitch_deck, attrs) do
    pitch_deck
    |> cast(attrs, [
      :title,
      :slug,
      :description,
      :file_url,
      :html_content,
      :status,
      :venture,
      :venture_id,
      :user_id,
      :access_code
    ])
    |> validate_required([:title, :status, :user_id])
    |> validate_inclusion(:status, @valid_statuses)
    |> validate_length(:title, min: 3, max: 255)
    |> validate_length(:description, max: 5000)
    |> maybe_generate_slug()
    |> validate_required([:slug])
    |> unique_constraint(:slug)
    |> foreign_key_constraint(:user_id)
    |> foreign_key_constraint(:venture_id)
  end

  defp maybe_generate_slug(changeset) do
    case get_change(changeset, :slug) do
      nil ->
        case get_change(changeset, :title) do
          nil -> changeset
          title -> put_change(changeset, :slug, generate_slug(title))
        end

      _ ->
        changeset
    end
  end

  defp generate_slug(title) do
    title
    |> String.downcase()
    |> String.replace(~r/[^a-z0-9\s-]/, "")
    |> String.replace(~r/\s+/, "-")
    |> String.trim("-")
  end

  @doc """
  Returns the list of valid statuses.
  """
  def valid_statuses, do: @valid_statuses
end
