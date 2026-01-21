defmodule JutilisWeb.PortfolioLive.Dashboard do
  use JutilisWeb, :live_view

  alias Jutilis.Portfolios
  alias Jutilis.Ventures

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
      <div class="mx-auto max-w-7xl px-6 py-8 lg:px-8">
        <div class="mb-8">
          <h1 class="text-3xl font-black text-base-content">My Portfolio</h1>
          <p class="text-base-content/70 mt-1">Manage your portfolio, ventures, and pitch decks</p>
        </div>

        <%= if @portfolio do %>
          <!-- Portfolio Status -->
          <div class="mb-8 p-6 rounded-2xl border-2 border-base-300 bg-base-100">
            <div class="flex items-center justify-between">
              <div class="flex items-center gap-4">
                <div class="flex h-14 w-14 items-center justify-center rounded-xl bg-gradient-to-br from-emerald-600 to-teal-700 shadow-md">
                  <span class="text-lg font-bold text-white">{@portfolio.logo_text || "{JuT}"}</span>
                </div>
                <div>
                  <h2 class="text-xl font-bold text-base-content">{@portfolio.name}</h2>
                  <p class="text-sm text-base-content/60">
                    <%= if @portfolio.custom_domain do %>
                      {URI.parse("https://#{@portfolio.custom_domain}").host}
                    <% else %>
                      /p/{@portfolio.slug}
                    <% end %>
                  </p>
                </div>
              </div>
              <div class="flex items-center gap-3">
                <span class={status_badge_class(@portfolio.status)}>
                  {@portfolio.status}
                </span>
                <%= if @portfolio.status == "published" do %>
                  <a
                    href={portfolio_url(@portfolio)}
                    target="_blank"
                    class="btn btn-ghost btn-sm"
                  >
                    View Live
                    <svg class="h-4 w-4 ml-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                      <path
                        stroke-linecap="round"
                        stroke-linejoin="round"
                        stroke-width="2"
                        d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                      />
                    </svg>
                  </a>
                <% end %>
              </div>
            </div>
          </div>
          
    <!-- Metrics Cards -->
          <div class="grid grid-cols-1 md:grid-cols-3 gap-6 mb-12">
            <.metric_card value={@venture_count} label="Ventures" color="primary">
              <:icon>
                <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"
                  />
                </svg>
              </:icon>
            </.metric_card>

            <.metric_card value={@pitch_deck_count} label="Pitch Decks" color="success">
              <:icon>
                <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
                  />
                </svg>
              </:icon>
            </.metric_card>

            <.metric_card
              value={String.capitalize(@portfolio.status)}
              label="Portfolio Status"
              color={if @portfolio.status == "published", do: "success", else: "warning"}
              value_class="text-lg font-black text-base-content"
            >
              <:icon>
                <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 12l2 2 4-4m6 2a9 9 0 11-18 0 9 9 0 0118 0z"
                  />
                </svg>
              </:icon>
            </.metric_card>
          </div>
          
    <!-- Quick Actions -->
          <div class="mb-12">
            <h2 class="text-xl font-bold text-base-content mb-4">Quick Actions</h2>
            <div class="flex flex-wrap gap-4">
              <.link navigate={~p"/portfolio/ventures/new"} class="btn btn-primary">
                <svg class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 4v16m8-8H4"
                  />
                </svg>
                New Venture
              </.link>
              <.link navigate={~p"/portfolio/pitch-decks/new"} class="btn btn-outline">
                <svg class="h-5 w-5 mr-2" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M12 4v16m8-8H4"
                  />
                </svg>
                New Pitch Deck
              </.link>
              <.link navigate={~p"/portfolio/settings"} class="btn btn-ghost">
                Portfolio Settings
              </.link>
              <%= if @portfolio.status == "draft" do %>
                <button phx-click="publish" class="btn btn-success">
                  Publish Portfolio
                </button>
              <% else %>
                <button phx-click="unpublish" class="btn btn-ghost">
                  Unpublish
                </button>
              <% end %>
            </div>
          </div>
          
    <!-- Recent Ventures -->
          <div>
            <div class="flex items-center justify-between mb-4">
              <h2 class="text-xl font-bold text-base-content">Your Ventures</h2>
              <.link navigate={~p"/portfolio/ventures"} class="text-sm text-primary hover:underline">
                View all →
              </.link>
            </div>

            <%= if Enum.empty?(@ventures) do %>
              <div class="text-center py-12 rounded-2xl border-2 border-dashed border-base-300">
                <svg
                  class="h-12 w-12 mx-auto text-base-content/30 mb-4"
                  fill="none"
                  viewBox="0 0 24 24"
                  stroke="currentColor"
                >
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5M9 7h1m-1 4h1m4-4h1m-1 4h1m-5 10v-5a1 1 0 011-1h2a1 1 0 011 1v5m-4 0h4"
                  />
                </svg>
                <p class="text-base-content/60 font-semibold">No ventures yet</p>
                <p class="text-sm text-base-content/40 mt-1 mb-4">
                  Create your first venture to showcase on your portfolio
                </p>
                <.link navigate={~p"/portfolio/ventures/new"} class="btn btn-primary btn-sm">
                  Create Venture
                </.link>
              </div>
            <% else %>
              <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-4">
                <%= for venture <- Enum.take(@ventures, 6) do %>
                  <div class="rounded-xl border-2 border-base-300 bg-base-100 p-4 hover:border-primary transition-all">
                    <div class="flex items-center gap-3">
                      <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/20 overflow-hidden">
                        <%= if venture.icon_svg do %>
                          <div class="h-5 w-5 text-primary flex items-center justify-center [&>svg]:h-full [&>svg]:w-full">
                            {Phoenix.HTML.raw(venture.icon_svg)}
                          </div>
                        <% else %>
                          <svg
                            class="h-5 w-5 text-primary"
                            fill="none"
                            viewBox="0 0 24 24"
                            stroke="currentColor"
                          >
                            <path
                              stroke-linecap="round"
                              stroke-linejoin="round"
                              stroke-width="2"
                              d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5"
                            />
                          </svg>
                        <% end %>
                      </div>
                      <div class="flex-1 min-w-0">
                        <h3 class="font-semibold text-base-content truncate">{venture.name}</h3>
                        <span class={venture_status_badge_class(venture.status)}>
                          {venture.status}
                        </span>
                      </div>
                    </div>
                  </div>
                <% end %>
              </div>
            <% end %>
          </div>
        <% else %>
          <!-- No Portfolio - Create One -->
          <div class="text-center py-16 rounded-2xl border-2 border-dashed border-base-300">
            <svg
              class="h-16 w-16 mx-auto text-base-content/30 mb-4"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M19 11H5m14 0a2 2 0 012 2v6a2 2 0 01-2 2H5a2 2 0 01-2-2v-6a2 2 0 012-2m14 0V9a2 2 0 00-2-2M5 11V9a2 2 0 012-2m0 0V5a2 2 0 012-2h6a2 2 0 012 2v2M7 7h10"
              />
            </svg>
            <h3 class="text-xl font-bold text-base-content mb-2">Create Your Portfolio</h3>
            <p class="text-base-content/60 mb-6 max-w-md mx-auto">
              Set up your portfolio to showcase your ventures and pitch decks to investors
            </p>
            <.link navigate={~p"/portfolio/settings"} class="btn btn-primary">
              Get Started
            </.link>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  defp status_badge_class("published"), do: "badge badge-success"
  defp status_badge_class("draft"), do: "badge badge-warning"
  defp status_badge_class("suspended"), do: "badge badge-error"
  defp status_badge_class(_), do: "badge"

  defp venture_status_badge_class("active"), do: "badge badge-success badge-sm"
  defp venture_status_badge_class("coming_soon"), do: "badge badge-warning badge-sm"
  defp venture_status_badge_class("acquired"), do: "badge badge-secondary badge-sm"
  defp venture_status_badge_class(_), do: "badge badge-ghost badge-sm"

  defp portfolio_url(%{custom_domain: domain}) when not is_nil(domain) and domain != "" do
    "https://#{domain}"
  end

  defp portfolio_url(%{slug: slug}) do
    "/p/#{slug}"
  end

  @impl true
  def mount(_params, _session, socket) do
    portfolio = Portfolios.get_portfolio_for_user(socket.assigns.current_scope)

    {ventures, venture_count, pitch_deck_count} =
      if portfolio do
        ventures = Ventures.list_ventures_for_portfolio(portfolio.id)
        {ventures, length(ventures), 0}
      else
        {[], 0, 0}
      end

    {:ok,
     socket
     |> assign(:page_title, "My Portfolio")
     |> assign(:portfolio, portfolio)
     |> assign(:ventures, ventures)
     |> assign(:venture_count, venture_count)
     |> assign(:pitch_deck_count, pitch_deck_count)}
  end

  @impl true
  def handle_event("publish", _params, socket) do
    case Portfolios.publish_portfolio(socket.assigns.current_scope, socket.assigns.portfolio) do
      {:ok, portfolio} ->
        {:noreply,
         socket
         |> assign(:portfolio, portfolio)
         |> put_flash(:info, "Portfolio published successfully!")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not publish portfolio")}
    end
  end

  def handle_event("unpublish", _params, socket) do
    case Portfolios.unpublish_portfolio(socket.assigns.current_scope, socket.assigns.portfolio) do
      {:ok, portfolio} ->
        {:noreply,
         socket
         |> assign(:portfolio, portfolio)
         |> put_flash(:info, "Portfolio unpublished")}

      {:error, _changeset} ->
        {:noreply, put_flash(socket, :error, "Could not unpublish portfolio")}
    end
  end
end
