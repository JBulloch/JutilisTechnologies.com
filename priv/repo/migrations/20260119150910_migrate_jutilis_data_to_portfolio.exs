defmodule Jutilis.Repo.Migrations.MigrateJutilisDataToPortfolio do
  use Ecto.Migration

  def up do
    # Create the Jutilis Technologies flagship portfolio
    execute """
    INSERT INTO portfolios (
      user_id,
      name,
      slug,
      custom_domain,
      tagline,
      logo_text,
      primary_color,
      secondary_color,
      hero_title,
      hero_subtitle,
      hero_description,
      hero_badge_text,
      section_config,
      about_title,
      about_description,
      investment_enabled,
      investment_title,
      investment_description,
      consulting_enabled,
      consulting_email,
      consulting_title,
      consulting_description,
      status,
      is_flagship,
      theme_color,
      meta_title,
      meta_description,
      inserted_at,
      updated_at
    )
    SELECT
      (SELECT id FROM users WHERE admin_flag = true LIMIT 1),
      'Jutilis Technologies',
      'jutilis',
      'jutilistechnologies.com',
      'SaaS Incubator',
      '{JuT}',
      'emerald',
      'amber',
      'Jutilis',
      'Technologies',
      'Building multi-tenant SaaS platforms for promising market ventures.',
      'SaaS Incubator',
      '{"hero": true, "active_ventures": true, "coming_soon": true, "acquired": true, "about": true, "investment_cta": true, "consulting": true}'::jsonb,
      'Building the Future of SaaS',
      'Jutilis Technologies is a SaaS incubator specializing in multi-tenant platforms for promising market ventures. We identify underserved markets and build scalable platforms that serve thriving communities.',
      true,
      'Partner With Us',
      'Access exclusive pitch decks and investment opportunities. Join us in building the future of multi-tenant SaaS platforms.',
      true,
      'consulting@jutilistechnologies.com',
      'Expert Technical Consulting',
      'Leverage our expertise in building scalable SaaS platforms for your own projects. We offer consulting services to help fund and grow Jutilis Technologies ventures.',
      'published',
      true,
      '#10B981',
      'Jutilis Technologies - SaaS Incubator',
      'Building multi-tenant SaaS platforms for promising market ventures. A SaaS incubator specializing in scalable platforms.',
      NOW(),
      NOW()
    WHERE EXISTS (SELECT 1 FROM users WHERE admin_flag = true)
    """

    # Update all existing ventures to belong to the Jutilis portfolio
    execute """
    UPDATE ventures
    SET portfolio_id = (SELECT id FROM portfolios WHERE slug = 'jutilis')
    WHERE portfolio_id IS NULL
    """

    # Update all existing subscribers to belong to the Jutilis portfolio
    execute """
    UPDATE subscribers
    SET portfolio_id = (SELECT id FROM portfolios WHERE slug = 'jutilis')
    WHERE portfolio_id IS NULL
    """
  end

  def down do
    # Remove portfolio associations
    execute "UPDATE ventures SET portfolio_id = NULL"
    execute "UPDATE subscribers SET portfolio_id = NULL"

    # Delete the flagship portfolio
    execute "DELETE FROM portfolios WHERE slug = 'jutilis'"
  end
end
