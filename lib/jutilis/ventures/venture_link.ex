defmodule Jutilis.Ventures.VentureLink do
  use Ecto.Schema
  import Ecto.Changeset

  @categories [
    "development",
    "hosting",
    "business",
    "domains",
    "banking",
    "workspace",
    "mdm",
    "other"
  ]

  schema "venture_links" do
    field :name, :string
    field :url, :string
    field :category, :string
    field :description, :string
    field :icon, :string
    field :display_order, :integer, default: 0

    belongs_to :venture, Jutilis.Ventures.Venture

    timestamps(type: :utc_datetime)
  end

  def categories, do: @categories

  def category_labels do
    [
      {"Development", "development"},
      {"Hosting", "hosting"},
      {"Business & Legal", "business"},
      {"Domains", "domains"},
      {"Banking", "banking"},
      {"Workspace", "workspace"},
      {"MDM / Device Management", "mdm"},
      {"Other", "other"}
    ]
  end

  def category_icons do
    %{
      "development" => "code-bracket",
      "hosting" => "server",
      "business" => "building-office",
      "domains" => "globe-alt",
      "banking" => "banknotes",
      "workspace" => "computer-desktop",
      "mdm" => "device-phone-mobile",
      "other" => "link"
    }
  end

  @doc false
  def changeset(venture_link, attrs) do
    venture_link
    |> cast(attrs, [:name, :url, :category, :description, :icon, :display_order, :venture_id])
    |> validate_required([:name, :url, :category, :venture_id])
    |> validate_inclusion(:category, @categories)
    |> validate_url(:url)
  end

  defp validate_url(changeset, field) do
    validate_change(changeset, field, fn _, url ->
      case URI.parse(url) do
        %URI{scheme: scheme} when scheme in ["http", "https"] -> []
        _ -> [{field, "must be a valid URL starting with http:// or https://"}]
      end
    end)
  end
end
