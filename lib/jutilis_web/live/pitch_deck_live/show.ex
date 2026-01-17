defmodule JutilisWeb.PitchDeckLive.Show do
  use JutilisWeb, :live_view

  alias Jutilis.PitchDecks

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        Pitch deck {@pitch_deck.id}
        <:subtitle>This is a pitch_deck record from your database.</:subtitle>
        <:actions>
          <.button navigate={~p"/admin/pitch-decks"}>
            <.icon name="hero-arrow-left" />
          </.button>
          <.button
            variant="primary"
            navigate={~p"/admin/pitch-decks/#{@pitch_deck}/edit?return_to=show"}
          >
            <.icon name="hero-pencil-square" /> Edit pitch_deck
          </.button>
        </:actions>
      </.header>

      <.list>
        <:item title="Title">{@pitch_deck.title}</:item>
        <:item title="Description">{@pitch_deck.description}</:item>
        <:item title="File url">{@pitch_deck.file_url}</:item>
        <:item title="Status">{@pitch_deck.status}</:item>
        <:item title="Venture">{@pitch_deck.venture}</:item>
      </.list>
    </Layouts.app>
    """
  end

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
