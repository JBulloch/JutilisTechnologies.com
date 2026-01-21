defmodule JutilisWeb.LaunchpadComponents do
  @moduledoc """
  UI components for the SaaS Launchpad Roadmap.
  """
  use Phoenix.Component
  use JutilisWeb, :verified_routes

  alias Jutilis.Launchpad.Tool

  @doc """
  Renders a phase header with title, description, and progress indicator.
  """
  attr :phase, :map, required: true
  attr :phases, :list, required: true
  attr :class, :string, default: nil

  def phase_header(assigns) do
    ~H"""
    <div class={["mb-6", @class]}>
      <div class="flex items-center justify-between mb-2">
        <div class="flex items-center gap-3">
          <div class={"flex h-10 w-10 items-center justify-center rounded-xl bg-#{@phase.color}/20"}>
            <span class={"text-#{@phase.color}"}>
              <.phase_icon phase={@phase.id} />
            </span>
          </div>
          <div>
            <h2 class="text-xl font-bold text-base-content">{@phase.name}</h2>
            <p class="text-sm text-base-content/60">{@phase.description}</p>
          </div>
        </div>
        <.phase_dots phases={@phases} current={@phase.id} />
      </div>
    </div>
    """
  end

  @doc """
  Renders phase progress dots.
  """
  attr :phases, :list, required: true
  attr :current, :string, required: true

  def phase_dots(assigns) do
    ~H"""
    <div class="flex items-center gap-2">
      <%= for phase <- @phases do %>
        <div class={[
          "h-3 w-3 rounded-full transition-all",
          if(phase.id == @current, do: "bg-#{phase.color} scale-110", else: "bg-base-300")
        ]}>
        </div>
      <% end %>
    </div>
    """
  end

  @doc """
  Renders a category step card with tools and user links.
  """
  attr :category, :map, required: true
  attr :step_number, :integer, required: true
  attr :user_links, :list, default: []
  attr :expanded, :boolean, default: true

  def step_card(assigns) do
    # Filter user links that match this category
    category_links = Enum.filter(assigns.user_links, &(&1.category == assigns.category.slug))
    assigns = assign(assigns, :category_links, category_links)

    ~H"""
    <div class="rounded-2xl border-2 border-base-300 bg-base-100 overflow-hidden mb-4">
      <div class="bg-base-200 px-6 py-4 border-b border-base-300">
        <div class="flex items-center gap-4">
          <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-primary/20 text-primary font-bold text-sm">
            {@step_number}
          </div>
          <div class="flex items-center gap-3 flex-1">
            <span class="text-base-content/60">
              <.category_icon icon={@category.icon} />
            </span>
            <div>
              <h3 class="font-bold text-base-content">{@category.name}</h3>
              <p class="text-xs text-base-content/60">{@category.description}</p>
            </div>
          </div>
          <div class="flex items-center gap-2">
            <%= if length(@category_links) > 0 do %>
              <span class="badge badge-success badge-sm">{length(@category_links)} my links</span>
            <% end %>
            <span class="badge badge-ghost badge-sm">{length(@category.tools)} tools</span>
          </div>
        </div>
      </div>
      
    <!-- User's Links Section -->
      <div
        :if={@expanded && length(@category_links) > 0}
        class="p-4 border-b border-base-200 bg-success/5"
      >
        <div class="flex items-center gap-2 mb-3">
          <svg class="h-4 w-4 text-success" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 13l4 4L19 7" />
          </svg>
          <span class="text-sm font-semibold text-success">Your Links</span>
        </div>
        <div class="space-y-2">
          <%= for link <- @category_links do %>
            <.user_link_item link={link} />
          <% end %>
        </div>
      </div>
      
    <!-- Recommended Tools Section -->
      <div :if={@expanded && length(@category.tools) > 0} class="p-4 space-y-3">
        <div :if={length(@category_links) > 0} class="flex items-center gap-2 mb-3">
          <svg
            class="h-4 w-4 text-base-content/40"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M13 10V3L4 14h7v7l9-11h-7z"
            />
          </svg>
          <span class="text-sm font-semibold text-base-content/60">Recommended Tools</span>
        </div>
        <%= for tool <- @category.tools do %>
          <.tool_item tool={tool} />
        <% end %>
      </div>

      <div :if={length(@category.tools) == 0 && length(@category_links) == 0} class="p-6 text-center">
        <p class="text-sm text-base-content/50">No tools or links added yet</p>
      </div>
    </div>
    """
  end

  @doc """
  Renders a user's link item within the roadmap.
  """
  attr :link, :map, required: true

  def user_link_item(assigns) do
    ~H"""
    <div class="flex items-center gap-4 p-3 rounded-xl bg-success/10 border border-success/20">
      <div class="flex h-8 w-8 items-center justify-center rounded-lg bg-success/20 text-success">
        <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1"
          />
        </svg>
      </div>
      <div class="flex-1 min-w-0">
        <h4 class="font-semibold text-base-content text-sm">{@link.name}</h4>
        <%= if @link.description do %>
          <p class="text-xs text-base-content/60 truncate">{@link.description}</p>
        <% end %>
      </div>
      <a
        href={@link.url}
        target="_blank"
        rel="noopener noreferrer"
        class="btn btn-sm btn-success btn-outline"
      >
        Open
        <svg class="h-3 w-3" fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
          />
        </svg>
      </a>
    </div>
    """
  end

  @doc """
  Renders a single tool item.
  """
  attr :tool, :map, required: true

  def tool_item(assigns) do
    ~H"""
    <div class={[
      "flex items-start gap-4 p-4 rounded-xl transition-all",
      if(@tool.is_featured,
        do: "bg-primary/5 border border-primary/20",
        else: "bg-base-200/50 hover:bg-base-200"
      )
    ]}>
      <div class="flex-shrink-0">
        <%= if @tool.is_featured do %>
          <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/20 text-primary">
            <svg class="h-5 w-5" fill="currentColor" viewBox="0 0 20 20">
              <path d="M9.049 2.927c.3-.921 1.603-.921 1.902 0l1.07 3.292a1 1 0 00.95.69h3.462c.969 0 1.371 1.24.588 1.81l-2.8 2.034a1 1 0 00-.364 1.118l1.07 3.292c.3.921-.755 1.688-1.54 1.118l-2.8-2.034a1 1 0 00-1.175 0l-2.8 2.034c-.784.57-1.838-.197-1.539-1.118l1.07-3.292a1 1 0 00-.364-1.118L2.98 8.72c-.783-.57-.38-1.81.588-1.81h3.461a1 1 0 00.951-.69l1.07-3.292z" />
            </svg>
          </div>
        <% else %>
          <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-base-300 text-base-content/60">
            <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1"
              />
            </svg>
          </div>
        <% end %>
      </div>

      <div class="flex-1 min-w-0">
        <div class="flex items-center gap-2 mb-1">
          <h4 class="font-semibold text-base-content">{@tool.name}</h4>
          <%= if @tool.is_featured do %>
            <span class="badge badge-primary badge-xs">Recommended</span>
          <% end %>
          <%= if @tool.pricing_info do %>
            <span class="badge badge-ghost badge-xs">{@tool.pricing_info}</span>
          <% end %>
        </div>

        <p class="text-sm text-base-content/70 mb-2">{@tool.description}</p>

        <%= if @tool.factoid do %>
          <p class="text-xs text-base-content/50 flex items-start gap-1">
            <svg
              class="h-4 w-4 flex-shrink-0 text-primary/60"
              fill="none"
              viewBox="0 0 24 24"
              stroke="currentColor"
            >
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M13 16h-1v-4h-1m1-4h.01M21 12a9 9 0 11-18 0 9 9 0 0118 0z"
              />
            </svg>
            <span>{@tool.factoid}</span>
          </p>
        <% end %>
      </div>

      <div class="flex-shrink-0">
        <.tool_link tool={@tool} class="btn btn-sm btn-ghost">
          Visit
          <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="2"
              d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
            />
          </svg>
        </.tool_link>
      </div>
    </div>
    """
  end

  @doc """
  Renders a link to a tool, using affiliate URL if available.
  """
  attr :tool, :map, required: true
  attr :class, :string, default: nil
  attr :rest, :global
  slot :inner_block, required: true

  def tool_link(assigns) do
    url = Tool.get_link(assigns.tool)
    assigns = assign(assigns, :url, url)

    ~H"""
    <a href={@url} target="_blank" rel="noopener noreferrer" class={@class} {@rest}>
      {render_slot(@inner_block)}
    </a>
    """
  end

  @doc """
  Renders the full roadmap with all phases.
  """
  attr :roadmap, :list, required: true
  attr :user_links, :list, default: []

  def roadmap(assigns) do
    phases = Enum.map(assigns.roadmap, & &1.phase)
    assigns = assign(assigns, :phases, phases)

    ~H"""
    <div class="space-y-8">
      <%= for %{phase: phase, categories: categories} <- @roadmap do %>
        <div>
          <.phase_header phase={phase} phases={@phases} />

          <div class="border-l-2 border-base-300 ml-5 pl-6">
            <%= for category <- categories do %>
              <.step_card
                category={category}
                step_number={category.display_order}
                user_links={@user_links}
              />
            <% end %>

            <%= if length(categories) == 0 do %>
              <p class="text-sm text-base-content/50 py-4">No categories in this phase</p>
            <% end %>
          </div>
        </div>
      <% end %>
    </div>
    """
  end

  # =============================================================================
  # Helper Components
  # =============================================================================

  defp phase_icon(%{phase: "planning"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"
      />
    </svg>
    """
  end

  defp phase_icon(%{phase: "building"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M10.325 4.317c.426-1.756 2.924-1.756 3.35 0a1.724 1.724 0 002.573 1.066c1.543-.94 3.31.826 2.37 2.37a1.724 1.724 0 001.065 2.572c1.756.426 1.756 2.924 0 3.35a1.724 1.724 0 00-1.066 2.573c.94 1.543-.826 3.31-2.37 2.37a1.724 1.724 0 00-2.572 1.065c-.426 1.756-2.924 1.756-3.35 0a1.724 1.724 0 00-2.573-1.066c-1.543.94-3.31-.826-2.37-2.37a1.724 1.724 0 00-1.065-2.572c-1.756-.426-1.756-2.924 0-3.35a1.724 1.724 0 001.066-2.573c-.94-1.543.826-3.31 2.37-2.37.996.608 2.296.07 2.572-1.065z"
      />
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M15 12a3 3 0 11-6 0 3 3 0 016 0z"
      />
    </svg>
    """
  end

  defp phase_icon(%{phase: "maintaining"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z"
      />
    </svg>
    """
  end

  defp phase_icon(assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M13 10V3L4 14h7v7l9-11h-7z"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-scale"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M3 6l3 1m0 0l-3 9a5.002 5.002 0 006.001 0M6 7l3 9M6 7l6-2m6 2l3-1m-3 1l-3 9a5.002 5.002 0 006.001 0M18 7l3 9m-3-9l-6-2m0-2v2m0 16V5m0 16H9m3 0h3"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-banknotes"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-globe-alt"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-academic-cap"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path d="M12 14l9-5-9-5-9 5 9 5z" />
      <path d="M12 14l6.16-3.422a12.083 12.083 0 01.665 6.479A11.952 11.952 0 0012 20.055a11.952 11.952 0 00-6.824-2.998 12.078 12.078 0 01.665-6.479L12 14z" />
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M12 14l9-5-9-5-9 5 9 5zm0 0l6.16-3.422a12.083 12.083 0 01.665 6.479A11.952 11.952 0 0012 20.055a11.952 11.952 0 00-6.824-2.998 12.078 12.078 0 01.665-6.479L12 14zm-4 6v-7.5l4-2.222"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-code-bracket"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-server"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M5 12h14M5 12a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v4a2 2 0 01-2 2M5 12a2 2 0 00-2 2v4a2 2 0 002 2h14a2 2 0 002-2v-4a2 2 0 00-2-2m-2-4h.01M17 16h.01"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-computer-desktop"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-sparkles"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-arrow-path"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-envelope"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-exclamation-triangle"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-chat-bubble-left-right"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M17 8h2a2 2 0 012 2v6a2 2 0 01-2 2h-2v4l-4-4H9a1.994 1.994 0 01-1.414-.586m0 0L11 14h4a2 2 0 002-2V6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2v4l.586-.586z"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-chart-pie"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M11 3.055A9.001 9.001 0 1020.945 13H11V3.055z"
      />
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M20.488 9H15V3.512A9.025 9.025 0 0120.488 9z"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-megaphone"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M11 5.882V19.24a1.76 1.76 0 01-3.417.592l-2.147-6.15M18 13a3 3 0 100-6M5.436 13.683A4.001 4.001 0 017 6h1.832c4.1 0 7.625-1.234 9.168-3v14c-1.543-1.766-5.067-3-9.168-3H7a3.988 3.988 0 01-1.564-.317z"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-share"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-user-group"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"
      />
    </svg>
    """
  end

  defp category_icon(%{icon: "hero-squares-2x2"} = assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M4 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2V6zM14 6a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2V6zM4 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2H6a2 2 0 01-2-2v-2zM14 16a2 2 0 012-2h2a2 2 0 012 2v2a2 2 0 01-2 2h-2a2 2 0 01-2-2v-2z"
      />
    </svg>
    """
  end

  defp category_icon(assigns) do
    ~H"""
    <svg class="h-5 w-5" fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1"
      />
    </svg>
    """
  end
end
