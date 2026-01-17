defmodule JutilisWeb.PitchDeckLive.Index do
  use JutilisWeb, :live_view

  alias Jutilis.PitchDecks

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Listing Pitch decks
        <:actions>
          <.button variant="primary" navigate={~p"/admin/pitch-decks/new"}>
            <.icon name="hero-plus" /> New Pitch deck
          </.button>
        </:actions>
      </.header>

      <.table
        id="pitch_decks"
        rows={@streams.pitch_decks}
        row_click={fn {_id, pitch_deck} -> JS.navigate(~p"/admin/pitch-decks/#{pitch_deck}") end}
      >
        <:col :let={{_id, pitch_deck}} label="Title">{pitch_deck.title}</:col>
        <:col :let={{_id, pitch_deck}} label="Description">{pitch_deck.description}</:col>
        <:col :let={{_id, pitch_deck}} label="File url">{pitch_deck.file_url}</:col>
        <:col :let={{_id, pitch_deck}} label="Status">{pitch_deck.status}</:col>
        <:col :let={{_id, pitch_deck}} label="Venture">{pitch_deck.venture}</:col>
        <:action :let={{_id, pitch_deck}}>
          <div class="sr-only">
            <.link navigate={~p"/admin/pitch-decks/#{pitch_deck}"}>Show</.link>
          </div>
          <.link navigate={~p"/admin/pitch-decks/#{pitch_deck}/edit"}>Edit</.link>
        </:action>
        <:action :let={{id, pitch_deck}}>
          <.link
            phx-click={JS.push("delete", value: %{id: pitch_deck.id}) |> hide("##{id}")}
            data-confirm="Are you sure?"
          >
            Delete
          </.link>
        </:action>
      </.table>
    </Layouts.app>
    """
  end

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
