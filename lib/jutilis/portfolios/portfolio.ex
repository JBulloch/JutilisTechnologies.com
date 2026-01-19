defmodule Jutilis.Portfolios.Portfolio do
  use Ecto.Schema
  import Ecto.Changeset

  @statuses ["draft", "published", "suspended"]

  schema "portfolios" do
    # Identity
    field :name, :string
    field :slug, :string
    field :custom_domain, :string

    # Branding
    field :tagline, :string
    field :logo_svg, :string
    field :logo_text, :string
    field :primary_color, :string, default: "emerald"
    field :secondary_color, :string, default: "amber"

    # Hero Section
    field :hero_title, :string
    field :hero_subtitle, :string
    field :hero_description, :string
    field :hero_badge_text, :string

    # Section Visibility
    field :section_config, :map,
      default: %{
        "hero" => true,
        "active_ventures" => true,
        "coming_soon" => true,
        "acquired" => true,
        "about" => true,
        "investment_cta" => true,
        "consulting" => true
      }

    # About Section
    field :about_title, :string
    field :about_description, :string

    # Investment Section
    field :investment_enabled, :boolean, default: false
    field :investment_title, :string
    field :investment_description, :string

    # Consulting Section
    field :consulting_enabled, :boolean, default: false
    field :consulting_email, :string
    field :consulting_title, :string
    field :consulting_description, :string

    # Status
    field :status, :string, default: "draft"
    field :is_flagship, :boolean, default: false

    # SEO
    field :meta_title, :string
    field :meta_description, :string
    field :theme_color, :string, default: "#10B981"

    # Relationships
    belongs_to :user, Jutilis.Accounts.User
    has_many :ventures, Jutilis.Ventures.Venture
    has_many :subscribers, Jutilis.Subscribers.Subscriber

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(portfolio, attrs) do
    portfolio
    |> cast(attrs, [
      :name,
      :slug,
      :custom_domain,
      :tagline,
      :logo_svg,
      :logo_text,
      :primary_color,
      :secondary_color,
      :hero_title,
      :hero_subtitle,
      :hero_description,
      :hero_badge_text,
      :section_config,
      :about_title,
      :about_description,
      :investment_enabled,
      :investment_title,
      :investment_description,
      :consulting_enabled,
      :consulting_email,
      :consulting_title,
      :consulting_description,
      :status,
      :is_flagship,
      :meta_title,
      :meta_description,
      :theme_color,
      :user_id
    ])
    |> validate_required([:name, :slug, :user_id])
    |> validate_length(:name, min: 2, max: 100)
    |> validate_length(:slug, min: 2, max: 50)
    |> validate_format(:slug, ~r/^[a-z0-9-]+$/,
      message: "must contain only lowercase letters, numbers, and hyphens"
    )
    |> validate_inclusion(:status, @statuses)
    |> unique_constraint(:slug)
    |> unique_constraint(:custom_domain)
    |> unique_constraint(:user_id)
    |> validate_custom_domain()
  end

  @doc """
  Changeset for branding-only updates.
  """
  def branding_changeset(portfolio, attrs) do
    portfolio
    |> cast(attrs, [
      :tagline,
      :logo_svg,
      :logo_text,
      :primary_color,
      :secondary_color,
      :theme_color
    ])
  end

  @doc """
  Changeset for section configuration updates.
  """
  def sections_changeset(portfolio, attrs) do
    portfolio
    |> cast(attrs, [:section_config])
  end

  @doc """
  Changeset for hero section updates.
  """
  def hero_changeset(portfolio, attrs) do
    portfolio
    |> cast(attrs, [:hero_title, :hero_subtitle, :hero_description, :hero_badge_text])
  end

  @doc """
  Changeset for about section updates.
  """
  def about_changeset(portfolio, attrs) do
    portfolio
    |> cast(attrs, [:about_title, :about_description])
  end

  @doc """
  Changeset for investment section updates.
  """
  def investment_changeset(portfolio, attrs) do
    portfolio
    |> cast(attrs, [:investment_enabled, :investment_title, :investment_description])
  end

  @doc """
  Changeset for consulting section updates.
  """
  def consulting_changeset(portfolio, attrs) do
    portfolio
    |> cast(attrs, [
      :consulting_enabled,
      :consulting_email,
      :consulting_title,
      :consulting_description
    ])
    |> validate_format(:consulting_email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email")
  end

  @doc """
  Changeset for domain configuration.
  """
  def domain_changeset(portfolio, attrs) do
    portfolio
    |> cast(attrs, [:custom_domain])
    |> validate_custom_domain()
    |> unique_constraint(:custom_domain)
  end

  @doc """
  Changeset for SEO updates.
  """
  def seo_changeset(portfolio, attrs) do
    portfolio
    |> cast(attrs, [:meta_title, :meta_description])
    |> validate_length(:meta_title, max: 70)
    |> validate_length(:meta_description, max: 160)
  end

  defp validate_custom_domain(changeset) do
    case get_change(changeset, :custom_domain) do
      nil ->
        changeset

      domain ->
        if valid_domain?(domain) do
          changeset
        else
          add_error(changeset, :custom_domain, "must be a valid domain name")
        end
    end
  end

  defp valid_domain?(domain) when is_binary(domain) do
    domain
    |> String.downcase()
    |> String.match?(~r/^[a-z0-9]([a-z0-9-]*[a-z0-9])?(\.[a-z0-9]([a-z0-9-]*[a-z0-9])?)+$/)
  end

  defp valid_domain?(_), do: false

  @doc """
  Returns list of valid statuses.
  """
  def statuses, do: @statuses

  @doc """
  Checks if a section is enabled for this portfolio.

  Supports both atom and string keys for section names.
  Section names in config use string keys like "ventures", "about", "investment", "consulting".
  """
  def section_enabled?(%__MODULE__{section_config: config}, section) when is_atom(section) do
    section_enabled_by_key?(config, Atom.to_string(section))
  end

  def section_enabled?(%__MODULE__{section_config: config}, section) when is_binary(section) do
    section_enabled_by_key?(config, section)
  end

  def section_enabled?(_, _), do: true

  defp section_enabled_by_key?(config, key) do
    config = config || %{}
    # Check both the direct key and the legacy key names for backwards compatibility
    case key do
      "ventures" ->
        Map.get(config, "active_ventures", true) || Map.get(config, "ventures", true)

      "investment" ->
        Map.get(config, "investment_cta", true) || Map.get(config, "investment", true)

      other ->
        Map.get(config, other, true)
    end
  end
end
