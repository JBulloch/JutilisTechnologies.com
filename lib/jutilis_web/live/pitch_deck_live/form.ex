defmodule JutilisWeb.PitchDeckLive.Form do
  use JutilisWeb, :live_view

  alias Jutilis.PitchDecks
  alias Jutilis.PitchDecks.PitchDeck

  @impl true
  def render(assigns) do
    ~H"""
    <Layouts.app flash={@flash} current_scope={@current_scope}>
      <.header>
        {@page_title}
        <:subtitle>Use this form to manage pitch_deck records in your database.</:subtitle>
      </.header>

      <.form for={@form} id="pitch_deck-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" />
        <.input field={@form[:description]} type="textarea" label="Description" />
        <.input field={@form[:file_url]} type="text" label="File url" />
        <.input field={@form[:status]} type="text" label="Status" />
        <.input field={@form[:venture]} type="text" label="Venture" />
        <footer>
          <.button phx-disable-with="Saving..." variant="primary">Save Pitch deck</.button>
          <.button navigate={return_path(@current_scope, @return_to, @pitch_deck)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> apply_action(socket.assigns.live_action, params)}
  end

  defp return_to("show"), do: "show"
  defp return_to(_), do: "index"

  defp apply_action(socket, :edit, %{"id" => id}) do
    pitch_deck = PitchDecks.get_pitch_deck!(socket.assigns.current_scope, id)

    socket
    |> assign(:page_title, "Edit Pitch deck")
    |> assign(:pitch_deck, pitch_deck)
    |> assign(
      :form,
      to_form(PitchDecks.change_pitch_deck(socket.assigns.current_scope, pitch_deck))
    )
  end

  defp apply_action(socket, :new, _params) do
    pitch_deck = %PitchDeck{user_id: socket.assigns.current_scope.user.id}

    socket
    |> assign(:page_title, "New Pitch deck")
    |> assign(:pitch_deck, pitch_deck)
    |> assign(
      :form,
      to_form(PitchDecks.change_pitch_deck(socket.assigns.current_scope, pitch_deck))
    )
  end

  @impl true
  def handle_event("validate", %{"pitch_deck" => pitch_deck_params}, socket) do
    changeset =
      PitchDecks.change_pitch_deck(
        socket.assigns.current_scope,
        socket.assigns.pitch_deck,
        pitch_deck_params
      )

    {:noreply, assign(socket, form: to_form(changeset, action: :validate))}
  end

  def handle_event("save", %{"pitch_deck" => pitch_deck_params}, socket) do
    save_pitch_deck(socket, socket.assigns.live_action, pitch_deck_params)
  end

  defp save_pitch_deck(socket, :edit, pitch_deck_params) do
    case PitchDecks.update_pitch_deck(
           socket.assigns.current_scope,
           socket.assigns.pitch_deck,
           pitch_deck_params
         ) do
      {:ok, pitch_deck} ->
        {:noreply,
         socket
         |> put_flash(:info, "Pitch deck updated successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, pitch_deck)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_pitch_deck(socket, :new, pitch_deck_params) do
    case PitchDecks.create_pitch_deck(socket.assigns.current_scope, pitch_deck_params) do
      {:ok, pitch_deck} ->
        {:noreply,
         socket
         |> put_flash(:info, "Pitch deck created successfully")
         |> push_navigate(
           to: return_path(socket.assigns.current_scope, socket.assigns.return_to, pitch_deck)
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp return_path(_scope, "index", _pitch_deck), do: ~p"/admin/pitch-decks"
  defp return_path(_scope, "show", pitch_deck), do: ~p"/admin/pitch-decks/#{pitch_deck}"
end
