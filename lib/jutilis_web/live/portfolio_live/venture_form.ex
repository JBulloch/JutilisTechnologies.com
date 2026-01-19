defmodule JutilisWeb.PortfolioLive.VentureForm do
  use JutilisWeb, :live_view

  alias Jutilis.Portfolios
  alias Jutilis.Ventures
  alias Jutilis.Ventures.Venture

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
      <div class="mx-auto max-w-4xl px-6 py-8 lg:px-8">
        <div class="mb-8">
          <.link navigate={~p"/portfolio/ventures"} class="text-sm text-base-content/60 hover:text-primary mb-2 inline-flex items-center gap-1">
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M15 19l-7-7 7-7" />
            </svg>
            Back to Ventures
          </.link>
          <h1 class="text-3xl font-black text-base-content">
            <%= if @live_action == :new, do: "New Venture", else: "Edit Venture" %>
          </h1>
          <p class="text-base-content/70 mt-1">
            <%= if @live_action == :new, do: "Add a new venture to your portfolio", else: "Update venture details" %>
          </p>
        </div>

        <.form for={@form} phx-submit="save" phx-change="validate" class="space-y-8">
          <!-- Basic Info -->
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
            <h2 class="text-xl font-bold text-base-content mb-6">Basic Information</h2>
            <div class="space-y-4">
              <.input
                field={@form[:name]}
                type="text"
                label="Venture Name"
                placeholder="My Startup"
                required
              />
              <.input
                field={@form[:slug]}
                type="text"
                label="URL Slug"
                placeholder="my-startup"
                required
              />
              <.input
                field={@form[:tagline]}
                type="text"
                label="Tagline"
                placeholder="A short description"
              />
              <.input
                field={@form[:description]}
                type="textarea"
                label="Description"
                placeholder="Detailed description of your venture"
                rows="4"
              />
              <.input
                field={@form[:url]}
                type="url"
                label="Website URL"
                placeholder="https://myventure.com"
              />
            </div>
          </div>

          <!-- Status -->
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
            <h2 class="text-xl font-bold text-base-content mb-6">Status</h2>
            <div class="space-y-4">
              <.input
                field={@form[:status]}
                type="select"
                label="Venture Status"
                options={[
                  {"Active", "active"},
                  {"Coming Soon", "coming_soon"},
                  {"Acquired", "acquired"},
                  {"Inactive", "inactive"}
                ]}
              />
              <.input
                field={@form[:display_order]}
                type="number"
                label="Display Order"
                placeholder="0"
              />
            </div>
          </div>

          <!-- Branding -->
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
            <h2 class="text-xl font-bold text-base-content mb-6">Branding</h2>
            <div class="space-y-4">
              <.input
                field={@form[:color]}
                type="text"
                label="Brand Color"
                placeholder="emerald"
              />
              <p class="text-sm text-base-content/60">
                Use Tailwind color names: emerald, blue, purple, amber, etc.
              </p>
              <.input
                field={@form[:badge_color]}
                type="text"
                label="Badge Color"
                placeholder="success"
              />
              <.input
                field={@form[:icon_svg]}
                type="textarea"
                label="Icon SVG"
                placeholder="<svg>...</svg>"
                rows="3"
              />
              <p class="text-sm text-base-content/60">
                Paste SVG code for a custom icon (optional)
              </p>
            </div>
          </div>

          <!-- Acquired Info (conditional) -->
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
            <h2 class="text-xl font-bold text-base-content mb-6">Acquisition Details</h2>
            <p class="text-sm text-base-content/60 mb-4">
              Fill these if the venture has been acquired
            </p>
            <div class="space-y-4">
              <.input
                field={@form[:acquired_by]}
                type="text"
                label="Acquired By"
                placeholder="Acquiring company name"
              />
              <.input
                field={@form[:acquired_date]}
                type="date"
                label="Acquisition Date"
              />
            </div>
          </div>

          <!-- Actions -->
          <div class="flex items-center justify-between pt-4">
            <.link navigate={~p"/portfolio/ventures"} class="btn btn-ghost">
              Cancel
            </.link>
            <button type="submit" class="btn btn-primary" phx-disable-with="Saving...">
              <%= if @live_action == :new, do: "Create Venture", else: "Save Changes" %>
            </button>
          </div>
        </.form>
      </div>
    </div>
    """
  end

  @impl true
  def mount(_params, _session, socket) do
    portfolio = Portfolios.get_portfolio_for_user(socket.assigns.current_scope)

    if portfolio do
      {:ok, assign(socket, :portfolio, portfolio)}
    else
      {:ok,
       socket
       |> put_flash(:error, "You need to create a portfolio first")
       |> push_navigate(to: ~p"/portfolio/settings")}
    end
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    venture = %Venture{status: "active", display_order: 0}
    changeset = Venture.changeset(venture, %{})

    socket
    |> assign(:page_title, "New Venture")
    |> assign(:venture, venture)
    |> assign(:form, to_form(changeset))
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    venture = Ventures.get_venture_for_portfolio!(socket.assigns.portfolio.id, id)
    changeset = Venture.changeset(venture, %{})

    socket
    |> assign(:page_title, "Edit #{venture.name}")
    |> assign(:venture, venture)
    |> assign(:form, to_form(changeset))
  end

  @impl true
  def handle_event("validate", %{"venture" => params}, socket) do
    changeset =
      socket.assigns.venture
      |> Venture.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"venture" => params}, socket) do
    save_venture(socket, socket.assigns.live_action, params)
  end

  defp save_venture(socket, :new, params) do
    case Ventures.create_venture_for_portfolio(socket.assigns.portfolio.id, params) do
      {:ok, _venture} ->
        {:noreply,
         socket
         |> put_flash(:info, "Venture created successfully!")
         |> push_navigate(to: ~p"/portfolio/ventures")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_venture(socket, :edit, params) do
    case Ventures.update_venture_for_portfolio(
           socket.assigns.portfolio.id,
           socket.assigns.venture,
           params
         ) do
      {:ok, _venture} ->
        {:noreply,
         socket
         |> put_flash(:info, "Venture updated successfully!")
         |> push_navigate(to: ~p"/portfolio/ventures")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}

      {:error, :unauthorized} ->
        {:noreply, put_flash(socket, :error, "You are not authorized to update this venture")}
    end
  end
end
