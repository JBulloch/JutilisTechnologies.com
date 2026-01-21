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

      <%= if @pitch_deck.status in ["published", "private"] do %>
        <div class="mt-4 p-4 bg-base-200 rounded-xl space-y-4">
          <!-- Share Link Section -->
          <div class="flex items-center justify-between gap-4">
            <div class="flex-1 min-w-0">
              <p class="text-sm font-semibold text-base-content mb-1">
                <%= if @pitch_deck.status == "private" do %>
                  <span class="inline-flex items-center gap-1">
                    <svg
                      class="h-4 w-4 text-info"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                    >
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
                      />
                    </svg>
                    Private Share Link
                  </span>
                <% else %>
                  Public Link
                <% end %>
              </p>
              <code class="text-xs text-base-content/70 break-all block bg-base-300 rounded px-2 py-1">
                {@share_url}
              </code>
            </div>
            <div class="flex gap-2 shrink-0">
              <button
                type="button"
                phx-click="copy_share_link"
                class="btn btn-sm btn-outline"
              >
                <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
                  />
                </svg>
                Copy
              </button>
              <a
                href={@share_url}
                target="_blank"
                class="btn btn-sm btn-primary"
              >
                <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                  />
                </svg>
                Open
              </a>
            </div>
          </div>

          <%= if @pitch_deck.status == "private" do %>
            <!-- Access Code Section -->
            <div class="border-t border-base-300 pt-4">
              <div class="flex items-center justify-between gap-4">
                <div class="flex-1 min-w-0">
                  <p class="text-sm font-semibold text-base-content mb-1">
                    <span class="inline-flex items-center gap-1">
                      <svg
                        class="h-4 w-4 text-warning"
                        fill="none"
                        viewBox="0 0 24 24"
                        stroke="currentColor"
                      >
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"
                        />
                      </svg>
                      Access Code
                    </span>
                  </p>
                  <%= if @pitch_deck.access_code do %>
                    <code class="text-lg font-mono font-bold tracking-widest text-warning block bg-base-300 rounded px-3 py-2 uppercase">
                      {@pitch_deck.access_code}
                    </code>
                  <% else %>
                    <span class="text-sm text-base-content/50">
                      No access code set (anyone with the link can view)
                    </span>
                  <% end %>
                </div>
                <div class="flex gap-2 shrink-0">
                  <%= if @pitch_deck.access_code do %>
                    <button
                      type="button"
                      phx-click="copy_access_code"
                      class="btn btn-sm btn-outline"
                    >
                      <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                        <path
                          stroke-linecap="round"
                          stroke-linejoin="round"
                          stroke-width="2"
                          d="M8 16H6a2 2 0 01-2-2V6a2 2 0 012-2h8a2 2 0 012 2v2m-6 12h8a2 2 0 002-2v-8a2 2 0 00-2-2h-8a2 2 0 00-2 2v8a2 2 0 002 2z"
                        />
                      </svg>
                      Copy Code
                    </button>
                    <button
                      type="button"
                      phx-click="remove_access_code"
                      class="btn btn-sm btn-ghost text-error"
                      data-confirm="Remove access code? Anyone with the link will be able to view."
                    >
                      Remove
                    </button>
                  <% end %>
                  <button
                    type="button"
                    phx-click="generate_access_code"
                    class="btn btn-sm btn-warning"
                  >
                    <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
                      />
                    </svg>
                    {if @pitch_deck.access_code, do: "Regenerate", else: "Generate Code"}
                  </button>
                </div>
              </div>
              <p class="text-xs text-base-content/50 mt-2">
                <%= if @pitch_deck.access_code do %>
                  Viewers must enter this code to access the pitch deck. Share the code separately from the link for added security.
                <% else %>
                  Generate an access code to require verification before viewing this private pitch deck.
                <% end %>
              </p>
            </div>
          <% end %>
        </div>
      <% end %>

      <.list>
        <:item title="Slug">{@pitch_deck.slug}</:item>
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
  defp status_badge_class("private"), do: "badge-info"
  defp status_badge_class("archived"), do: "badge-ghost"
  defp status_badge_class(_), do: ""

  defp venture_label(nil), do: "General"

  defp venture_label(slug) do
    slug
    |> String.split("-")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(" ")
  end

  @impl true
  def mount(%{"slug" => slug}, _session, socket) do
    if connected?(socket) do
      PitchDecks.subscribe_pitch_decks(socket.assigns.current_scope)
    end

    pitch_deck = PitchDecks.get_pitch_deck!(socket.assigns.current_scope, slug)
    share_url = build_share_url(pitch_deck)

    {:ok,
     socket
     |> assign(:page_title, "Show Pitch deck")
     |> assign(:pitch_deck, pitch_deck)
     |> assign(:share_url, share_url)}
  end

  defp build_share_url(pitch_deck) do
    url(~p"/investors/pitch-decks/#{pitch_deck}")
  end

  @impl true
  def handle_info(
        {:updated, %Jutilis.PitchDecks.PitchDeck{id: id} = pitch_deck},
        %{assigns: %{pitch_deck: %{id: id}}} = socket
      ) do
    {:noreply,
     socket
     |> assign(:pitch_deck, pitch_deck)
     |> assign(:share_url, build_share_url(pitch_deck))}
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

  @impl true
  def handle_event("copy_share_link", _params, socket) do
    {:noreply,
     socket
     |> push_event("copy_to_clipboard", %{text: socket.assigns.share_url})
     |> put_flash(:info, "Link copied to clipboard")}
  end

  def handle_event("copy_access_code", _params, socket) do
    {:noreply,
     socket
     |> push_event("copy_to_clipboard", %{text: socket.assigns.pitch_deck.access_code})
     |> put_flash(:info, "Access code copied to clipboard")}
  end

  def handle_event("generate_access_code", _params, socket) do
    new_code = PitchDecks.generate_access_code()

    case PitchDecks.update_pitch_deck(
           socket.assigns.current_scope,
           socket.assigns.pitch_deck,
           %{"access_code" => new_code}
         ) do
      {:ok, updated_pitch_deck} ->
        {:noreply,
         socket
         |> assign(:pitch_deck, updated_pitch_deck)
         |> put_flash(:info, "Access code generated: #{new_code}")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to generate access code")}
    end
  end

  def handle_event("remove_access_code", _params, socket) do
    case PitchDecks.update_pitch_deck(
           socket.assigns.current_scope,
           socket.assigns.pitch_deck,
           %{"access_code" => nil}
         ) do
      {:ok, updated_pitch_deck} ->
        {:noreply,
         socket
         |> assign(:pitch_deck, updated_pitch_deck)
         |> put_flash(:info, "Access code removed")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Failed to remove access code")}
    end
  end
end
