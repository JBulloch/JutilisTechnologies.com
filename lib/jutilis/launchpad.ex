defmodule Jutilis.Launchpad do
  @moduledoc """
  The Launchpad context - manages SaaS tool recommendations and roadmap.
  """

  import Ecto.Query, warn: false
  alias Jutilis.Repo
  alias Jutilis.Launchpad.{Category, Tool, Templates}
  alias Jutilis.Accounts.Scope

  # =============================================================================
  # Public Queries (for displaying roadmap)
  # =============================================================================

  @doc """
  Returns the full roadmap structure: phases -> categories -> tools.
  Tools are sorted with featured items first.
  """
  def get_roadmap do
    categories =
      Category
      |> where([c], c.is_active == true)
      |> preload(
        tools:
          ^from(t in Tool,
            where: t.is_active == true,
            order_by: [desc: t.is_featured, asc: t.display_order]
          )
      )
      |> order_by([c], asc: c.display_order)
      |> Repo.all()
      |> Enum.group_by(& &1.phase)

    for phase <- Templates.phases() do
      %{
        phase: phase,
        categories: Map.get(categories, phase.id, [])
      }
    end
  end

  @doc """
  Returns all active categories grouped by phase.
  """
  def list_categories_by_phase do
    Category
    |> where([c], c.is_active == true)
    |> order_by([c], asc: c.phase, asc: c.display_order)
    |> Repo.all()
    |> Enum.group_by(& &1.phase)
  end

  @doc """
  Returns tools for a category with active status.
  """
  def list_tools_for_category(category_id) do
    Tool
    |> where([t], t.category_id == ^category_id and t.is_active == true)
    |> order_by([t], desc: t.is_featured, asc: t.display_order)
    |> Repo.all()
  end

  # =============================================================================
  # Admin Operations - Categories
  # =============================================================================

  def list_categories(%Scope{user: %{admin_flag: true}}) do
    Category
    |> order_by([c], asc: c.phase, asc: c.display_order)
    |> Repo.all()
  end

  def get_category!(%Scope{user: %{admin_flag: true}}, id) do
    Repo.get!(Category, id)
  end

  def create_category(%Scope{user: %{admin_flag: true}}, attrs) do
    %Category{}
    |> Category.changeset(attrs)
    |> Repo.insert()
  end

  def update_category(%Scope{user: %{admin_flag: true}}, %Category{} = category, attrs) do
    category
    |> Category.changeset(attrs)
    |> Repo.update()
  end

  def delete_category(%Scope{user: %{admin_flag: true}}, %Category{} = category) do
    Repo.delete(category)
  end

  def change_category(%Scope{}, %Category{} = category, attrs \\ %{}) do
    Category.changeset(category, attrs)
  end

  # =============================================================================
  # Admin Operations - Tools
  # =============================================================================

  def list_tools(%Scope{user: %{admin_flag: true}}) do
    Tool
    |> preload(:category)
    |> order_by([t], asc: t.category_id, asc: t.display_order)
    |> Repo.all()
  end

  def get_tool!(%Scope{user: %{admin_flag: true}}, id) do
    Tool
    |> Repo.get!(id)
    |> Repo.preload(:category)
  end

  def create_tool(%Scope{user: %{admin_flag: true}}, attrs) do
    %Tool{}
    |> Tool.changeset(attrs)
    |> Repo.insert()
  end

  def update_tool(%Scope{user: %{admin_flag: true}}, %Tool{} = tool, attrs) do
    tool
    |> Tool.changeset(attrs)
    |> Repo.update()
  end

  def delete_tool(%Scope{user: %{admin_flag: true}}, %Tool{} = tool) do
    Repo.delete(tool)
  end

  def change_tool(%Scope{}, %Tool{} = tool, attrs \\ %{}) do
    Tool.changeset(tool, attrs)
  end

  # =============================================================================
  # Category Options for Forms
  # =============================================================================

  def category_options(%Scope{user: %{admin_flag: true}}) do
    Category
    |> order_by([c], asc: c.phase, asc: c.display_order)
    |> Repo.all()
    |> Enum.map(fn c -> {"#{c.name} (#{c.phase})", c.id} end)
  end

  # =============================================================================
  # Seeding
  # =============================================================================

  @doc """
  Seeds the database with default categories and tools from templates.
  Safe to run multiple times - uses upsert logic.
  """
  def seed_defaults! do
    # Seed categories
    for cat_attrs <- Templates.categories() do
      case Repo.get_by(Category, slug: cat_attrs.slug) do
        nil ->
          %Category{}
          |> Category.changeset(Map.put(cat_attrs, :is_active, true))
          |> Repo.insert!()

        existing ->
          existing
      end
    end

    # Seed tools
    for tool_attrs <- Templates.tools() do
      category = Repo.get_by!(Category, slug: tool_attrs.category)

      attrs =
        tool_attrs
        |> Map.put(:category_id, category.id)
        |> Map.delete(:category)
        |> Map.put_new(:is_active, true)
        |> Map.put_new(:is_featured, false)

      case Repo.get_by(Tool, slug: attrs.slug) do
        nil ->
          %Tool{}
          |> Tool.changeset(attrs)
          |> Repo.insert!()

        existing ->
          existing
      end
    end

    :ok
  end
end
