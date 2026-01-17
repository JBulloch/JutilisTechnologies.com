defmodule JutilisWeb.InvestorLive.PitchDeckIndex do
  use JutilisWeb, :live_view

  alias Jutilis.PitchDecks

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
      <!-- Navigation -->
      <nav class="bg-base-100 border-b border-base-300">
        <div class="mx-auto max-w-7xl px-6 lg:px-8">
          <div class="flex h-20 items-center justify-between">
            <a href="/" class="flex items-center gap-3">
              <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-gradient-to-br from-emerald-600 to-teal-700">
                <span class="text-lg font-bold text-white">&#123;JuT&#125;</span>
              </div>
              <span class="text-xl font-bold text-base-content">Jutilis</span>
            </a>
            <a
              href="/"
              class="text-sm font-semibold text-base-content/80 hover:text-primary transition-colors"
            >
              ← Back to Home
            </a>
          </div>
        </div>
      </nav>

      <div class="mx-auto max-w-7xl px-6 py-12 lg:px-8">
        <div class="mb-12">
          <h1 class="text-4xl font-black text-base-content mb-4">Investor Pitch Decks</h1>
          <p class="text-lg text-base-content/70">
            Explore investment opportunities in our portfolio ventures.
          </p>
        </div>

        <%= if Enum.empty?(@pitch_decks) do %>
          <div class="text-center py-16">
            <div class="mx-auto h-24 w-24 rounded-full bg-base-200 flex items-center justify-center mb-6">
              <svg class="h-12 w-12 text-base-content/40" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
              </svg>
            </div>
            <h3 class="text-xl font-bold text-base-content mb-2">No pitch decks available</h3>
            <p class="text-base-content/60">Check back soon for new investment opportunities.</p>
          </div>
        <% else %>
          <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            <%= for pitch_deck <- @pitch_decks do %>
              <.link
                navigate={~p"/investors/pitch-decks/#{pitch_deck}"}
                class="block group"
              >
                <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6 hover:border-primary hover:shadow-lg transition-all">
                  <div class="flex items-start justify-between mb-4">
                    <span class={"badge badge-sm #{venture_badge_class(pitch_deck.venture)}"}>
                      {venture_label(pitch_deck.venture)}
                    </span>
                  </div>
                  <h3 class="text-xl font-bold text-base-content mb-2 group-hover:text-primary transition-colors">
                    {pitch_deck.title}
                  </h3>
                  <%= if pitch_deck.description do %>
                    <p class="text-sm text-base-content/70 line-clamp-3 mb-4">
                      {pitch_deck.description}
                    </p>
                  <% end %>
                  <div class="flex items-center gap-2 text-sm font-semibold text-primary">
                    View Pitch Deck
                    <svg class="h-4 w-4 transition-transform group-hover:translate-x-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M17 8l4 4m0 0l-4 4m4-4H3" />
                    </svg>
                  </div>
                </div>
              </.link>
            <% end %>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp venture_badge_class("cards-co-op"), do: "badge-warning"
  defp venture_badge_class("go-derby"), do: "badge-success"
  defp venture_badge_class(_), do: "badge-ghost"

  defp venture_label("cards-co-op"), do: "Cards Co-op"
  defp venture_label("go-derby"), do: "Go Derby"
  defp venture_label("other"), do: "Other"
  defp venture_label(nil), do: "General"
  defp venture_label(v), do: v

  @impl true
  def mount(_params, _session, socket) do
    pitch_decks = PitchDecks.list_published_pitch_decks()

    {:ok,
     socket
     |> assign(:page_title, "Investor Pitch Decks")
     |> assign(:pitch_decks, pitch_decks)}
  end
end
