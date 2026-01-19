defmodule JutilisWeb.AdminLive.LaunchpadCategories do
  use JutilisWeb, :live_view

  alias Jutilis.Launchpad
  alias Jutilis.Launchpad.Category

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
      <div class="mx-auto max-w-7xl px-6 py-8 lg:px-8">
        <!-- Header -->
        <div class="flex items-center justify-between mb-8">
          <div>
            <div class="flex items-center gap-2 text-sm text-base-content/60 mb-2">
              <a href={~p"/admin/dashboard"} class="hover:text-primary transition-colors">Admin</a>
              <span>/</span>
              <span class="text-base-content">Launchpad Categories</span>
            </div>
            <h1 class="text-3xl font-black text-base-content">Launchpad Categories</h1>
            <p class="text-base-content/70 mt-1">Manage SaaS roadmap categories</p>
          </div>
          <div class="flex gap-2">
            <a href={~p"/admin/launchpad/tools"} class="btn btn-ghost btn-sm">
              Tools
            </a>
            <a href={~p"/admin/launchpad/categories/new"} class="btn btn-primary btn-sm">
              <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
              </svg>
              Add Category
            </a>
          </div>
        </div>

        <!-- Categories by Phase -->
        <%= for phase <- ["planning", "building", "maintaining"] do %>
          <div class="mb-8">
            <h2 class="text-xl font-bold text-base-content mb-4 flex items-center gap-2">
              <span class={"badge #{phase_badge_class(phase)}"}>{String.capitalize(phase)}</span>
            </h2>
            <div class="grid gap-3">
              <%= for category <- Enum.filter(@categories, & &1.phase == phase) do %>
                <div class="rounded-xl border-2 border-base-300 bg-base-100 p-4 flex items-center justify-between hover:border-primary/30 transition-colors">
                  <div class="flex items-center gap-4">
                    <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-base-200 text-base-content/60">
                      <span class="text-lg">{category.display_order}</span>
                    </div>
                    <div>
                      <div class="flex items-center gap-2">
                        <h3 class="font-bold text-base-content">{category.name}</h3>
                        <%= if !category.is_active do %>
                          <span class="badge badge-ghost badge-sm">Inactive</span>
                        <% end %>
                      </div>
                      <p class="text-sm text-base-content/60">{category.slug}</p>
                    </div>
                  </div>
                  <div class="flex items-center gap-2">
                    <a href={~p"/admin/launchpad/categories/#{category.id}/edit"} class="btn btn-ghost btn-sm">
                      Edit
                    </a>
                    <button
                      phx-click="delete"
                      phx-value-id={category.id}
                      data-confirm="Delete this category? All tools in this category will also be deleted!"
                      class="btn btn-ghost btn-sm text-error"
                    >
                      Delete
                    </button>
                  </div>
                </div>
              <% end %>
              <%= if Enum.empty?(Enum.filter(@categories, & &1.phase == phase)) do %>
                <div class="text-center py-8 text-base-content/40">
                  No categories in this phase
                </div>
              <% end %>
            </div>
          </div>
        <% end %>
      </div>
    </div>

    <!-- Form Modal -->
    <%= if @live_action in [:new, :edit] do %>
      <div class="modal modal-open">
        <div class="modal-box">
          <h3 class="font-bold text-lg mb-4">
            {if @live_action == :new, do: "Add Category", else: "Edit Category"}
          </h3>
          <.form for={@form} phx-submit="save" phx-change="validate" class="space-y-4">
            <div class="grid grid-cols-2 gap-4">
              <div class="form-control">
                <label class="label"><span class="label-text font-semibold">Name</span></label>
                <input
                  type="text"
                  name={@form[:name].name}
                  value={@form[:name].value}
                  class={"input input-bordered #{if @form[:name].errors != [], do: "input-error"}"}
                  placeholder="e.g., Hosting"
                  required
                />
              </div>
              <div class="form-control">
                <label class="label"><span class="label-text font-semibold">Slug</span></label>
                <input
                  type="text"
                  name={@form[:slug].name}
                  value={@form[:slug].value}
                  class={"input input-bordered #{if @form[:slug].errors != [], do: "input-error"}"}
                  placeholder="e.g., hosting"
                  required
                />
              </div>
            </div>

            <div class="form-control">
              <label class="label"><span class="label-text font-semibold">Phase</span></label>
              <select name={@form[:phase].name} class="select select-bordered" required>
                <option value="planning" selected={@form[:phase].value == "planning"}>Planning</option>
                <option value="building" selected={@form[:phase].value == "building"}>Building</option>
                <option value="maintaining" selected={@form[:phase].value == "maintaining"}>Maintaining</option>
              </select>
            </div>

            <div class="form-control">
              <label class="label"><span class="label-text font-semibold">Description</span></label>
              <textarea
                name={@form[:description].name}
                class="textarea textarea-bordered"
                rows="2"
                placeholder="Brief description of the category..."
              >{@form[:description].value}</textarea>
            </div>

            <div class="form-control">
              <label class="label"><span class="label-text font-semibold">Icon (optional)</span></label>
              <input
                type="text"
                name={@form[:icon].name}
                value={@form[:icon].value}
                class="input input-bordered"
                placeholder="e.g., server"
              />
            </div>

            <div class="grid grid-cols-2 gap-4">
              <div class="form-control">
                <label class="label"><span class="label-text font-semibold">Display Order</span></label>
                <input
                  type="number"
                  name={@form[:display_order].name}
                  value={@form[:display_order].value}
                  class="input input-bordered"
                />
              </div>
              <div class="form-control">
                <label class="label cursor-pointer justify-start gap-3">
                  <input
                    type="checkbox"
                    name={@form[:is_active].name}
                    value="true"
                    checked={@form[:is_active].value == true or @form[:is_active].value == "true"}
                    class="checkbox checkbox-success"
                  />
                  <span class="label-text font-semibold">Active</span>
                </label>
              </div>
            </div>

            <div class="modal-action">
              <a href={~p"/admin/launchpad/categories"} class="btn btn-ghost">Cancel</a>
              <button type="submit" class="btn btn-primary">
                {if @live_action == :new, do: "Create Category", else: "Update Category"}
              </button>
            </div>
          </.form>
        </div>
        <a href={~p"/admin/launchpad/categories"} class="modal-backdrop"></a>
      </div>
    <% end %>
    """
  end

  defp phase_badge_class("planning"), do: "badge-info"
  defp phase_badge_class("building"), do: "badge-warning"
  defp phase_badge_class("maintaining"), do: "badge-success"
  defp phase_badge_class(_), do: "badge-ghost"

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Launchpad Categories")
     |> assign(:categories, Launchpad.list_categories(socket.assigns.current_scope))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:category, nil)
    |> assign(:form, nil)
  end

  defp apply_action(socket, :new, _params) do
    category = %Category{is_active: true, display_order: 0, phase: "planning"}
    changeset = Launchpad.change_category(socket.assigns.current_scope, category)

    socket
    |> assign(:page_title, "Add Category")
    |> assign(:category, category)
    |> assign(:form, to_form(changeset))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    category = Launchpad.get_category!(socket.assigns.current_scope, id)
    changeset = Launchpad.change_category(socket.assigns.current_scope, category)

    socket
    |> assign(:page_title, "Edit #{category.name}")
    |> assign(:category, category)
    |> assign(:form, to_form(changeset))
  end

  @impl true
  def handle_event("validate", %{"category" => category_params}, socket) do
    changeset =
      Launchpad.change_category(socket.assigns.current_scope, socket.assigns.category, category_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"category" => category_params}, socket) do
    # Handle checkbox defaults
    category_params =
      category_params
      |> Map.put_new("is_active", "false")
      |> Map.update("is_active", false, &(&1 == "true"))

    save_category(socket, socket.assigns.live_action, category_params)
  end

  def handle_event("delete", %{"id" => id}, socket) do
    category = Launchpad.get_category!(socket.assigns.current_scope, id)
    {:ok, _} = Launchpad.delete_category(socket.assigns.current_scope, category)

    {:noreply,
     socket
     |> assign(:categories, Launchpad.list_categories(socket.assigns.current_scope))
     |> put_flash(:info, "Category deleted")}
  end

  defp save_category(socket, :new, category_params) do
    case Launchpad.create_category(socket.assigns.current_scope, category_params) do
      {:ok, _category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Category created")
         |> push_navigate(to: ~p"/admin/launchpad/categories")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_category(socket, :edit, category_params) do
    case Launchpad.update_category(socket.assigns.current_scope, socket.assigns.category, category_params) do
      {:ok, _category} ->
        {:noreply,
         socket
         |> put_flash(:info, "Category updated")
         |> push_navigate(to: ~p"/admin/launchpad/categories")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
