defmodule Jutilis.Launchpad.Category do
  @moduledoc """
  Schema for launchpad categories - the steps in the SaaS roadmap.
  """
  use Ecto.Schema
  import Ecto.Changeset

  @phases ["planning", "building", "maintaining"]

  schema "launchpad_categories" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :icon, :string
    field :phase, :string
    field :display_order, :integer, default: 0
    field :is_active, :boolean, default: true

    has_many :tools, Jutilis.Launchpad.Tool

    timestamps(type: :utc_datetime)
  end

  def phases, do: @phases

  def phase_labels do
    %{
      "planning" => "Planning",
      "building" => "Building",
      "maintaining" => "Maintaining"
    }
  end

  def changeset(category, attrs) do
    category
    |> cast(attrs, [:name, :slug, :description, :icon, :phase, :display_order, :is_active])
    |> validate_required([:name, :slug, :phase])
    |> validate_inclusion(:phase, @phases)
    |> unique_constraint(:slug)
  end
end
