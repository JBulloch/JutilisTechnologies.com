defmodule JutilisWeb.AdminLive.LaunchpadTools do
  use JutilisWeb, :live_view

  alias Jutilis.Launchpad
  alias Jutilis.Launchpad.Tool

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
              <span class="text-base-content">Launchpad Tools</span>
            </div>
            <h1 class="text-3xl font-black text-base-content">Launchpad Tools</h1>
            <p class="text-base-content/70 mt-1">Manage SaaS tools and affiliate links</p>
          </div>
          <div class="flex gap-2">
            <a href={~p"/admin/launchpad/categories"} class="btn btn-ghost btn-sm">
              Categories
            </a>
            <a href={~p"/admin/launchpad/tools/new"} class="btn btn-primary btn-sm">
              <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M12 4v16m8-8H4" />
              </svg>
              Add Tool
            </a>
          </div>
        </div>

        <!-- Tools List -->
        <div class="grid gap-4">
          <%= for tool <- @tools do %>
            <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-4 flex items-center justify-between hover:border-primary/30 transition-colors">
              <div class="flex items-center gap-4">
                <div class={"flex h-12 w-12 items-center justify-center rounded-xl #{if tool.is_featured, do: "bg-warning/20 text-warning", else: "bg-base-200 text-base-content/60"}"}>
                  <%= if tool.is_featured do %>
                    <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 20 20">
                      <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
                    </svg>
                  <% else %>
                    <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M13 10V3L4 14h7v7l9-11h-7z" />
                    </svg>
                  <% end %>
                </div>
                <div>
                  <div class="flex items-center gap-2">
                    <h3 class="font-bold text-base-content">{tool.name}</h3>
                    <%= if tool.is_featured do %>
                      <span class="badge badge-warning badge-sm">Featured</span>
                    <% end %>
                    <%= if !tool.is_active do %>
                      <span class="badge badge-ghost badge-sm">Inactive</span>
                    <% end %>
                    <%= if tool.affiliate_url do %>
                      <span class="badge badge-success badge-sm">Affiliate</span>
                    <% end %>
                  </div>
                  <p class="text-sm text-base-content/60">
                    {tool.category.name} · {URI.parse(tool.url).host}
                  </p>
                </div>
              </div>
              <div class="flex items-center gap-2">
                <a href={~p"/admin/launchpad/tools/#{tool.id}/edit"} class="btn btn-ghost btn-sm">
                  Edit
                </a>
                <button
                  phx-click="delete"
                  phx-value-id={tool.id}
                  data-confirm="Delete this tool? This cannot be undone."
                  class="btn btn-ghost btn-sm text-error"
                >
                  Delete
                </button>
              </div>
            </div>
          <% end %>
        </div>
      </div>
    </div>

    <!-- Form Modal -->
    <%= if @live_action in [:new, :edit] do %>
      <div class="modal modal-open">
        <div class="modal-box max-w-2xl">
          <h3 class="font-bold text-lg mb-4">
            {if @live_action == :new, do: "Add Tool", else: "Edit Tool"}
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
                  placeholder="e.g., GitHub"
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
                  placeholder="e.g., github"
                  required
                />
              </div>
            </div>

            <div class="form-control">
              <label class="label"><span class="label-text font-semibold">Category</span></label>
              <select name={@form[:category_id].name} class="select select-bordered" required>
                <option value="">Select a category...</option>
                <%= for {label, id} <- @category_options do %>
                  <option value={id} selected={to_string(@form[:category_id].value) == to_string(id)}>
                    {label}
                  </option>
                <% end %>
              </select>
            </div>

            <div class="form-control">
              <label class="label"><span class="label-text font-semibold">URL</span></label>
              <input
                type="url"
                name={@form[:url].name}
                value={@form[:url].value}
                class={"input input-bordered #{if @form[:url].errors != [], do: "input-error"}"}
                placeholder="https://github.com"
                required
              />
            </div>

            <div class="form-control">
              <label class="label">
                <span class="label-text font-semibold">Affiliate URL</span>
                <span class="label-text-alt text-success">Your referral link</span>
              </label>
              <input
                type="url"
                name={@form[:affiliate_url].name}
                value={@form[:affiliate_url].value}
                class="input input-bordered"
                placeholder="https://github.com/?ref=yourcode"
              />
            </div>

            <div class="form-control">
              <label class="label"><span class="label-text font-semibold">Description</span></label>
              <textarea
                name={@form[:description].name}
                class="textarea textarea-bordered"
                rows="2"
                placeholder="Brief description of the tool..."
              >{@form[:description].value}</textarea>
            </div>

            <div class="form-control">
              <label class="label"><span class="label-text font-semibold">Factoid</span></label>
              <input
                type="text"
                name={@form[:factoid].name}
                value={@form[:factoid].value}
                class="input input-bordered"
                placeholder="e.g., Used by 90% of developers"
              />
            </div>

            <div class="form-control">
              <label class="label"><span class="label-text font-semibold">Pricing Info</span></label>
              <input
                type="text"
                name={@form[:pricing_info].name}
                value={@form[:pricing_info].value}
                class="input input-bordered"
                placeholder="e.g., Free tier available"
              />
            </div>

            <div class="grid grid-cols-3 gap-4">
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
                    name={@form[:is_featured].name}
                    value="true"
                    checked={@form[:is_featured].value == true or @form[:is_featured].value == "true"}
                    class="checkbox checkbox-warning"
                  />
                  <span class="label-text font-semibold">Featured</span>
                </label>
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
              <a href={~p"/admin/launchpad/tools"} class="btn btn-ghost">Cancel</a>
              <button type="submit" class="btn btn-primary">
                {if @live_action == :new, do: "Create Tool", else: "Update Tool"}
              </button>
            </div>
          </.form>
        </div>
        <a href={~p"/admin/launchpad/tools"} class="modal-backdrop"></a>
      </div>
    <% end %>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:page_title, "Launchpad Tools")
     |> assign(:tools, Launchpad.list_tools(socket.assigns.current_scope))
     |> assign(:category_options, Launchpad.category_options(socket.assigns.current_scope))}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:tool, nil)
    |> assign(:form, nil)
  end

  defp apply_action(socket, :new, _params) do
    tool = %Tool{is_active: true, is_featured: false, display_order: 0}
    changeset = Launchpad.change_tool(socket.assigns.current_scope, tool)

    socket
    |> assign(:page_title, "Add Tool")
    |> assign(:tool, tool)
    |> assign(:form, to_form(changeset))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    tool = Launchpad.get_tool!(socket.assigns.current_scope, id)
    changeset = Launchpad.change_tool(socket.assigns.current_scope, tool)

    socket
    |> assign(:page_title, "Edit #{tool.name}")
    |> assign(:tool, tool)
    |> assign(:form, to_form(changeset))
  end

  @impl true
  def handle_event("validate", %{"tool" => tool_params}, socket) do
    changeset =
      Launchpad.change_tool(socket.assigns.current_scope, socket.assigns.tool, tool_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"tool" => tool_params}, socket) do
    # Handle checkbox defaults (unchecked = not sent)
    tool_params =
      tool_params
      |> Map.put_new("is_featured", "false")
      |> Map.put_new("is_active", "false")
      |> Map.update("is_featured", false, &(&1 == "true"))
      |> Map.update("is_active", false, &(&1 == "true"))

    save_tool(socket, socket.assigns.live_action, tool_params)
  end

  def handle_event("delete", %{"id" => id}, socket) do
    tool = Launchpad.get_tool!(socket.assigns.current_scope, id)
    {:ok, _} = Launchpad.delete_tool(socket.assigns.current_scope, tool)

    {:noreply,
     socket
     |> assign(:tools, Launchpad.list_tools(socket.assigns.current_scope))
     |> put_flash(:info, "Tool deleted")}
  end

  defp save_tool(socket, :new, tool_params) do
    case Launchpad.create_tool(socket.assigns.current_scope, tool_params) do
      {:ok, _tool} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tool created")
         |> push_navigate(to: ~p"/admin/launchpad/tools")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_tool(socket, :edit, tool_params) do
    case Launchpad.update_tool(socket.assigns.current_scope, socket.assigns.tool, tool_params) do
      {:ok, _tool} ->
        {:noreply,
         socket
         |> put_flash(:info, "Tool updated")
         |> push_navigate(to: ~p"/admin/launchpad/tools")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end
end
