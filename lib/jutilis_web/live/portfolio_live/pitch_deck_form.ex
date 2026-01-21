defmodule JutilisWeb.PortfolioLive.PitchDeckForm do
  use JutilisWeb, :live_view

  alias Jutilis.Portfolios

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
      <div class="mx-auto max-w-4xl px-6 py-8 lg:px-8">
        <div class="mb-8">
          <.link
            navigate={~p"/portfolio/pitch-decks"}
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
            Back to Pitch Decks
          </.link>
          <h1 class="text-3xl font-black text-base-content">
            {if @live_action == :new, do: "New Pitch Deck", else: "Edit Pitch Deck"}
          </h1>
        </div>

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
          <h3 class="text-xl font-bold text-base-content mb-2">Coming Soon</h3>
          <p class="text-base-content/60 mb-6 max-w-md mx-auto">
            Pitch deck creation for portfolio owners is being developed. Please contact support for assistance.
          </p>
          <.link navigate={~p"/portfolio/pitch-decks"} class="btn btn-ghost">
            Go Back
          </.link>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    portfolio = Portfolios.get_portfolio_for_user(socket.assigns.current_scope)

    if portfolio do
      {:ok,
       socket
       |> assign(:page_title, "Pitch Deck")
       |> assign(:portfolio, portfolio)}
    else
      {:ok,
       socket
       |> put_flash(:error, "You need to create a portfolio first")
       |> push_navigate(to: ~p"/portfolio/settings")}
    end
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end
end
