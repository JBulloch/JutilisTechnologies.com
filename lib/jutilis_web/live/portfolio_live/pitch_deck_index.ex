defmodule JutilisWeb.PortfolioLive.PitchDeckIndex do
  use JutilisWeb, :live_view

  alias Jutilis.Portfolios

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
      <div class="mx-auto max-w-7xl px-6 py-8 lg:px-8">
        <div class="flex items-center justify-between mb-8">
          <div>
            <.link
              navigate={~p"/portfolio"}
              class="text-sm text-base-content/60 hover:text-primary mb-2 inline-flex items-center gap-1"
            >
              <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M15 19l-7-7 7-7"
                />
              </svg>
              Back to Dashboard
            </.link>
            <h1 class="text-3xl font-black text-base-content">My Pitch Decks</h1>
            <p class="text-base-content/70 mt-1">Manage pitch decks for your ventures</p>
          </div>
          <%= if @portfolio do %>
            <.link navigate={~p"/portfolio/pitch-decks/new"} class="btn btn-primary">
              <svg class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 4v16m8-8H4"
                />
              </svg>
              New Pitch Deck
            </.link>
          <% end %>
        </div>

        <%= if @portfolio do %>
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
                d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
              />
            </svg>
            <h3 class="text-xl font-bold text-base-content mb-2">Pitch Decks Coming Soon</h3>
            <p class="text-base-content/60 mb-6 max-w-md mx-auto">
              Portfolio pitch deck management is being developed. For now, please contact support to manage your pitch decks.
            </p>
          </div>
        <% else %>
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
                d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"
              />
            </svg>
            <h3 class="text-xl font-bold text-base-content mb-2">Create Your Portfolio First</h3>
            <p class="text-base-content/60 mb-6">
              You need to create a portfolio before adding pitch decks
            </p>
            <.link navigate={~p"/portfolio/settings"} class="btn btn-primary">
              Create Portfolio
            </.link>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    portfolio = Portfolios.get_portfolio_for_user(socket.assigns.current_scope)

    {:ok,
     socket
     |> assign(:page_title, "My Pitch Decks")
     |> assign(:portfolio, portfolio)}
  end
end
