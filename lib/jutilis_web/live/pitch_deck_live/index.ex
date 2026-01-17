defmodule JutilisWeb.PitchDeckLive.Index do
  use JutilisWeb, :live_view

  alias Jutilis.PitchDecks

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Pitch Decks
        <:subtitle>Manage investor pitch decks for your ventures.</:subtitle>
        <:actions>
          <.button variant="primary" navigate={~p"/admin/pitch-decks/new"}>
            <.icon name="hero-plus" /> New Pitch Deck
          </.button>
        </:actions>
      </.header>

      <.table
        id="pitch_decks"
        rows={@streams.pitch_decks}
        row_click={fn {_id, pitch_deck} -> JS.navigate(~p"/admin/pitch-decks/#{pitch_deck}") end}
      >
        <:col :let={{_id, pitch_deck}} label="Title">
          <div class="font-semibold">{pitch_deck.title}</div>
          <%= if pitch_deck.description do %>
            <div class="text-sm text-base-content/60 truncate max-w-xs">{pitch_deck.description}</div>
          <% end %>
        </:col>
        <:col :let={{_id, pitch_deck}} label="Venture">
          <%= if pitch_deck.venture do %>
            <span class="badge badge-outline badge-sm">{venture_label(pitch_deck.venture)}</span>
          <% else %>
            <span class="text-base-content/40">—</span>
          <% end %>
        </:col>
        <:col :let={{_id, pitch_deck}} label="Status">
          <span class={"badge badge-sm #{status_badge_class(pitch_deck.status)}"}>
            {pitch_deck.status}
          </span>
        </:col>
        <:col :let={{_id, pitch_deck}} label="Content">
          <div class="flex gap-1">
            <%= if pitch_deck.html_content do %>
              <span class="badge badge-success badge-xs" title="HTML uploaded">HTML</span>
            <% end %>
            <%= if pitch_deck.file_url do %>
              <span class="badge badge-info badge-xs" title="External URL">URL</span>
            <% end %>
          </div>
        </:col>
        <:action :let={{_id, pitch_deck}}>
          <div class="sr-only">
            <.link navigate={~p"/admin/pitch-decks/#{pitch_deck}"}>Show</.link>
          </div>
          <.link navigate={~p"/admin/pitch-decks/#{pitch_deck}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, pitch_deck}}>
          <.link
            phx-click={JS.push("delete", value: %{id: pitch_deck.id}) |> hide("##{id}")}
            data-confirm="Are you sure you want to delete this pitch deck?"
          >
            Delete
          </.link>
        </:action>
      </.table>
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
  def mount(_params, _session, socket) do
    if connected?(socket) do
      PitchDecks.subscribe_pitch_decks(socket.assigns.current_scope)
    end

    {:ok,
     socket
     |> assign(:page_title, "Listing Pitch decks")
     |> stream(:pitch_decks, list_pitch_decks(socket.assigns.current_scope))}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    pitch_deck = PitchDecks.get_pitch_deck!(socket.assigns.current_scope, id)
    {:ok, _} = PitchDecks.delete_pitch_deck(socket.assigns.current_scope, pitch_deck)

    {:noreply, stream_delete(socket, :pitch_decks, pitch_deck)}
  end

  @impl true
  def handle_info({type, %Jutilis.PitchDecks.PitchDeck{}}, socket)
      when type in [:created, :updated, :deleted] do
    {:noreply,
     stream(socket, :pitch_decks, list_pitch_decks(socket.assigns.current_scope), reset: true)}
  end

  defp list_pitch_decks(current_scope) do
    PitchDecks.list_pitch_decks(current_scope)
  end
end
