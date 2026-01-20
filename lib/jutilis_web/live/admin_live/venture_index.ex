defmodule JutilisWeb.AdminLive.VentureIndex do
  use JutilisWeb, :live_view

  alias Jutilis.Ventures

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
      <div class="mx-auto max-w-7xl px-6 py-8 lg:px-8">
        <div class="flex items-center justify-between mb-8">
          <div>
            <h1 class="text-3xl font-black text-base-content">Ventures</h1>
            <p class="text-base-content/70 mt-1">Manage your portfolio ventures</p>
          </div>
          <.link navigate={~p"/admin/ventures/new"} class="btn btn-primary">
            <svg class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M12 4v16m8-8H4"
              />
            </svg>
            New Venture
          </.link>
        </div>

        <%= if Enum.empty?(@ventures) do %>
          <div class="text-center py-16 rounded-2xl border-2 border-dashed border-base-300">
            <svg
              class="h-16 w-16 mx-auto text-base-content/30 mb-4"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"
              />
            </svg>
            <h3 class="text-xl font-bold text-base-content mb-2">No ventures yet</h3>
            <p class="text-base-content/60 mb-6">Create your first venture to get started</p>
            <.link navigate={~p"/admin/ventures/new"} class="btn btn-primary">
              Create Venture
            </.link>
          </div>
        <% else %>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <%= for venture <- @ventures do %>
              <div
                id={"venture-#{venture.id}"}
                class="rounded-2xl border-2 border-base-300 bg-base-100 p-6 hover:border-primary transition-all"
              >
                <.link navigate={~p"/admin/ventures/#{venture}"} class="block">
                  <div class="flex items-start justify-between mb-4">
                    <div class="flex items-center gap-3">
                      <div class={"flex h-12 w-12 items-center justify-center rounded-xl bg-#{venture.color || "primary"}-500 text-white overflow-hidden"}>
                        <%= if venture.icon_svg do %>
                          <div class="h-6 w-6 flex items-center justify-center [&>svg]:h-full [&>svg]:w-full">
                            {Phoenix.HTML.raw(venture.icon_svg)}
                          </div>
                        <% else %>
                          <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5"
                            />
                          </svg>
                        <% end %>
                      </div>
                      <div>
                        <h3 class="text-lg font-bold text-base-content">{venture.name}</h3>
                        <p class="text-sm text-base-content/60">{venture.slug}</p>
                      </div>
                    </div>
                    <span class={status_badge_class(venture.status)}>
                      {venture.status}
                    </span>
                  </div>
                </.link>

                <%= if venture.tagline do %>
                  <p class="text-sm text-base-content/70 mb-4">{venture.tagline}</p>
                <% end %>

                <%= if venture.url do %>
                  <a
                    href={venture.url}
                    target="_blank"
                    class="text-sm text-primary hover:underline flex items-center gap-1 mb-4"
                  >
                    {venture.url}
                    <svg class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                      />
                    </svg>
                  </a>
                <% end %>

                <div class="flex items-center gap-2 pt-4 border-t border-base-300">
                  <.link
                    navigate={~p"/admin/ventures/#{venture}"}
                    class="btn btn-ghost btn-sm flex-1"
                  >
                    View
                  </.link>
                  <.link
                    navigate={~p"/admin/ventures/#{venture}/edit"}
                    class="btn btn-ghost btn-sm"
                  >
                    Edit
                  </.link>
                  <button
                    phx-click="delete"
                    phx-value-id={venture.id}
                    data-confirm="Are you sure you want to delete this venture?"
                    class="btn btn-ghost btn-sm text-error"
                  >
                    Delete
                  </button>
                </div>
              </div>
            <% end %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp status_badge_class("active"), do: "badge badge-success"
  defp status_badge_class("inactive"), do: "badge badge-ghost"
  defp status_badge_class("coming_soon"), do: "badge badge-warning"
  defp status_badge_class("acquired"), do: "badge badge-secondary"
  defp status_badge_class(_), do: "badge"

  @impl true
  def mount(_params, _session, socket) do
    ventures = Ventures.list_ventures(socket.assigns.current_scope)

    {:ok,
     socket
     |> assign(:page_title, "Ventures")
     |> assign(:ventures, ventures)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    venture = Ventures.get_venture!(socket.assigns.current_scope, id)
    {:ok, _} = Ventures.delete_venture(socket.assigns.current_scope, venture)

    ventures = Ventures.list_ventures(socket.assigns.current_scope)

    {:noreply,
     socket
     |> assign(:ventures, ventures)
     |> put_flash(:info, "Venture deleted successfully")}
  end
end
