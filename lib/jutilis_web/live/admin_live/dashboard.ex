defmodule JutilisWeb.AdminLive.Dashboard do
  use JutilisWeb, :live_view

  alias Jutilis.PitchDecks
  alias Jutilis.Subscribers

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
      <div class="mx-auto max-w-7xl px-6 py-8 lg:px-8">
        <div class="mb-8">
          <h1 class="text-3xl font-black text-base-content">Admin Dashboard</h1>
          <p class="text-base-content/70 mt-1">Overview of your pitch decks and subscribers</p>
        </div>
        
    <!-- Metrics Cards -->
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-4 gap-6 mb-12">
          <!-- Published Pitch Decks -->
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
            <div class="flex items-center gap-4">
              <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-success/20">
                <svg
                  class="h-6 w-6 text-success"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
              </div>
              <div>
                <p class="text-3xl font-black text-base-content">{@published_count}</p>
                <p class="text-sm font-semibold text-base-content/60">Published</p>
              </div>
            </div>
          </div>
          
    <!-- Draft Pitch Decks -->
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
            <div class="flex items-center gap-4">
              <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-warning/20">
                <svg
                  class="h-6 w-6 text-warning"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                  />
                </svg>
              </div>
              <div>
                <p class="text-3xl font-black text-base-content">{@draft_count}</p>
                <p class="text-sm font-semibold text-base-content/60">Drafts</p>
              </div>
            </div>
          </div>
          
    <!-- Active Ventures -->
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
            <div class="flex items-center gap-4">
              <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-primary/20">
                <svg
                  class="h-6 w-6 text-primary"
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
              </div>
              <div>
                <p class="text-3xl font-black text-base-content">2</p>
                <p class="text-sm font-semibold text-base-content/60">Active Ventures</p>
              </div>
            </div>
          </div>
          
    <!-- Subscribers -->
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
            <div class="flex items-center gap-4">
              <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-secondary/20">
                <svg
                  class="h-6 w-6 text-secondary"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"
                  />
                </svg>
              </div>
              <div>
                <p class="text-3xl font-black text-base-content">{@subscriber_count}</p>
                <p class="text-sm font-semibold text-base-content/60">Subscribers</p>
              </div>
            </div>
          </div>
        </div>
        
    <!-- Quick Actions -->
        <div class="mb-12">
          <h2 class="text-xl font-bold text-base-content mb-4">Quick Actions</h2>
          <div class="flex flex-wrap gap-4">
            <a href={~p"/admin/pitch-decks/new"} class="btn btn-primary">
              <svg class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 4v16m8-8H4"
                />
              </svg>
              New Pitch Deck
            </a>
            <a href={~p"/admin/pitch-decks"} class="btn btn-ghost">
              Manage Pitch Decks
            </a>
            <a href={~p"/investors/pitch-decks"} class="btn btn-ghost" target="_blank">
              View Public Page
              <svg class="h-4 w-4 ml-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                />
              </svg>
            </a>
          </div>
        </div>
        
    <!-- Subscribers List -->
        <div>
          <div class="flex items-center justify-between mb-4">
            <h2 class="text-xl font-bold text-base-content">Recent Subscribers</h2>
            <span class="badge badge-secondary">{@subscriber_count} total</span>
          </div>

          <%= if Enum.empty?(@subscribers) do %>
            <div class="text-center py-12 rounded-2xl border-2 border-dashed border-base-300">
              <svg
                class="h-12 w-12 mx-auto text-base-content/30 mb-4"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
              >
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"
                />
              </svg>
              <p class="text-base-content/60 font-semibold">No subscribers yet</p>
              <p class="text-sm text-base-content/40 mt-1">
                Subscribers will appear here when investors sign up
              </p>
            </div>
          <% else %>
            <div class="rounded-2xl border-2 border-base-300 overflow-hidden">
              <table class="table">
                <thead class="bg-base-200">
                  <tr>
                    <th>Email</th>
                    <th>Name</th>
                    <th>Subscribed</th>
                    <th></th>
                  </tr>
                </thead>
                <tbody>
                  <%= for subscriber <- @subscribers do %>
                    <tr class="hover">
                      <td class="font-semibold">{subscriber.email}</td>
                      <td class="text-base-content/70">{subscriber.name || "-"}</td>
                      <td class="text-sm text-base-content/60">
                        {Calendar.strftime(subscriber.subscribed_at, "%b %d, %Y")}
                      </td>
                      <td>
                        <button
                          phx-click="delete_subscriber"
                          phx-value-id={subscriber.id}
                          data-confirm="Are you sure you want to remove this subscriber?"
                          class="btn btn-ghost btn-xs text-error"
                        >
                          Remove
                        </button>
                      </td>
                    </tr>
                  <% end %>
                </tbody>
              </table>
            </div>
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    pitch_decks = PitchDecks.list_pitch_decks(socket.assigns.current_scope)
    subscribers = Subscribers.list_subscribers()

    published_count = Enum.count(pitch_decks, &(&1.status == "published"))
    draft_count = Enum.count(pitch_decks, &(&1.status == "draft"))

    {:ok,
     socket
     |> assign(:page_title, "Dashboard")
     |> assign(:pitch_decks, pitch_decks)
     |> assign(:subscribers, subscribers)
     |> assign(:published_count, published_count)
     |> assign(:draft_count, draft_count)
     |> assign(:subscriber_count, length(subscribers))}
  end

  @impl true
  def handle_event("delete_subscriber", %{"id" => id}, socket) do
    subscriber = Subscribers.get_subscriber!(id)
    {:ok, _} = Subscribers.delete_subscriber(subscriber)

    subscribers = Subscribers.list_subscribers()

    {:noreply,
     socket
     |> assign(:subscribers, subscribers)
     |> assign(:subscriber_count, length(subscribers))
     |> put_flash(:info, "Subscriber removed")}
  end
end
