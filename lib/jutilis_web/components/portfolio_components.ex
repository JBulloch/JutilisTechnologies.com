defmodule JutilisWeb.PortfolioComponents do
  @moduledoc """
  Reusable components for portfolio pages.

  These components are parameterized to work with any portfolio configuration,
  enabling the portfolio-as-a-service functionality.
  """
  use Phoenix.Component
  use JutilisWeb, :verified_routes
  alias Jutilis.Portfolios.Portfolio

  # ============================================================================
  # Hero Section
  # ============================================================================

  attr :portfolio, Portfolio, required: true
  attr :venture_count, :integer, default: 0

  def hero_section(assigns) do
    ~H"""
    <div class="relative bg-base-100 px-6 py-16 sm:py-24 lg:py-32">
      <div class="mx-auto max-w-7xl">
        <div class="grid grid-cols-1 lg:grid-cols-2 gap-12 lg:gap-16 items-center">
          <div>
            <%= if @portfolio.hero_badge_text do %>
              <div class="mb-6 inline-flex items-center gap-2 rounded-full border-2 border-primary bg-primary/10 px-4 py-2 text-xs sm:text-sm font-bold text-primary uppercase tracking-wider">
                <svg class="h-4 w-4" fill="currentColor" viewBox="0 0 20 20">
                  <path d="M10.394 2.08a1 1 0 00-.788 0l-7 3a1 1 0 000 1.84L5.25 8.051a.999.999 0 01.356-.257l4-1.714a1 1 0 11.788 1.838L7.667 9.088l1.94.831a1 1 0 00.787 0l7-3a1 1 0 000-1.838l-7-3zM3.31 9.397L5 10.12v4.102a8.969 8.969 0 00-1.05-.174 1 1 0 01-.89-.89 11.115 11.115 0 01.25-3.762zM9.3 16.573A9.026 9.026 0 007 14.935v-3.957l1.818.78a3 3 0 002.364 0l5.508-2.361a11.026 11.026 0 01.25 3.762 1 1 0 01-.89.89 8.968 8.968 0 00-5.35 2.524 1 1 0 01-1.4 0zM6 18a1 1 0 001-1v-2.065a8.935 8.935 0 00-2-.712V17a1 1 0 001 1z" />
                </svg>
                {@portfolio.hero_badge_text}
              </div>
            <% end %>

            <h1 class="text-4xl font-black tracking-tight text-base-content sm:text-5xl lg:text-6xl xl:text-7xl mb-6 leading-tight">
              {@portfolio.hero_title || @portfolio.name}<br />
              <%= if @portfolio.hero_subtitle do %>
                <span class="text-primary">{@portfolio.hero_subtitle}</span>
              <% end %>
            </h1>

            <%= if @portfolio.hero_description do %>
              <p class="text-lg sm:text-xl text-base-content/80 leading-relaxed mb-8 max-w-xl">
                {@portfolio.hero_description}
              </p>
            <% end %>

            <div class="flex flex-col sm:flex-row gap-4">
              <%= if section_enabled?(@portfolio, :ventures) do %>
                <a
                  href="#ventures"
                  class="rounded-xl bg-primary px-6 sm:px-8 py-3 sm:py-4 text-sm sm:text-base font-bold text-primary-content hover:bg-primary/90 transition-all hover:shadow-xl text-center"
                >
                  View Our Ventures
                </a>
              <% end %>
              <%= if section_enabled?(@portfolio, :investment) && @portfolio.investment_enabled do %>
                <a
                  href="#invest"
                  class="rounded-xl border-2 border-base-300 bg-base-100 px-6 sm:px-8 py-3 sm:py-4 text-sm sm:text-base font-bold text-base-content hover:border-base-content/30 hover:shadow-lg transition-all text-center"
                >
                  Investment Opportunities
                </a>
              <% end %>
            </div>
          </div>

          <div class="hidden lg:block">
            <.hero_stats_card portfolio={@portfolio} venture_count={@venture_count} />
          </div>
        </div>
      </div>
    </div>
    """
  end

  attr :portfolio, Portfolio, required: true
  attr :venture_count, :integer, default: 0

  defp hero_stats_card(assigns) do
    ~H"""
    <div class="relative">
      <div class="absolute inset-0 bg-gradient-to-tr from-emerald-500/20 to-teal-500/20 rounded-3xl rotate-3">
      </div>
      <div class="relative rounded-3xl bg-gradient-to-br from-emerald-600 to-teal-700 p-10 xl:p-12 shadow-2xl">
        <div class="space-y-6">
          <div class="flex items-center gap-4 text-white">
            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-white/20 flex-shrink-0">
              <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 20 20">
                <path d="M10.394 2.08a1 1 0 00-.788 0l-7 3a1 1 0 000 1.84L5.25 8.051a.999.999 0 01.356-.257l4-1.714a1 1 0 11.788 1.838L7.667 9.088l1.94.831a1 1 0 00.787 0l7-3a1 1 0 000-1.838l-7-3z" />
              </svg>
            </div>
            <div>
              <div class="text-3xl font-bold">{@venture_count}</div>
              <div class="text-sm text-emerald-100 font-semibold">Active Ventures</div>
            </div>
          </div>
          <div class="flex items-center gap-4 text-white">
            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-white/20 flex-shrink-0">
              <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 20 20">
                <path d="M3 4a1 1 0 011-1h12a1 1 0 011 1v2a1 1 0 01-1 1H4a1 1 0 01-1-1V4zM3 10a1 1 0 011-1h6a1 1 0 011 1v6a1 1 0 01-1 1H4a1 1 0 01-1-1v-6zM14 9a1 1 0 00-1 1v6a1 1 0 001 1h2a1 1 0 001-1v-6a1 1 0 00-1-1h-2z" />
              </svg>
            </div>
            <div>
              <div class="text-3xl font-bold">100%</div>
              <div class="text-sm text-emerald-100 font-semibold">Growth Focused</div>
            </div>
          </div>
          <div class="flex items-center gap-4 text-white">
            <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-white/20 flex-shrink-0">
              <svg class="h-6 w-6" fill="currentColor" viewBox="0 0 20 20">
                <path
                  fill-rule="evenodd"
                  d="M6.267 3.455a3.066 3.066 0 001.745-.723 3.066 3.066 0 013.976 0 3.066 3.066 0 001.745.723 3.066 3.066 0 012.812 2.812c.051.643.304 1.254.723 1.745a3.066 3.066 0 010 3.976 3.066 3.066 0 00-.723 1.745 3.066 3.066 0 01-2.812 2.812 3.066 3.066 0 00-1.745.723 3.066 3.066 0 01-3.976 0 3.066 3.066 0 00-1.745-.723 3.066 3.066 0 01-2.812-2.812 3.066 3.066 0 00-.723-1.745 3.066 3.066 0 010-3.976 3.066 3.066 0 00.723-1.745 3.066 3.066 0 012.812-2.812zm7.44 5.252a1 1 0 00-1.414-1.414L9 10.586 7.707 9.293a1 1 0 00-1.414 1.414l2 2a1 1 0 001.414 0l4-4z"
                  clip-rule="evenodd"
                />
              </svg>
            </div>
            <div>
              <div class="text-3xl font-bold">SaaS</div>
              <div class="text-sm text-emerald-100 font-semibold">Multi-Tenant</div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  # ============================================================================
  # Ventures Section
  # ============================================================================

  attr :ventures, :list, required: true
  attr :title, :string, default: "Active Ventures"
  attr :subtitle, :string, default: "OUR PORTFOLIO"
  attr :description, :string, default: "Multi-tenant SaaS platforms serving thriving communities"
  attr :bg_class, :string, default: "bg-base-200"
  attr :label_color, :string, default: "primary"
  attr :coming_soon, :boolean, default: false

  def ventures_section(assigns) do
    ~H"""
    <div id="ventures" class={"#{@bg_class} px-6 py-16 sm:py-24 lg:py-32 scroll-mt-24"}>
      <div class="mx-auto max-w-7xl">
        <div class="mb-12 sm:mb-16 lg:mb-20">
          <h2 class={"text-xs sm:text-sm font-bold text-#{@label_color} mb-3 sm:mb-4 uppercase tracking-widest"}>
            {@subtitle}
          </h2>
          <p class="text-3xl sm:text-4xl lg:text-5xl font-black tracking-tight text-base-content mb-4 sm:mb-6">
            {@title}
          </p>
          <p class="text-lg sm:text-xl text-base-content/80 max-w-2xl">
            {@description}
          </p>
        </div>

        <div class="grid grid-cols-1 gap-8 lg:grid-cols-2">
          <%= for venture <- @ventures do %>
            <.venture_card venture={venture} coming_soon={@coming_soon} />
          <% end %>
        </div>
      </div>
    </div>
    """
  end

  attr :ventures, :list, required: true

  def acquired_ventures_section(assigns) do
    ~H"""
    <%= if Enum.any?(@ventures) do %>
      <div class="bg-base-200 px-6 py-16 sm:py-24">
        <div class="mx-auto max-w-7xl">
          <div class="mb-12 sm:mb-16">
            <h2 class="text-xs sm:text-sm font-bold text-secondary mb-3 sm:mb-4 uppercase tracking-widest">
              SUCCESS STORIES
            </h2>
            <p class="text-3xl sm:text-4xl lg:text-5xl font-black tracking-tight text-base-content mb-4 sm:mb-6">
              Acquired / Sold
            </p>
            <p class="text-lg sm:text-xl text-base-content/80 max-w-2xl">
              Ventures that have successfully exited through acquisition
            </p>
          </div>

          <div class="grid grid-cols-1 gap-6 md:grid-cols-2 lg:grid-cols-3">
            <%= for venture <- @ventures do %>
              <.acquired_venture_card venture={venture} />
            <% end %>
          </div>
        </div>
      </div>
    <% end %>
    """
  end

  attr :venture, :map, required: true
  attr :coming_soon, :boolean, default: false

  def venture_card(assigns) do
    ~H"""
    <div class="group relative overflow-hidden rounded-2xl bg-gray-900 p-8 hover:shadow-2xl transition-all duration-300">
      <div class="flex items-start justify-between mb-6">
        <div class="flex items-center gap-4">
          <div class={"flex h-16 w-16 items-center justify-center rounded-xl bg-#{@venture.color || "primary"}-500 shadow-lg flex-shrink-0"}>
            <%= if @venture.icon_svg do %>
              <div class="h-9 w-9 text-white">
                {Phoenix.HTML.raw(@venture.icon_svg)}
              </div>
            <% else %>
              <svg class="h-9 w-9 text-white" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M19 21V5a2 2 0 00-2-2H7a2 2 0 00-2 2v16m14 0h2m-2 0h-5m-9 0H3m2 0h5"
                />
              </svg>
            <% end %>
          </div>
          <div>
            <h3 class={"text-2xl font-black text-#{@venture.color || "primary"}-400 mb-1"}>
              {@venture.name}
            </h3>
            <%= if @venture.url do %>
              <p class="text-sm text-gray-400 font-semibold">{URI.parse(@venture.url).host}</p>
            <% end %>
          </div>
        </div>
        <%= if @coming_soon do %>
          <span class="rounded-full bg-warning/20 px-3 py-1 text-xs font-black text-warning uppercase tracking-wider">
            Coming Soon
          </span>
        <% else %>
          <span class={"rounded-full bg-#{@venture.color || "primary"}-500/20 px-3 py-1 text-xs font-black text-#{@venture.color || "primary"}-400 uppercase tracking-wider"}>
            Active
          </span>
        <% end %>
      </div>

      <%= if @venture.tagline do %>
        <div class="mb-5">
          <span class="inline-block rounded-full bg-white/10 px-3 py-1.5 text-xs font-bold text-white uppercase tracking-wide">
            {@venture.tagline}
          </span>
        </div>
      <% end %>

      <%= if @venture.description do %>
        <p class="text-base text-gray-300 leading-relaxed mb-6">
          {@venture.description}
        </p>
      <% end %>

      <div class="flex items-center gap-4">
        <%= if @venture.url && !@coming_soon do %>
          <a
            href={@venture.url}
            target="_blank"
            rel="noopener noreferrer"
            class={"inline-flex items-center gap-2 text-base font-black text-#{@venture.color || "primary"}-400 hover:text-#{@venture.color || "primary"}-300 transition-colors group/link"}
          >
            Visit Platform
            <svg
              class="h-5 w-5 transition-transform group-hover/link:translate-x-1"
              viewBox="0 0 20 20"
              fill="currentColor"
            >
              <path
                fill-rule="evenodd"
                d="M10.293 3.293a1 1 0 011.414 0l6 6a1 1 0 010 1.414l-6 6a1 1 0 01-1.414-1.414L14.586 11H3a1 1 0 110-2h11.586l-4.293-4.293a1 1 0 010-1.414z"
                clip-rule="evenodd"
              />
            </svg>
          </a>
        <% end %>

        <%= if @venture.featured_pitch_deck do %>
          <a
            href={~p"/investors/pitch-decks/#{@venture.featured_pitch_deck.slug}"}
            class="inline-flex items-center gap-2 text-sm font-bold text-gray-400 hover:text-white transition-colors"
          >
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M9 12h6m-6 4h6m2 5H7a2 2 0 01-2-2V5a2 2 0 012-2h5.586a1 1 0 01.707.293l5.414 5.414a1 1 0 01.293.707V19a2 2 0 01-2 2z"
              />
            </svg>
            View Pitch Deck
          </a>
        <% end %>
      </div>
    </div>
    """
  end

  attr :venture, :map, required: true

  defp acquired_venture_card(assigns) do
    ~H"""
    <div class="rounded-2xl bg-base-100 border-2 border-base-300 p-6 hover:shadow-lg transition-all">
      <div class="flex items-center gap-4 mb-4">
        <%= if @venture.icon_svg do %>
          <div class={"flex h-12 w-12 items-center justify-center rounded-xl bg-#{@venture.color || "gray"}-500/20 flex-shrink-0"}>
            <div class={"h-6 w-6 text-#{@venture.color || "gray"}-500"}>
              {Phoenix.HTML.raw(@venture.icon_svg)}
            </div>
          </div>
        <% end %>
        <div>
          <h3 class="text-lg font-bold text-base-content">{@venture.name}</h3>
          <%= if @venture.acquired_by do %>
            <p class="text-sm text-base-content/60">Acquired by {@venture.acquired_by}</p>
          <% end %>
        </div>
      </div>
      <%= if @venture.tagline do %>
        <p class="text-sm text-base-content/70 mb-3">{@venture.tagline}</p>
      <% end %>
      <div class="flex items-center justify-between">
        <span class="badge badge-secondary badge-sm">Acquired</span>
        <%= if @venture.acquired_date do %>
          <span class="text-xs text-base-content/50">
            {Calendar.strftime(@venture.acquired_date, "%B %Y")}
          </span>
        <% end %>
      </div>
    </div>
    """
  end

  # ============================================================================
  # About Section
  # ============================================================================

  attr :portfolio, Portfolio, required: true
  attr :venture_count, :integer, default: 0

  def about_section(assigns) do
    ~H"""
    <div id="about" class="bg-base-100 px-6 py-16 sm:py-24 lg:py-32 scroll-mt-24">
      <div class="mx-auto max-w-7xl">
        <div class="grid grid-cols-1 gap-12 lg:gap-20 lg:grid-cols-5 items-center">
          <div class="lg:col-span-3">
            <h2 class="text-xs sm:text-sm font-bold text-primary mb-3 sm:mb-4 uppercase tracking-widest">
              ABOUT US
            </h2>
            <p class="text-3xl sm:text-4xl lg:text-5xl font-black tracking-tight text-base-content mb-6 sm:mb-8">
              {@portfolio.about_title || "Building the Future of SaaS"}
            </p>
            <%= if @portfolio.about_description do %>
              <div class="text-lg sm:text-xl text-base-content/90 leading-relaxed space-y-5 sm:space-y-6">
                <%= for paragraph <- String.split(@portfolio.about_description, "\n\n") do %>
                  <p>{paragraph}</p>
                <% end %>
              </div>
            <% end %>
          </div>

          <div class="lg:col-span-2 space-y-4 sm:space-y-6">
            <div class="rounded-2xl bg-primary/10 p-6 sm:p-8 border-2 border-primary/20">
              <div class="text-4xl sm:text-5xl font-black text-primary mb-2">{@venture_count}</div>
              <div class="text-xs sm:text-sm font-bold text-base-content/70 uppercase tracking-wide">
                Active Ventures
              </div>
            </div>
            <div class="rounded-2xl bg-secondary/10 p-6 sm:p-8 border-2 border-secondary/20">
              <div class="text-4xl sm:text-5xl font-black text-secondary mb-2">SaaS</div>
              <div class="text-xs sm:text-sm font-bold text-base-content/70 uppercase tracking-wide">
                Multi-Tenant
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
    """
  end

  # ============================================================================
  # Investment Section
  # ============================================================================

  attr :portfolio, Portfolio, required: true

  def investment_section(assigns) do
    ~H"""
    <div id="invest" class="bg-neutral px-6 py-16 sm:py-24 lg:py-32 scroll-mt-24">
      <div class="mx-auto max-w-4xl text-center">
        <div class="mb-6 sm:mb-8 inline-flex items-center gap-2 rounded-full bg-primary/20 px-4 sm:px-5 py-2 sm:py-2.5 text-xs sm:text-sm font-bold text-primary border-2 border-primary/40 uppercase tracking-wider">
          <svg class="h-4 w-4 sm:h-5 sm:w-5 text-secondary" fill="currentColor" viewBox="0 0 20 20">
            <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
          </svg>
          Investment Opportunity
        </div>

        <h2 class="text-3xl sm:text-4xl lg:text-5xl font-black tracking-tight text-neutral-content mb-6 sm:mb-8">
          Partner With Us
        </h2>

        <p class="text-lg sm:text-xl text-neutral-content/80 leading-relaxed mb-8 sm:mb-12 max-w-2xl mx-auto">
          Access exclusive pitch decks and investment opportunities. Join us in building the future of multi-tenant SaaS platforms.
        </p>

        <div class="flex flex-col items-center gap-6">
          <a
            href="/investors/pitch-decks"
            class="w-full sm:w-auto rounded-xl bg-primary px-6 sm:px-8 py-3 sm:py-4 text-sm sm:text-base font-bold text-primary-content hover:bg-primary/90 transition-all hover:shadow-xl inline-flex items-center justify-center gap-2 sm:gap-3 group"
          >
            View Pitch Decks
            <svg
              class="h-4 w-4 sm:h-5 sm:w-5 transition-transform group-hover:translate-x-1"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
              stroke-width="2.5"
            >
              <path stroke-linecap="round" stroke-linejoin="round" d="M17 8l4 4m0 0l-4 4m4-4H3" />
            </svg>
          </a>

          <div class="w-full max-w-md">
            <p class="text-sm text-neutral-content/70 mb-3 text-center">
              Or join our investor mailing list:
            </p>
            <form
              action="/investors/subscribe"
              method="post"
              class="flex flex-col sm:flex-row gap-3"
            >
              <input type="hidden" name="_csrf_token" value={Phoenix.Controller.get_csrf_token()} />
              <input
                type="email"
                name="subscriber[email]"
                placeholder="your@email.com"
                required
                class="flex-1 rounded-xl px-4 py-3 text-sm bg-neutral-content/10 border-2 border-neutral-content/20 text-neutral-content placeholder:text-neutral-content/50 focus:border-primary focus:outline-none"
              />
              <button
                type="submit"
                class="rounded-xl bg-secondary px-6 py-3 text-sm font-bold text-secondary-content hover:bg-secondary/90 transition-all"
              >
                Subscribe
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>
    """
  end

  # ============================================================================
  # Consulting Section
  # ============================================================================

  attr :portfolio, Portfolio, required: true

  def consulting_section(assigns) do
    ~H"""
    <div id="consulting" class="bg-base-100 px-6 py-16 sm:py-24 lg:py-32 scroll-mt-24">
      <div class="mx-auto max-w-7xl">
        <div class="grid grid-cols-1 gap-12 lg:gap-16 lg:grid-cols-2 items-center">
          <div>
            <h2 class="text-xs sm:text-sm font-bold text-primary mb-3 sm:mb-4 uppercase tracking-widest">
              CONSULTING SERVICES
            </h2>
            <p class="text-3xl sm:text-4xl lg:text-5xl font-black tracking-tight text-base-content mb-6 sm:mb-8">
              Expert Technical Consulting
            </p>
            <p class="text-lg sm:text-xl text-base-content/90 leading-relaxed mb-6">
              Leverage our expertise in building scalable SaaS platforms for your own projects. We offer consulting services to help fund and grow {@portfolio.name} ventures.
            </p>

            <div class="space-y-4 mb-8">
              <.consulting_service_item
                icon="code"
                title="Full-Stack Development"
                description="Phoenix/Elixir, LiveView, React, Node.js, and modern web technologies"
              />
              <.consulting_service_item
                icon="database"
                title="Architecture & Infrastructure"
                description="Multi-tenant SaaS design, cloud infrastructure, DevOps, and scaling strategies"
              />
              <.consulting_service_item
                icon="lightning"
                title="Technical Strategy"
                description="Technology selection, roadmap planning, and technical due diligence"
              />
            </div>

            <a
              href={"mailto:#{@portfolio.consulting_email || "consulting@jutilistechnologies.com"}"}
              class="inline-flex items-center gap-2 rounded-xl bg-primary px-6 sm:px-8 py-3 sm:py-4 text-sm sm:text-base font-bold text-primary-content hover:bg-primary/90 transition-all hover:shadow-xl group"
            >
              Get in Touch
              <svg
                class="h-4 w-4 sm:h-5 sm:w-5 transition-transform group-hover:translate-x-1"
                fill="none"
                viewBox="0 0 24 24"
                stroke="currentColor"
                stroke-width="2.5"
              >
                <path stroke-linecap="round" stroke-linejoin="round" d="M17 8l4 4m0 0l-4 4m4-4H3" />
              </svg>
            </a>
          </div>

          <.consulting_benefits_card />
        </div>
      </div>
    </div>
    """
  end

  attr :icon, :string, required: true
  attr :title, :string, required: true
  attr :description, :string, required: true

  defp consulting_service_item(assigns) do
    ~H"""
    <div class="flex items-start gap-4">
      <div class="flex h-10 w-10 items-center justify-center rounded-xl bg-primary/20 flex-shrink-0">
        <.consulting_icon name={@icon} />
      </div>
      <div>
        <h3 class="font-bold text-base-content mb-1">{@title}</h3>
        <p class="text-base-content/70">{@description}</p>
      </div>
    </div>
    """
  end

  defp consulting_icon(%{name: "code"} = assigns) do
    ~H"""
    <svg class="h-5 w-5 text-primary" fill="currentColor" viewBox="0 0 20 20">
      <path
        fill-rule="evenodd"
        d="M12.316 3.051a1 1 0 01.633 1.265l-4 12a1 1 0 11-1.898-.632l4-12a1 1 0 011.265-.633zM5.707 6.293a1 1 0 010 1.414L3.414 10l2.293 2.293a1 1 0 11-1.414 1.414l-3-3a1 1 0 010-1.414l3-3a1 1 0 011.414 0zm8.586 0a1 1 0 011.414 0l3 3a1 1 0 010 1.414l-3 3a1 1 0 11-1.414-1.414L16.586 10l-2.293-2.293a1 1 0 010-1.414z"
        clip-rule="evenodd"
      />
    </svg>
    """
  end

  defp consulting_icon(%{name: "database"} = assigns) do
    ~H"""
    <svg class="h-5 w-5 text-primary" fill="currentColor" viewBox="0 0 20 20">
      <path d="M3 12v3c0 1.657 3.134 3 7 3s7-1.343 7-3v-3c0 1.657-3.134 3-7 3s-7-1.343-7-3z" />
      <path d="M3 7v3c0 1.657 3.134 3 7 3s7-1.343 7-3V7c0 1.657-3.134 3-7 3S3 8.657 3 7z" />
      <path d="M17 5c0 1.657-3.134 3-7 3S3 6.657 3 5s3.134-3 7-3 7 1.343 7 3z" />
    </svg>
    """
  end

  defp consulting_icon(%{name: "lightning"} = assigns) do
    ~H"""
    <svg class="h-5 w-5 text-primary" fill="currentColor" viewBox="0 0 20 20">
      <path
        fill-rule="evenodd"
        d="M11.3 1.046A1 1 0 0112 2v5h4a1 1 0 01.82 1.573l-7 10A1 1 0 018 18v-5H4a1 1 0 01-.82-1.573l7-10a1 1 0 011.12-.38z"
        clip-rule="evenodd"
      />
    </svg>
    """
  end

  defp consulting_benefits_card(assigns) do
    ~H"""
    <div class="relative">
      <div class="absolute inset-0 bg-gradient-to-tr from-primary/20 to-secondary/20 rounded-3xl -rotate-2">
      </div>
      <div class="relative rounded-3xl bg-base-200 border-2 border-base-300 p-8 sm:p-10">
        <h3 class="text-xl sm:text-2xl font-bold text-base-content mb-6">Why Work With Us?</h3>

        <div class="space-y-6">
          <.consulting_benefit
            number="1"
            title="Battle-Tested Experience"
            description="Built and scaled multiple SaaS platforms from scratch"
          />
          <.consulting_benefit
            number="2"
            title="Modern Tech Stack"
            description="PETAL stack expertise for fast, reliable applications"
          />
          <.consulting_benefit
            number="3"
            title="Results-Driven"
            description="Focused on delivering measurable business value"
          />
          <.consulting_benefit
            number="4"
            title="Flexible Engagement"
            description="Project-based, retainer, or advisory arrangements"
          />
        </div>
      </div>
    </div>
    """
  end

  attr :number, :string, required: true
  attr :title, :string, required: true
  attr :description, :string, required: true

  defp consulting_benefit(assigns) do
    ~H"""
    <div class="flex items-center gap-4">
      <div class="flex h-12 w-12 items-center justify-center rounded-full bg-primary/20 flex-shrink-0">
        <span class="text-2xl font-black text-primary">{@number}</span>
      </div>
      <div>
        <h4 class="font-bold text-base-content">{@title}</h4>
        <p class="text-sm text-base-content/70">{@description}</p>
      </div>
    </div>
    """
  end

  # ============================================================================
  # Footer Section
  # ============================================================================

  attr :portfolio, Portfolio, required: true

  def footer_section(assigns) do
    ~H"""
    <div class="bg-base-100 px-6 py-16 border-t border-base-300">
      <div class="mx-auto max-w-7xl">
        <div class="flex flex-col items-center justify-between gap-8 sm:flex-row sm:items-start">
          <div class="text-center sm:text-left">
            <div class="flex items-center gap-3 justify-center sm:justify-start mb-4">
              <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-gradient-to-br from-emerald-600 to-teal-700">
                <%= if @portfolio.logo_text do %>
                  <span class="text-xl font-bold text-white">{@portfolio.logo_text}</span>
                <% else %>
                  <span class="text-xl font-bold text-white">&#123;JuT&#125;</span>
                <% end %>
              </div>
              <span class="text-xl font-black text-base-content">{@portfolio.name}</span>
            </div>
            <%= if @portfolio.tagline do %>
              <p class="text-sm text-base-content/60 font-semibold">
                {@portfolio.tagline}
              </p>
            <% end %>
          </div>

          <div class="flex flex-wrap items-center justify-center gap-8">
            <%= if section_enabled?(@portfolio, :ventures) do %>
              <a
                href="#ventures"
                class="text-sm font-bold text-base-content/70 hover:text-primary transition-colors uppercase tracking-wide"
              >
                Ventures
              </a>
            <% end %>
            <%= if section_enabled?(@portfolio, :about) do %>
              <a
                href="#about"
                class="text-sm font-bold text-base-content/70 hover:text-primary transition-colors uppercase tracking-wide"
              >
                About
              </a>
            <% end %>
            <%= if section_enabled?(@portfolio, :investment) && @portfolio.investment_enabled do %>
              <a
                href="#invest"
                class="text-sm font-bold text-base-content/70 hover:text-primary transition-colors uppercase tracking-wide"
              >
                Invest
              </a>
            <% end %>
            <%= if section_enabled?(@portfolio, :consulting) && @portfolio.consulting_enabled do %>
              <a
                href="#consulting"
                class="text-sm font-bold text-base-content/70 hover:text-primary transition-colors uppercase tracking-wide"
              >
                Consulting
              </a>
            <% end %>
            <a
              href="/users/log-in"
              class="text-sm font-bold text-base-content/70 hover:text-primary transition-colors uppercase tracking-wide"
            >
              Login
            </a>
          </div>
        </div>

        <div class="mt-12 border-t border-base-300 pt-8 text-center">
          <p class="text-sm text-base-content/60 font-semibold">
            © {Date.utc_today().year} {@portfolio.name}. All rights reserved.
          </p>
        </div>
      </div>
    </div>
    """
  end

  # ============================================================================
  # Helper Functions
  # ============================================================================

  @doc """
  Checks if a section is enabled in the portfolio's section_config.
  """
  def section_enabled?(portfolio, section) do
    Portfolio.section_enabled?(portfolio, section)
  end
end
