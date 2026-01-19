defmodule Jutilis.Repo.Migrations.CreatePortfolios do
  use Ecto.Migration

  def change do
    create table(:portfolios) do
      # Ownership
      add :user_id, references(:users, on_delete: :delete_all), null: false

      # Identity
      add :name, :string, null: false
      add :slug, :string, null: false
      add :custom_domain, :string

      # Branding
      add :tagline, :string
      add :logo_svg, :text
      add :logo_text, :string
      add :primary_color, :string, default: "emerald"
      add :secondary_color, :string, default: "amber"

      # Hero Section
      add :hero_title, :string
      add :hero_subtitle, :string
      add :hero_description, :text
      add :hero_badge_text, :string

      # Section Visibility (JSONB for flexibility)
      add :section_config, :map,
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
      add :about_title, :string
      add :about_description, :text

      # Investment Section
      add :investment_enabled, :boolean, default: false
      add :investment_title, :string
      add :investment_description, :text

      # Consulting Section
      add :consulting_enabled, :boolean, default: false
      add :consulting_email, :string
      add :consulting_title, :string
      add :consulting_description, :text

      # Status
      add :status, :string, default: "draft"
      add :is_flagship, :boolean, default: false

      # SEO / PWA
      add :meta_title, :string
      add :meta_description, :string
      add :theme_color, :string, default: "#10B981"

      timestamps(type: :utc_datetime)
    end

    create unique_index(:portfolios, [:slug])
    create unique_index(:portfolios, [:custom_domain], where: "custom_domain IS NOT NULL")
    create unique_index(:portfolios, [:user_id])
    create index(:portfolios, [:status])
  end
end
