defmodule Jutilis.Launchpad.Tool do
  @moduledoc """
  Schema for launchpad tools - recommended services for building a SaaS.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "launchpad_tools" do
    field :name, :string
    field :slug, :string
    field :description, :string
    field :factoid, :string
    field :url, :string
    field :affiliate_url, :string
    field :logo_url, :string
    field :icon, :string
    field :pricing_info, :string
    field :display_order, :integer, default: 0
    field :is_featured, :boolean, default: false
    field :is_active, :boolean, default: true

    belongs_to :category, Jutilis.Launchpad.Category

    timestamps(type: :utc_datetime)
  end

  def changeset(tool, attrs) do
    tool
    |> cast(attrs, [
      :name,
      :slug,
      :description,
      :factoid,
      :url,
      :affiliate_url,
      :logo_url,
      :icon,
      :pricing_info,
      :display_order,
      :is_featured,
      :is_active,
      :category_id
    ])
    |> validate_required([:name, :slug, :url, :category_id])
    |> validate_url(:url)
    |> validate_url(:affiliate_url)
    |> unique_constraint(:slug)
    |> foreign_key_constraint(:category_id)
  end

  defp validate_url(changeset, field) do
    validate_change(changeset, field, fn _, url ->
      case url do
        nil ->
          []

        "" ->
          []

        _ ->
          case URI.parse(url) do
            %URI{scheme: scheme} when scheme in ["http", "https"] -> []
            _ -> [{field, "must be a valid URL"}]
          end
      end
    end)
  end

  @doc """
  Returns the appropriate URL - affiliate if available, otherwise regular URL.
  """
  def get_link(%__MODULE__{affiliate_url: aff, url: _url})
      when is_binary(aff) and aff != "",
      do: aff

  def get_link(%__MODULE__{url: url}), do: url
end
