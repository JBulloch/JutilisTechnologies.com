defmodule JutilisWeb.AdminLive.VentureForm do
  use JutilisWeb, :live_view

  alias Jutilis.Ventures
  alias Jutilis.Ventures.Venture
  alias Jutilis.PitchDecks

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
      <div class="mx-auto max-w-3xl px-6 py-8 lg:px-8">
        <div class="mb-8">
          <.link
            navigate={~p"/admin/ventures"}
            class="text-sm text-base-content/60 hover:text-primary flex items-center gap-1 mb-4"
          >
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M15 19l-7-7 7-7"
              />
            </svg>
            Back to Ventures
          </.link>
          <h1 class="text-3xl font-black text-base-content">
            {@page_title}
          </h1>
        </div>

        <.form
          for={@form}
          id="venture-form"
          phx-change="validate"
          phx-submit="save"
          class="space-y-6"
        >
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6 space-y-6">
            <h2 class="text-lg font-bold text-base-content">Basic Information</h2>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div class="form-control">
                <label class="label">
                  <span class="label-text font-semibold">Name *</span>
                </label>
                <input
                  type="text"
                  name={@form[:name].name}
                  value={@form[:name].value}
                  class={"input input-bordered #{if @form[:name].errors != [], do: "input-error"}"}
                  placeholder="e.g., Cards Co-op"
                />
                <.field_errors field={@form[:name]} />
              </div>

              <div class="form-control">
                <label class="label">
                  <span class="label-text font-semibold">Slug *</span>
                </label>
                <input
                  type="text"
                  name={@form[:slug].name}
                  value={@form[:slug].value}
                  class={"input input-bordered #{if @form[:slug].errors != [], do: "input-error"}"}
                  placeholder="e.g., cards-co-op"
                />
                <label class="label">
                  <span class="label-text-alt text-base-content/60">
                    Used in URLs and for identification
                  </span>
                </label>
                <.field_errors field={@form[:slug]} />
              </div>
            </div>

            <div class="form-control">
              <label class="label">
                <span class="label-text font-semibold">Tagline</span>
              </label>
              <input
                type="text"
                name={@form[:tagline].name}
                value={@form[:tagline].value}
                class="input input-bordered"
                placeholder="e.g., Community Trading Card Marketplace"
              />
            </div>

            <div class="form-control">
              <label class="label">
                <span class="label-text font-semibold">Description</span>
              </label>
              <textarea
                name={@form[:description].name}
                class="textarea textarea-bordered h-32"
                placeholder="Describe what this venture does..."
              >{@form[:description].value}</textarea>
            </div>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div class="form-control">
                <label class="label">
                  <span class="label-text font-semibold">URL</span>
                </label>
                <input
                  type="url"
                  name={@form[:url].name}
                  value={@form[:url].value}
                  class="input input-bordered"
                  placeholder="https://example.com"
                />
              </div>

              <div class="form-control">
                <label class="label">
                  <span class="label-text font-semibold">Status</span>
                </label>
                <select name={@form[:status].name} class="select select-bordered">
                  <option value="active" selected={@form[:status].value == "active"}>Active</option>
                  <option value="coming_soon" selected={@form[:status].value == "coming_soon"}>
                    Coming Soon
                  </option>
                  <option value="acquired" selected={@form[:status].value == "acquired"}>
                    Acquired / Sold
                  </option>
                  <option value="inactive" selected={@form[:status].value == "inactive"}>
                    Inactive
                  </option>
                </select>
              </div>
            </div>

            <div class="form-control">
              <label class="label">
                <span class="label-text font-semibold">Featured Pitch Deck</span>
              </label>
              <select name={@form[:featured_pitch_deck_id].name} class="select select-bordered">
                <option value="">No pitch deck selected</option>
                <%= for pitch_deck <- @pitch_decks do %>
                  <option
                    value={pitch_deck.id}
                    selected={
                      to_string(@form[:featured_pitch_deck_id].value) == to_string(pitch_deck.id)
                    }
                  >
                    {pitch_deck.title}
                  </option>
                <% end %>
              </select>
              <label class="label">
                <span class="label-text-alt text-base-content/60">
                  The pitch deck to display on the home page for this venture
                </span>
              </label>
            </div>
            
    <!-- Acquired fields (shown conditionally) -->
            <div id="acquired-fields" class={if @form[:status].value != "acquired", do: "hidden"}>
              <div class="divider">Acquisition Details</div>
              <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
                <div class="form-control">
                  <label class="label">
                    <span class="label-text font-semibold">Acquired By</span>
                  </label>
                  <input
                    type="text"
                    name={@form[:acquired_by].name}
                    value={@form[:acquired_by].value}
                    class="input input-bordered"
                    placeholder="e.g., Acme Corp"
                  />
                </div>

                <div class="form-control">
                  <label class="label">
                    <span class="label-text font-semibold">Acquisition Date</span>
                  </label>
                  <input
                    type="date"
                    name={@form[:acquired_date].name}
                    value={@form[:acquired_date].value}
                    class="input input-bordered"
                  />
                </div>
              </div>
            </div>
          </div>

          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6 space-y-6">
            <h2 class="text-lg font-bold text-base-content">Appearance</h2>

            <div class="grid grid-cols-1 md:grid-cols-2 gap-6">
              <div class="form-control">
                <label class="label">
                  <span class="label-text font-semibold">Color</span>
                </label>
                <select name={@form[:color].name} class="select select-bordered">
                  <option value="">Select a color...</option>
                  <option value="amber" selected={@form[:color].value == "amber"}>Amber</option>
                  <option value="emerald" selected={@form[:color].value == "emerald"}>Emerald</option>
                  <option value="blue" selected={@form[:color].value == "blue"}>Blue</option>
                  <option value="purple" selected={@form[:color].value == "purple"}>Purple</option>
                  <option value="red" selected={@form[:color].value == "red"}>Red</option>
                  <option value="pink" selected={@form[:color].value == "pink"}>Pink</option>
                  <option value="teal" selected={@form[:color].value == "teal"}>Teal</option>
                </select>
              </div>

              <div class="form-control">
                <label class="label">
                  <span class="label-text font-semibold">Badge Color</span>
                </label>
                <select name={@form[:badge_color].name} class="select select-bordered">
                  <option value="">Select a badge color...</option>
                  <option value="primary" selected={@form[:badge_color].value == "primary"}>
                    Primary
                  </option>
                  <option value="secondary" selected={@form[:badge_color].value == "secondary"}>
                    Secondary
                  </option>
                  <option value="success" selected={@form[:badge_color].value == "success"}>
                    Success
                  </option>
                  <option value="warning" selected={@form[:badge_color].value == "warning"}>
                    Warning
                  </option>
                  <option value="error" selected={@form[:badge_color].value == "error"}>Error</option>
                </select>
              </div>
            </div>

            <div class="form-control">
              <label class="label">
                <span class="label-text font-semibold">Display Order</span>
              </label>
              <input
                type="number"
                name={@form[:display_order].name}
                value={@form[:display_order].value}
                class="input input-bordered w-32"
                min="0"
              />
              <label class="label">
                <span class="label-text-alt text-base-content/60">Lower numbers appear first</span>
              </label>
            </div>

            <div class="form-control">
              <label class="label">
                <span class="label-text font-semibold">Icon SVG</span>
              </label>
              <textarea
                name={@form[:icon_svg].name}
                class="textarea textarea-bordered font-mono text-sm h-32"
                placeholder="<svg>...</svg>"
              >{@form[:icon_svg].value}</textarea>
              <label class="label">
                <span class="label-text-alt text-base-content/60">
                  Paste raw SVG code for the venture icon
                </span>
              </label>
            </div>
          </div>

          <div class="flex items-center justify-end gap-4">
            <.link navigate={~p"/admin/ventures"} class="btn btn-ghost">
              Cancel
            </.link>
            <button type="submit" class="btn btn-primary" phx-disable-with="Saving...">
              Save Venture
            </button>
          </div>
        </.form>
      </div>
    </div>
    """
  end

  defp field_errors(assigns) do
    ~H"""
    <%= if @field.errors != [] do %>
      <label class="label">
        <span class="label-text-alt text-error">
          {Enum.map(@field.errors, fn {msg, _} -> msg end) |> Enum.join(", ")}
        </span>
      </label>
    <% end %>
    """
  end

  @impl true
  def mount(params, _session, socket) do
    {:ok, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    venture = %Venture{}
    pitch_decks = PitchDecks.list_pitch_decks(socket.assigns.current_scope)

    socket
    |> assign(:page_title, "New Venture")
    |> assign(:venture, venture)
    |> assign(:pitch_decks, pitch_decks)
    |> assign(:form, to_form(Ventures.change_venture(socket.assigns.current_scope, venture)))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    venture = Ventures.get_venture!(socket.assigns.current_scope, id)
    pitch_decks = PitchDecks.list_pitch_decks(socket.assigns.current_scope)

    socket
    |> assign(:page_title, "Edit #{venture.name}")
    |> assign(:venture, venture)
    |> assign(:pitch_decks, pitch_decks)
    |> assign(:form, to_form(Ventures.change_venture(socket.assigns.current_scope, venture)))
  end

  @impl true
  def handle_event("validate", %{"venture" => venture_params}, socket) do
    changeset =
      Ventures.change_venture(
        socket.assigns.current_scope,
        socket.assigns.venture,
        venture_params
      )
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, form: to_form(changeset))}
  end

  def handle_event("save", %{"venture" => venture_params}, socket) do
    save_venture(socket, socket.assigns.live_action, venture_params)
  end

  defp save_venture(socket, :new, venture_params) do
    case Ventures.create_venture(socket.assigns.current_scope, venture_params) do
      {:ok, _venture} ->
        {:noreply,
         socket
         |> put_flash(:info, "Venture created successfully")
         |> push_navigate(to: ~p"/admin/ventures")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end

  defp save_venture(socket, :edit, venture_params) do
    case Ventures.update_venture(
           socket.assigns.current_scope,
           socket.assigns.venture,
           venture_params
         ) do
      {:ok, _venture} ->
        {:noreply,
         socket
         |> put_flash(:info, "Venture updated successfully")
         |> push_navigate(to: ~p"/admin/ventures")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, form: to_form(changeset))}
    end
  end
end
