defmodule JutilisWeb.PitchDeckLive.Show do
  use JutilisWeb, :live_view

  alias Jutilis.PitchDecks

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@pitch_deck.title}
        <:subtitle>
          <span class={"badge badge-sm #{status_badge_class(@pitch_deck.status)}"}>
            {@pitch_deck.status}
          </span>
          <%= if @pitch_deck.venture do %>
            <span class="badge badge-outline badge-sm ml-2">
              {venture_label(@pitch_deck.venture)}
            </span>
          <% end %>
        </:subtitle>
        <:actions>
          <.button navigate={~p"/admin/pitch-decks"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button
            variant="primary"
            navigate={~p"/admin/pitch-decks/#{@pitch_deck}/edit?return_to=show"}
          >
            <.icon name="hero-pencil-square" /> Edit
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Description">{@pitch_deck.description || "No description"}</:item>
        <:item title="External URL">
          <%= if @pitch_deck.file_url do %>
            <a href={@pitch_deck.file_url} target="_blank" class="link link-primary">
              {@pitch_deck.file_url}
            </a>
          <% else %>
            <span class="text-base-content/50">Not set</span>
          <% end %>
        </:item>
        <:item title="HTML Content">
          <%= if @pitch_deck.html_content do %>
            <div class="flex items-center gap-2">
              <span class="badge badge-success badge-sm">Uploaded</span>
              <span class="text-sm text-base-content/60">
                {String.length(@pitch_deck.html_content)} characters
              </span>
            </div>
          <% else %>
            <span class="text-base-content/50">Not uploaded</span>
          <% end %>
        </:item>
        <:item title="Created">
          {Calendar.strftime(@pitch_deck.inserted_at, "%B %d, %Y at %I:%M %p")}
        </:item>
      </.list>

      <%= if @pitch_deck.html_content do %>
        <div class="mt-8">
          <h3 class="text-lg font-bold mb-4">HTML Preview</h3>
          <div class="border border-base-300 rounded-xl overflow-hidden">
            <div class="bg-base-200 px-4 py-2 flex items-center justify-between">
              <span class="text-sm text-base-content/60">Preview</span>
              <button
                type="button"
                phx-click={JS.toggle(to: "#html-preview-frame")}
                class="btn btn-ghost btn-xs"
              >
                Toggle Preview
              </button>
            </div>
            <iframe
              id="html-preview-frame"
              srcdoc={@pitch_deck.html_content}
              class="w-full h-[600px] bg-white"
              sandbox="allow-same-origin"
            />
          </div>
        </div>
      <% end %>
    </Layouts.app>
    """
  end

  defp status_badge_class("draft"), do: "badge-warning"
  defp status_badge_class("published"), do: "badge-success"
  defp status_badge_class("archived"), do: "badge-ghost"
  defp status_badge_class(_), do: ""

  defp venture_label("cards-co-op"), do: "Cards Co-op"
  defp venture_label("go-derby"), do: "Go Derby"
  defp venture_label("other"), do: "Other"
  defp venture_label(v), do: v

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    if connected?(socket) do
      PitchDecks.subscribe_pitch_decks(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Show Pitch deck")
     |> assign(:pitch_deck, PitchDecks.get_pitch_deck!(socket.assigns.current_scope, id))}
  end

  @impl true
  def handle_info(
        {:updated, %Jutilis.PitchDecks.PitchDeck{id: id} = pitch_deck},
        %{assigns: %{pitch_deck: %{id: id}}} = socket
      ) do
    {:noreply, assign(socket, :pitch_deck, pitch_deck)}
  end

  def handle_info(
        {:deleted, %Jutilis.PitchDecks.PitchDeck{id: id}},
        %{assigns: %{pitch_deck: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> put_flash(:error, "The current pitch_deck was deleted.")
     |> push_navigate(to: ~p"/admin/pitch-decks")}
  end

  def handle_info({type, %Jutilis.PitchDecks.PitchDeck{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply, socket}
  end
end
