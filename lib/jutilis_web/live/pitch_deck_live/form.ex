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
        <:subtitle>Create and manage pitch decks for investors.</:subtitle>
      </.header>

      <.form for={@form} id="pitch_deck-form" phx-change="validate" phx-submit="save">
        <.input field={@form[:title]} type="text" label="Title" placeholder="e.g., Q1 2026 Investor Deck" />

        <.input
          field={@form[:venture]}
          type="select"
          label="Venture"
          options={venture_options()}
          prompt="Select a venture"
        />

        <.input field={@form[:description]} type="textarea" label="Description" rows="3" placeholder="Brief description of this pitch deck..." />

        <.input
          field={@form[:status]}
          type="select"
          label="Status"
          options={status_options()}
        />

        <.input field={@form[:file_url]} type="text" label="External File URL (optional)" placeholder="https://..." />

        <div class="form-control mt-4">
          <label class="label">
            <span class="label-text font-semibold">Upload HTML File</span>
          </label>
          <div
            class="border-2 border-dashed border-base-300 rounded-xl p-6 text-center hover:border-primary transition-colors"
            phx-drop-target={@uploads.html_file.ref}
          >
            <.live_file_input upload={@uploads.html_file} class="sr-only" id="html-file-input" />
            <div class="text-base-content/60">
              <svg class="h-10 w-10 mx-auto mb-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M7 16a4 4 0 01-.88-7.903A5 5 0 1115.9 6L16 6a5 5 0 011 9.9M15 13l-3-3m0 0l-3 3m3-3v12" />
              </svg>
              <p class="text-sm mb-3">Drag and drop an HTML file here</p>
              <label for="html-file-input" class="btn btn-primary btn-sm cursor-pointer">
                Select File
              </label>
              <p class="text-xs mt-3">Max size: 5MB</p>
            </div>
          </div>

          <%= for entry <- @uploads.html_file.entries do %>
            <div class="mt-2 flex items-center gap-2 p-2 bg-base-200 rounded-lg">
              <.icon name="hero-document-text" class="h-5 w-5 text-primary" />
              <span class="flex-1 text-sm">{entry.client_name}</span>
              <button type="button" phx-click="cancel-upload" phx-value-ref={entry.ref} class="btn btn-ghost btn-xs">
                <.icon name="hero-x-mark" class="h-4 w-4" />
              </button>
            </div>
            <%= for err <- upload_errors(@uploads.html_file, entry) do %>
              <p class="text-error text-sm mt-1">{error_to_string(err)}</p>
            <% end %>
          <% end %>
        </div>

        <%= if @pitch_deck.html_content do %>
          <div class="mt-4 p-4 bg-base-200 rounded-xl">
            <div class="flex items-center justify-between">
              <span class="text-sm font-semibold">Current HTML Content</span>
              <span class="badge badge-success badge-sm">Uploaded</span>
            </div>
            <p class="text-xs text-base-content/60 mt-1">
              {String.length(@pitch_deck.html_content)} characters
            </p>
          </div>
        <% end %>

        <footer class="mt-6">
          <.button phx-disable-with="Saving..." variant="primary">Save Pitch Deck</.button>
          <.button navigate={return_path(@current_scope, @return_to, @pitch_deck)}>Cancel</.button>
        </footer>
      </.form>
    </Layouts.app>
    """
  end

  defp status_options do
    [
      {"Draft", "draft"},
      {"Published", "published"},
      {"Archived", "archived"}
    ]
  end

  defp venture_options do
    [
      {"Cards Co-op", "cards-co-op"},
      {"Go Derby", "go-derby"},
      {"Other", "other"}
    ]
  end

  defp error_to_string(:too_large), do: "File is too large (max 5MB)"
  defp error_to_string(:not_accepted), do: "Only HTML files are accepted"
  defp error_to_string(:too_many_files), do: "Only one file allowed"
  defp error_to_string(err), do: "Error: #{inspect(err)}"

  @impl true
  def mount(params, _session, socket) do
    {:ok,
     socket
     |> assign(:return_to, return_to(params["return_to"]))
     |> allow_upload(:html_file,
       accept: ~w(.html .htm),
       max_entries: 1,
       max_file_size: 5_000_000
     )
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

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :html_file, ref)}
  end

  def handle_event("save", %{"pitch_deck" => pitch_deck_params}, socket) do
    # Process any uploaded HTML file
    pitch_deck_params = maybe_add_html_content(socket, pitch_deck_params)
    save_pitch_deck(socket, socket.assigns.live_action, pitch_deck_params)
  end

  defp maybe_add_html_content(socket, params) do
    case uploaded_entries(socket, :html_file) do
      {[entry], []} ->
        html_content =
          consume_uploaded_entry(socket, entry, fn %{path: path} ->
            {:ok, File.read!(path)}
          end)

        Map.put(params, "html_content", html_content)

      _ ->
        params
    end
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
