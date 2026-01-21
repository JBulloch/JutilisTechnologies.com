defmodule JutilisWeb.PortfolioLive.Settings do
  use JutilisWeb, :live_view

  alias Jutilis.Portfolios
  alias Jutilis.Portfolios.Portfolio

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
      <div class="mx-auto max-w-4xl px-6 py-8 lg:px-8">
        <div class="mb-8">
          <.link
            navigate={~p"/portfolio"}
            class="text-sm text-base-content/60 hover:text-primary mb-2 inline-flex items-center gap-1"
          >
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M15 19l-7-7 7-7"
              />
            </svg>
            Back to Dashboard
          </.link>
          <h1 class="text-3xl font-black text-base-content">Portfolio Settings</h1>
          <p class="text-base-content/70 mt-1">Configure your portfolio appearance and content</p>
        </div>

        <.form for={@form} phx-submit="save" phx-change="validate" class="space-y-8">
          <!-- General Settings -->
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
            <h2 class="text-xl font-bold text-base-content mb-6">General</h2>
            <div class="space-y-4">
              <.input
                field={@form[:name]}
                type="text"
                label="Portfolio Name"
                placeholder="My Portfolio"
                required
              />
              <.input
                field={@form[:slug]}
                type="text"
                label="URL Slug"
                placeholder="my-portfolio"
                required
              />
              <p class="text-sm text-base-content/60">
                Your portfolio will be available at:
                <code class="bg-base-200 px-2 py-1 rounded">
                  /p/{@form[:slug].value || "your-slug"}
                </code>
              </p>
              <.input
                field={@form[:tagline]}
                type="text"
                label="Tagline"
                placeholder="A short description of your portfolio"
              />
            </div>
          </div>
          
    <!-- Branding -->
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
            <h2 class="text-xl font-bold text-base-content mb-6">Branding</h2>
            <div class="space-y-4">
              <.input
                field={@form[:logo_text]}
                type="text"
                label="Logo Text"
                placeholder="{JuT}"
              />
              <p class="text-sm text-base-content/60">
                Short text displayed in the logo badge (e.g., initials or abbreviation)
              </p>
              <div class="grid grid-cols-2 gap-4">
                <.input
                  field={@form[:primary_color]}
                  type="text"
                  label="Primary Color"
                  placeholder="emerald"
                />
                <.input
                  field={@form[:secondary_color]}
                  type="text"
                  label="Secondary Color"
                  placeholder="amber"
                />
              </div>
            </div>
          </div>
          
    <!-- Hero Section -->
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
            <h2 class="text-xl font-bold text-base-content mb-6">Hero Section</h2>
            <div class="space-y-4">
              <div class="grid grid-cols-2 gap-4">
                <.input
                  field={@form[:hero_title]}
                  type="text"
                  label="Title"
                  placeholder="My Company"
                />
                <.input
                  field={@form[:hero_subtitle]}
                  type="text"
                  label="Subtitle"
                  placeholder="Technologies"
                />
              </div>
              <.input
                field={@form[:hero_description]}
                type="textarea"
                label="Description"
                placeholder="A brief description that appears in the hero section"
              />
              <.input
                field={@form[:hero_badge_text]}
                type="text"
                label="Badge Text"
                placeholder="SaaS Incubator"
              />
            </div>
          </div>
          
    <!-- About Section -->
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
            <h2 class="text-xl font-bold text-base-content mb-6">About Section</h2>
            <div class="space-y-4">
              <.input
                field={@form[:about_title]}
                type="text"
                label="Title"
                placeholder="About Us"
              />
              <.input
                field={@form[:about_description]}
                type="textarea"
                label="Description"
                placeholder="Tell visitors about your portfolio, mission, and vision"
                rows="4"
              />
            </div>
          </div>
          
    <!-- Consulting Section -->
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
            <h2 class="text-xl font-bold text-base-content mb-6">Consulting Section</h2>
            <div class="space-y-4">
              <.input
                field={@form[:consulting_enabled]}
                type="checkbox"
                label="Enable consulting section"
              />
              <.input
                field={@form[:consulting_title]}
                type="text"
                label="Title"
                placeholder="Need Expert Help?"
              />
              <.input
                field={@form[:consulting_description]}
                type="textarea"
                label="Description"
                placeholder="Describe your consulting services"
              />
              <.input
                field={@form[:consulting_email]}
                type="email"
                label="Contact Email"
                placeholder="consulting@example.com"
              />
            </div>
          </div>
          
    <!-- Custom Domain -->
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
            <h2 class="text-xl font-bold text-base-content mb-6">Custom Domain</h2>
            <div class="space-y-4">
              <.input
                field={@form[:custom_domain]}
                type="text"
                label="Custom Domain"
                placeholder="portfolio.example.com"
              />
              <p class="text-sm text-base-content/60">
                Point your domain's DNS to our servers and enter it here. Leave empty to use the default URL.
              </p>
            </div>
          </div>
          
    <!-- SEO -->
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
            <h2 class="text-xl font-bold text-base-content mb-6">SEO</h2>
            <div class="space-y-4">
              <.input
                field={@form[:meta_title]}
                type="text"
                label="Meta Title"
                placeholder="My Portfolio - Technology Ventures"
              />
              <.input
                field={@form[:meta_description]}
                type="textarea"
                label="Meta Description"
                placeholder="Description for search engines"
                rows="2"
              />
              <.input
                field={@form[:theme_color]}
                type="text"
                label="Theme Color"
                placeholder="#10B981"
              />
            </div>
          </div>
          
    <!-- Actions -->
          <div class="flex items-center justify-between pt-4">
            <.link navigate={~p"/portfolio"} class="btn btn-ghost">
              Cancel
            </.link>
            <button type="submit" class="btn btn-primary" phx-disable-with="Saving...">
              Save Changes
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

    portfolio =
      if portfolio do
        portfolio
      else
        %Portfolio{status: "draft"}
      end

    changeset = Portfolios.change_portfolio(socket.assigns.current_scope, portfolio)

    {:ok,
     socket
     |> assign(:page_title, "Portfolio Settings")
     |> assign(:portfolio, portfolio)
     |> assign(:form, to_form(changeset))}
  end

  @impl true
  def handle_event("validate", %{"portfolio" => params}, socket) do
    changeset =
      socket.assigns.portfolio
      |> Portfolio.changeset(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :form, to_form(changeset))}
  end

  def handle_event("save", %{"portfolio" => params}, socket) do
    save_portfolio(socket, socket.assigns.portfolio, params)
  end

  defp save_portfolio(socket, %Portfolio{id: nil}, params) do
    case Portfolios.create_portfolio(socket.assigns.current_scope, params) do
      {:ok, portfolio} ->
        {:noreply,
         socket
         |> assign(:portfolio, portfolio)
         |> assign(
           :form,
           to_form(Portfolios.change_portfolio(socket.assigns.current_scope, portfolio))
         )
         |> put_flash(:info, "Portfolio created successfully!")
         |> push_navigate(to: ~p"/portfolio")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  defp save_portfolio(socket, portfolio, params) do
    case Portfolios.update_portfolio(socket.assigns.current_scope, portfolio, params) do
      {:ok, portfolio} ->
        {:noreply,
         socket
         |> assign(:portfolio, portfolio)
         |> assign(
           :form,
           to_form(Portfolios.change_portfolio(socket.assigns.current_scope, portfolio))
         )
         |> put_flash(:info, "Portfolio updated successfully!")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}

      {:error, :unauthorized} ->
        {:noreply, put_flash(socket, :error, "You are not authorized to update this portfolio")}
    end
  end
end
