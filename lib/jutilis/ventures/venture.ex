defmodule Jutilis.Ventures.Venture do
  use Ecto.Schema
  import Ecto.Changeset

  schema "ventures" do
    field :name, :string
    field :slug, :string
    field :tagline, :string
    field :description, :string
    field :url, :string
    field :status, :string, default: "active"
    field :icon_svg, :string
    field :color, :string
    field :badge_color, :string
    field :display_order, :integer, default: 0

    has_many :pitch_decks, Jutilis.PitchDecks.PitchDeck, foreign_key: :venture_id
    has_many :links, Jutilis.Ventures.VentureLink

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(venture, attrs) do
    venture
    |> cast(attrs, [:name, :slug, :tagline, :description, :url, :status, :icon_svg, :color, :badge_color, :display_order])
    |> validate_required([:name, :slug])
    |> validate_inclusion(:status, ["active", "inactive", "coming_soon"])
    |> unique_constraint(:slug)
  end
end
