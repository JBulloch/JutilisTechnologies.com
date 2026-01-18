defmodule Jutilis.Ventures do
  @moduledoc """
  The Ventures context.
  """

  import Ecto.Query, warn: false
  alias Jutilis.Repo

  alias Jutilis.Ventures.Venture
  alias Jutilis.Ventures.VentureLink
  alias Jutilis.Accounts.Scope
  alias Jutilis.Accounts.User

  @doc """
  Returns the list of ventures for admin users.
  """
  def list_ventures(%Scope{user: %User{admin_flag: true}}) do
    Repo.all(from v in Venture, order_by: [asc: v.display_order, asc: v.name])
  end

  def list_ventures(_scope), do: []

  @doc """
  Returns list of active ventures (public).
  """
  def list_active_ventures do
    Repo.all(
      from v in Venture,
        where: v.status == "active",
        order_by: [asc: v.display_order, asc: v.name],
        preload: [:featured_pitch_deck]
    )
  end

  @doc """
  Returns list of coming soon ventures (public).
  """
  def list_coming_soon_ventures do
    Repo.all(
      from v in Venture,
        where: v.status == "coming_soon",
        order_by: [asc: v.display_order, asc: v.name],
        preload: [:featured_pitch_deck]
    )
  end

  @doc """
  Returns list of acquired/sold ventures (public).
  """
  def list_acquired_ventures do
    Repo.all(
      from v in Venture,
        where: v.status == "acquired",
        order_by: [desc: v.acquired_date, asc: v.name],
        preload: [:featured_pitch_deck]
    )
  end

  @doc """
  Returns list of public ventures (active + coming_soon).
  """
  def list_public_ventures do
    Repo.all(
      from v in Venture,
        where: v.status in ["active", "coming_soon"],
        order_by: [asc: v.display_order, asc: v.name],
        preload: [:featured_pitch_deck]
    )
  end

  @doc """
  Returns the count of active ventures.
  """
  def count_active_ventures do
    Repo.one(from v in Venture, where: v.status == "active", select: count(v.id))
  end

  @doc """
  Returns the count of public ventures (active + coming_soon).
  """
  def count_public_ventures do
    Repo.one(from v in Venture, where: v.status in ["active", "coming_soon"], select: count(v.id))
  end

  @doc """
  Gets a single venture by id for admin users.
  """
  def get_venture!(%Scope{user: %User{admin_flag: true}}, id) do
    Repo.get!(Venture, id)
  end

  def get_venture!(_scope, _id), do: raise(Ecto.NoResultsError, queryable: Venture)

  @doc """
  Gets a venture with links preloaded.
  """
  def get_venture_with_links!(%Scope{user: %User{admin_flag: true}}, id) do
    Venture
    |> Repo.get!(id)
    |> Repo.preload(links: from(l in VentureLink, order_by: [asc: l.category, asc: l.display_order, asc: l.name]))
  end

  def get_venture_with_links!(_scope, _id), do: raise(Ecto.NoResultsError, queryable: Venture)

  @doc """
  Gets a venture by slug (public).
  """
  def get_venture_by_slug(slug) do
    Repo.get_by(Venture, slug: slug, status: "active")
  end

  @doc """
  Creates a venture.
  """
  def create_venture(%Scope{user: %User{admin_flag: true}}, attrs) do
    %Venture{}
    |> Venture.changeset(attrs)
    |> Repo.insert()
  end

  def create_venture(_scope, _attrs), do: {:error, :unauthorized}

  @doc """
  Updates a venture.
  """
  def update_venture(%Scope{user: %User{admin_flag: true}}, %Venture{} = venture, attrs) do
    venture
    |> Venture.changeset(attrs)
    |> Repo.update()
  end

  def update_venture(_scope, _venture, _attrs), do: {:error, :unauthorized}

  @doc """
  Deletes a venture.
  """
  def delete_venture(%Scope{user: %User{admin_flag: true}}, %Venture{} = venture) do
    Repo.delete(venture)
  end

  def delete_venture(_scope, _venture), do: {:error, :unauthorized}

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking venture changes.
  """
  def change_venture(%Scope{} = _scope, %Venture{} = venture, attrs \\ %{}) do
    Venture.changeset(venture, attrs)
  end

  # Venture Links

  @doc """
  Gets a single venture link.
  """
  def get_venture_link!(%Scope{user: %User{admin_flag: true}}, id) do
    Repo.get!(VentureLink, id)
  end

  def get_venture_link!(_scope, _id), do: raise(Ecto.NoResultsError, queryable: VentureLink)

  @doc """
  Creates a venture link.
  """
  def create_venture_link(%Scope{user: %User{admin_flag: true}}, attrs) do
    %VentureLink{}
    |> VentureLink.changeset(attrs)
    |> Repo.insert()
  end

  def create_venture_link(_scope, _attrs), do: {:error, :unauthorized}

  @doc """
  Updates a venture link.
  """
  def update_venture_link(%Scope{user: %User{admin_flag: true}}, %VentureLink{} = link, attrs) do
    link
    |> VentureLink.changeset(attrs)
    |> Repo.update()
  end

  def update_venture_link(_scope, _link, _attrs), do: {:error, :unauthorized}

  @doc """
  Deletes a venture link.
  """
  def delete_venture_link(%Scope{user: %User{admin_flag: true}}, %VentureLink{} = link) do
    Repo.delete(link)
  end

  def delete_venture_link(_scope, _link), do: {:error, :unauthorized}

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking venture link changes.
  """
  def change_venture_link(%Scope{} = _scope, %VentureLink{} = link, attrs \\ %{}) do
    VentureLink.changeset(link, attrs)
  end

  @doc """
  Returns links grouped by category for a venture.
  """
  def get_links_by_category(%Venture{} = venture) do
    venture.links
    |> Enum.group_by(& &1.category)
  end
end
