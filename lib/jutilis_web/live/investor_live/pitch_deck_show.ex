defmodule JutilisWeb.InvestorLive.PitchDeckShow do
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
              href={~p"/investors/pitch-decks"}
              class="text-sm font-semibold text-base-content/80 hover:text-primary transition-colors"
            >
              ← Back to Pitch Decks
            </a>
          </div>
        </div>
      </nav>

      <div class="mx-auto max-w-7xl px-6 py-12 lg:px-8">
        <div class="mb-8">
          <div class="flex items-center gap-3 mb-4">
            <span class={"badge #{venture_badge_class(@pitch_deck.venture)}"}>
              {venture_label(@pitch_deck.venture)}
            </span>
          </div>
          <h1 class="text-4xl font-black text-base-content mb-4">{@pitch_deck.title}</h1>
          <%= if @pitch_deck.description do %>
            <p class="text-lg text-base-content/70 max-w-3xl">
              {@pitch_deck.description}
            </p>
          <% end %>
        </div>

        <%= if @pitch_deck.html_content do %>
          <div class="rounded-2xl border-2 border-base-300 overflow-hidden bg-white">
            <iframe
              srcdoc={@pitch_deck.html_content}
              class="w-full h-[80vh]"
              sandbox="allow-same-origin"
            />
          </div>
        <% else %>
          <%= if @pitch_deck.file_url do %>
            <div class="text-center py-16 rounded-2xl border-2 border-base-300 bg-base-200">
              <div class="mx-auto h-24 w-24 rounded-full bg-base-100 flex items-center justify-center mb-6">
                <svg class="h-12 w-12 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                </svg>
              </div>
              <h3 class="text-xl font-bold text-base-content mb-4">External Pitch Deck</h3>
              <a
                href={@pitch_deck.file_url}
                target="_blank"
                rel="noopener noreferrer"
                class="inline-flex items-center gap-2 rounded-xl bg-primary px-6 py-3 text-sm font-bold text-primary-content hover:bg-primary/90 transition-all"
              >
                Open Pitch Deck
                <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14" />
                </svg>
              </a>
            </div>
          <% else %>
            <div class="text-center py-16 rounded-2xl border-2 border-base-300 bg-base-200">
              <div class="mx-auto h-24 w-24 rounded-full bg-base-100 flex items-center justify-center mb-6">
                <svg class="h-12 w-12 text-base-content/40" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z" />
                </svg>
              </div>
              <h3 class="text-xl font-bold text-base-content mb-2">Content coming soon</h3>
              <p class="text-base-content/60">This pitch deck is being prepared.</p>
            </div>
          <% end %>
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
  def mount(%{"id" => id}, _session, socket) do
    case PitchDecks.get_published_pitch_deck(id) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Pitch deck not found")
         |> push_navigate(to: ~p"/investors/pitch-decks")}

      pitch_deck ->
        {:ok,
         socket
         |> assign(:page_title, pitch_deck.title)
         |> assign(:pitch_deck, pitch_deck)}
    end
  end
end
