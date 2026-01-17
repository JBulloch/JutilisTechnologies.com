defmodule JutilisWeb.InvestorLive.PitchDeckIndex do
  use JutilisWeb, :live_view

  alias Jutilis.PitchDecks
  alias Jutilis.Subscribers
  alias Jutilis.Subscribers.Subscriber

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
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
                    <svg
                      class="h-4 w-4 transition-transform group-hover:translate-x-1"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M17 8l4 4m0 0l-4 4m4-4H3"
                      />
                    </svg>
                  </div>
                </div>
              </.link>
            <% end %>
          </div>
        <% end %>
        
    <!-- Email Subscription Section -->
        <div class="mt-16 rounded-2xl border-2 border-base-300 bg-gradient-to-br from-base-200 to-base-100 p-8 md:p-12">
          <div class="max-w-2xl mx-auto text-center">
            <h2 class="text-2xl font-bold text-base-content mb-4">Stay Updated</h2>
            <p class="text-base-content/70 mb-8">
              Join our investor mailing list to receive updates on new opportunities and portfolio news.
            </p>

            <%= if @subscribed do %>
              <div class="flex items-center justify-center gap-3 text-success">
                <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M5 13l4 4L19 7"
                  />
                </svg>
                <span class="font-semibold">Thanks for subscribing!</span>
              </div>
            <% else %>
              <.form
                for={@subscriber_form}
                phx-submit="subscribe"
                class="flex flex-col sm:flex-row gap-3 max-w-md mx-auto"
              >
                <div class="flex-1">
                  <input
                    type="email"
                    name={@subscriber_form[:email].name}
                    value={@subscriber_form[:email].value}
                    placeholder="your@email.com"
                    required
                    class="input input-bordered w-full"
                  />
                  <%= if @subscriber_form[:email].errors != [] do %>
                    <p class="text-error text-sm mt-1">
                      {Enum.map(@subscriber_form[:email].errors, fn {msg, _} -> msg end)
                      |> Enum.join(", ")}
                    </p>
                  <% end %>
                </div>
                <button type="submit" class="btn btn-primary">
                  Subscribe
                </button>
              </.form>
            <% end %>
          </div>
        </div>
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
     |> assign(:pitch_decks, pitch_decks)
     |> assign(:subscribed, false)
     |> assign(:subscriber_form, to_form(Subscribers.change_subscriber(%Subscriber{})))}
  end

  @impl true
  def handle_event("subscribe", %{"subscriber" => subscriber_params}, socket) do
    case Subscribers.create_subscriber(subscriber_params) do
      {:ok, _subscriber} ->
        {:noreply,
         socket
         |> assign(:subscribed, true)
         |> put_flash(:info, "Successfully subscribed!")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, subscriber_form: to_form(changeset))}
    end
  end
end
