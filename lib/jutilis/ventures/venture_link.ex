defmodule Jutilis.Ventures.VentureLink do
  use Ecto.Schema
  import Ecto.Changeset

  # Categories aligned with launchpad slugs for integration
  @categories [
    # Planning phase
    "legal",
    "banking",
    "domains",
    "learning",
    # Building phase
    "planning-design",
    "code-repos",
    "workspace",
    "ai-tools",
    "hosting",
    "ci-cd",
    "email",
    "error-monitoring",
    # Maintaining phase
    "customer-support",
    "analytics",
    "marketing-ads",
    "social-media",
    "crm-email-marketing",
    # Legacy/catch-all
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
      # Planning
      {"Legal Structure", "legal"},
      {"Banking", "banking"},
      {"Domains", "domains"},
      {"Learning", "learning"},
      # Building
      {"Planning & Design", "planning-design"},
      {"Code Repos", "code-repos"},
      {"Workspace & Dev Environment", "workspace"},
      {"AI Tools", "ai-tools"},
      {"Hosting", "hosting"},
      {"CI/CD", "ci-cd"},
      {"Email (Transactional)", "email"},
      {"Error Monitoring", "error-monitoring"},
      # Maintaining
      {"Customer Support", "customer-support"},
      {"Analytics", "analytics"},
      {"Marketing & Paid Ads", "marketing-ads"},
      {"Social Media & Community", "social-media"},
      {"CRM & Email Marketing", "crm-email-marketing"},
      {"Other", "other"}
    ]
  end

  def category_icons do
    %{
      "legal" => "scale",
      "banking" => "banknotes",
      "domains" => "globe-alt",
      "learning" => "academic-cap",
      "planning-design" => "squares-2x2",
      "code-repos" => "code-bracket",
      "workspace" => "computer-desktop",
      "ai-tools" => "sparkles",
      "hosting" => "server",
      "ci-cd" => "arrow-path",
      "email" => "envelope",
      "error-monitoring" => "exclamation-triangle",
      "customer-support" => "chat-bubble-left-right",
      "analytics" => "chart-pie",
      "marketing-ads" => "megaphone",
      "social-media" => "share",
      "crm-email-marketing" => "user-group",
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
