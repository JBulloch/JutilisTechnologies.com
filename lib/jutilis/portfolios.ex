defmodule Jutilis.Portfolios do
  @moduledoc """
  The Portfolios context - manages user portfolios and their configuration.
  """

  import Ecto.Query, warn: false
  alias Jutilis.Repo
  alias Jutilis.Portfolios.Portfolio
  alias Jutilis.Accounts.Scope

  # =============================================================================
  # Public Resolution (for routing)
  # =============================================================================

  @doc """
  Gets a portfolio by custom domain.
  Returns nil if not found or not published.
  """
  def get_portfolio_by_custom_domain(nil), do: nil

  def get_portfolio_by_custom_domain(domain) when is_binary(domain) do
    domain = String.downcase(domain)

    Repo.one(
      from p in Portfolio,
        where: p.custom_domain == ^domain and p.status == "published"
    )
  end

  @doc """
  Gets a portfolio by slug.
  Returns nil if not found.
  """
  def get_portfolio_by_slug(slug) when is_binary(slug) do
    Repo.get_by(Portfolio, slug: slug)
  end

  @doc """
  Gets a published portfolio by slug.
  Returns nil if not found or not published.
  """
  def get_published_portfolio_by_slug(slug) when is_binary(slug) do
    Repo.one(
      from p in Portfolio,
        where: p.slug == ^slug and p.status == "published"
    )
  end

  @doc """
  Gets the flagship portfolio (main site portfolio).
  Returns nil if no flagship is set.
  """
  def get_flagship_portfolio do
    Repo.one(
      from p in Portfolio,
        where: p.is_flagship == true and p.status == "published"
    )
  end

  @doc """
  Checks if a slug is available for use.
  """
  def slug_available?(slug) when is_binary(slug) do
    not Repo.exists?(from p in Portfolio, where: p.slug == ^slug)
  end

  # =============================================================================
  # Owner Operations (scoped to current user)
  # =============================================================================

  @doc """
  Gets the portfolio for the current user.
  Returns nil if user has no portfolio.
  """
  def get_portfolio_for_user(%Scope{user: user}) when not is_nil(user) do
    Repo.get_by(Portfolio, user_id: user.id)
  end

  @doc """
  Creates a portfolio for the current user.
  """
  def create_portfolio(%Scope{user: user}, attrs) when not is_nil(user) do
    %Portfolio{user_id: user.id}
    |> Portfolio.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a portfolio.
  Only the owner can update their portfolio.
  """
  def update_portfolio(%Scope{user: user}, %Portfolio{user_id: user_id} = portfolio, attrs)
      when user.id == user_id do
    portfolio
    |> Portfolio.changeset(attrs)
    |> Repo.update()
  end

  def update_portfolio(%Scope{}, %Portfolio{}, _attrs) do
    {:error, :unauthorized}
  end

  @doc """
  Updates portfolio branding.
  """
  def update_portfolio_branding(
        %Scope{user: user},
        %Portfolio{user_id: user_id} = portfolio,
        attrs
      )
      when user.id == user_id do
    portfolio
    |> Portfolio.branding_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates portfolio section configuration.
  """
  def update_portfolio_sections(
        %Scope{user: user},
        %Portfolio{user_id: user_id} = portfolio,
        section_config
      )
      when user.id == user_id do
    portfolio
    |> Portfolio.sections_changeset(%{section_config: section_config})
    |> Repo.update()
  end

  @doc """
  Updates portfolio hero section.
  """
  def update_portfolio_hero(%Scope{user: user}, %Portfolio{user_id: user_id} = portfolio, attrs)
      when user.id == user_id do
    portfolio
    |> Portfolio.hero_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates portfolio about section.
  """
  def update_portfolio_about(%Scope{user: user}, %Portfolio{user_id: user_id} = portfolio, attrs)
      when user.id == user_id do
    portfolio
    |> Portfolio.about_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates portfolio investment section.
  """
  def update_portfolio_investment(
        %Scope{user: user},
        %Portfolio{user_id: user_id} = portfolio,
        attrs
      )
      when user.id == user_id do
    portfolio
    |> Portfolio.investment_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates portfolio consulting section.
  """
  def update_portfolio_consulting(
        %Scope{user: user},
        %Portfolio{user_id: user_id} = portfolio,
        attrs
      )
      when user.id == user_id do
    portfolio
    |> Portfolio.consulting_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates portfolio custom domain.
  """
  def update_portfolio_domain(%Scope{user: user}, %Portfolio{user_id: user_id} = portfolio, attrs)
      when user.id == user_id do
    portfolio
    |> Portfolio.domain_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Updates portfolio SEO settings.
  """
  def update_portfolio_seo(%Scope{user: user}, %Portfolio{user_id: user_id} = portfolio, attrs)
      when user.id == user_id do
    portfolio
    |> Portfolio.seo_changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Publishes a portfolio (sets status to "published").
  """
  def publish_portfolio(%Scope{user: user}, %Portfolio{user_id: user_id} = portfolio)
      when user.id == user_id do
    portfolio
    |> Portfolio.changeset(%{status: "published"})
    |> Repo.update()
  end

  @doc """
  Unpublishes a portfolio (sets status to "draft").
  """
  def unpublish_portfolio(%Scope{user: user}, %Portfolio{user_id: user_id} = portfolio)
      when user.id == user_id do
    portfolio
    |> Portfolio.changeset(%{status: "draft"})
    |> Repo.update()
  end

  # =============================================================================
  # Admin Operations (platform-wide)
  # =============================================================================

  @doc """
  Lists all portfolios (admin only).
  """
  def list_portfolios(%Scope{user: %{admin_flag: true}}) do
    Repo.all(
      from p in Portfolio,
        order_by: [desc: p.inserted_at],
        preload: [:user]
    )
  end

  def list_portfolios(%Scope{}), do: {:error, :unauthorized}

  @doc """
  Gets a portfolio by ID (admin only).
  """
  def get_portfolio!(%Scope{user: %{admin_flag: true}}, id) do
    Repo.get!(Portfolio, id)
    |> Repo.preload([:user, :ventures])
  end

  @doc """
  Suspends a portfolio (admin only).
  """
  def suspend_portfolio(%Scope{user: %{admin_flag: true}}, %Portfolio{} = portfolio) do
    portfolio
    |> Portfolio.changeset(%{status: "suspended"})
    |> Repo.update()
  end

  @doc """
  Unsuspends a portfolio (admin only).
  """
  def unsuspend_portfolio(%Scope{user: %{admin_flag: true}}, %Portfolio{} = portfolio) do
    portfolio
    |> Portfolio.changeset(%{status: "draft"})
    |> Repo.update()
  end

  @doc """
  Sets a portfolio as the flagship (admin only).
  Removes flagship status from any existing flagship.
  """
  def set_flagship(%Scope{user: %{admin_flag: true}}, %Portfolio{} = portfolio) do
    Repo.transaction(fn ->
      # Remove flagship from all portfolios
      Repo.update_all(Portfolio, set: [is_flagship: false])

      # Set this one as flagship
      portfolio
      |> Portfolio.changeset(%{is_flagship: true})
      |> Repo.update!()
    end)
  end

  # =============================================================================
  # Changesets (for forms)
  # =============================================================================

  @doc """
  Returns a changeset for tracking portfolio changes.
  """
  def change_portfolio(%Scope{}, %Portfolio{} = portfolio, attrs \\ %{}) do
    Portfolio.changeset(portfolio, attrs)
  end

  @doc """
  Returns a changeset for branding changes.
  """
  def change_portfolio_branding(%Scope{}, %Portfolio{} = portfolio, attrs \\ %{}) do
    Portfolio.branding_changeset(portfolio, attrs)
  end
end
