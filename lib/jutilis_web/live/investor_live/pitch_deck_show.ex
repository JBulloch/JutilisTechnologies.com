defmodule JutilisWeb.InvestorLive.PitchDeckShow do
  use JutilisWeb, :live_view

  alias Jutilis.PitchDecks

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
      <%= if @requires_code and not @access_granted do %>
        <!-- Access Code Required -->
        <div class="mx-auto max-w-md px-6 py-16 lg:px-8">
          <div class="text-center mb-8">
            <div class="mx-auto h-16 w-16 rounded-full bg-info/10 flex items-center justify-center mb-4">
              <svg class="h-8 w-8 text-info" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
                />
              </svg>
            </div>
            <h1 class="text-2xl font-black text-base-content mb-2">Access Code Required</h1>
            <p class="text-base-content/60">
              This pitch deck is private. Please enter the access code to view it.
            </p>
          </div>

          <.form for={@code_form} phx-submit="verify_code" class="space-y-4">
            <div class="form-control">
              <input
                type="text"
                name="access_code"
                placeholder="Enter access code"
                class={"input input-bordered w-full text-center text-lg tracking-widest uppercase #{if @code_error, do: "input-error"}"}
                autocomplete="off"
                autofocus
              />
              <%= if @code_error do %>
                <label class="label">
                  <span class="label-text-alt text-error">{@code_error}</span>
                </label>
              <% end %>
            </div>
            <button type="submit" class="btn btn-primary w-full">
              View Pitch Deck
            </button>
          </.form>

          <div class="text-center mt-6">
            <a
              href={~p"/investors/pitch-decks"}
              class="text-sm text-base-content/60 hover:text-primary"
            >
              ← Back to Pitch Decks
            </a>
          </div>
        </div>
      <% else %>
        <!-- Pitch Deck Content -->
        <div class="mx-auto max-w-7xl px-6 py-8 lg:px-8">
          <div class="mb-4">
            <a
              href={~p"/investors/pitch-decks"}
              class="text-sm font-semibold text-base-content/70 hover:text-primary transition-colors"
            >
              ← Back to Pitch Decks
            </a>
          </div>
          <div class="mb-6">
            <div class="flex items-center gap-3 mb-4">
              <span class={"badge #{venture_badge_class(@pitch_deck.venture)}"}>
                {venture_label(@pitch_deck.venture)}
              </span>
              <%= if @pitch_deck.status == "private" do %>
                <span class="badge badge-info badge-outline">
                  <svg class="h-3 w-3 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
                    />
                  </svg>
                  Private
                </span>
              <% end %>
            </div>
            <h1 class="text-4xl font-black text-base-content mb-4">{@pitch_deck.title}</h1>
            <%= if @pitch_deck.description do %>
              <p class="text-lg text-base-content/70 max-w-3xl">
                {@pitch_deck.description}
              </p>
            <% end %>
          </div>
        </div>

        <%= if @pitch_deck.html_content do %>
          <div class="px-4 pb-8">
            <div class="rounded-2xl border-2 border-base-300 overflow-hidden bg-white">
              <iframe
                srcdoc={@pitch_deck.html_content}
                class="w-full h-[85vh]"
                sandbox="allow-same-origin"
              />
            </div>
          </div>
        <% else %>
          <%= if @pitch_deck.file_url do %>
            <div class="mx-auto max-w-7xl px-6 lg:px-8">
              <div class="text-center py-16 rounded-2xl border-2 border-base-300 bg-base-200">
                <div class="mx-auto h-24 w-24 rounded-full bg-base-100 flex items-center justify-center mb-6">
                  <svg
                    class="h-12 w-12 text-primary"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                    />
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
          <% else %>
            <div class="mx-auto max-w-7xl px-6 lg:px-8">
              <div class="text-center py-16 rounded-2xl border-2 border-base-300 bg-base-200">
                <div class="mx-auto h-24 w-24 rounded-full bg-base-100 flex items-center justify-center mb-6">
                  <svg
                    class="h-12 w-12 text-base-content/40"
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
                </div>
                <h3 class="text-xl font-bold text-base-content mb-2">Content coming soon</h3>
                <p class="text-base-content/60">This pitch deck is being prepared.</p>
              </div>
            </div>
          <% end %>
        <% end %>
      <% end %>
    </div>
    """
  end

  defp venture_badge_class(nil), do: "badge-ghost"
  defp venture_badge_class(_venture), do: "badge-primary"

  defp venture_label(nil), do: "General"

  defp venture_label(slug) do
    slug
    |> String.split("-")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  @impl true
  def mount(%{"slug" => slug} = params, _session, socket) do
    case PitchDecks.get_viewable_pitch_deck(slug) do
      nil ->
        {:ok,
         socket
         |> put_flash(:error, "Pitch deck not found")
         |> push_navigate(to: ~p"/investors/pitch-decks")}

      pitch_deck ->
        # Check if access code is required
        requires_code =
          pitch_deck.status == "private" and
            pitch_deck.access_code != nil and
            pitch_deck.access_code != ""

        # Check URL param for code (allows sharing link with code)
        url_code = params["code"]
        access_granted = not requires_code or PitchDecks.verify_access(pitch_deck, url_code)

        {:ok,
         socket
         |> assign(:page_title, pitch_deck.title)
         |> assign(:pitch_deck, pitch_deck)
         |> assign(:requires_code, requires_code)
         |> assign(:access_granted, access_granted)
         |> assign(:code_form, to_form(%{}))
         |> assign(:code_error, nil)}
    end
  end

  @impl true
  def handle_event("verify_code", %{"access_code" => code}, socket) do
    if PitchDecks.verify_access(socket.assigns.pitch_deck, code) do
      {:noreply, assign(socket, :access_granted, true)}
    else
      {:noreply, assign(socket, :code_error, "Invalid access code. Please try again.")}
    end
  end
end
