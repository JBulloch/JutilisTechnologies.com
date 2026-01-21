defmodule JutilisWeb.AdminLive.VentureShow do
  use JutilisWeb, :live_view

  alias Jutilis.Ventures
  alias Jutilis.Ventures.VentureLink
  alias Jutilis.Launchpad
  import JutilisWeb.LaunchpadComponents

  @impl true
  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
      <div class="mx-auto max-w-7xl px-6 py-8 lg:px-8">
        <!-- Header -->
        <div class="mb-8">
          <div class="flex items-center gap-2 text-sm text-base-content/60 mb-4">
            <a href={~p"/admin/ventures"} class="hover:text-primary transition-colors">Ventures</a>
            <span>/</span>
            <span class="text-base-content">{@venture.name}</span>
          </div>

          <div class="flex items-start justify-between">
            <div class="flex items-center gap-4">
              <%= if @venture.icon_svg do %>
                <div class={"flex h-16 w-16 items-center justify-center rounded-xl bg-#{@venture.color || "primary"}-500 shadow-lg flex-shrink-0 overflow-hidden"}>
                  <div class="h-9 w-9 text-white flex items-center justify-center [&>svg]:h-full [&>svg]:w-full">
                    {Phoenix.HTML.raw(@venture.icon_svg)}
                  </div>
                </div>
              <% else %>
                <div class="flex h-16 w-16 items-center justify-center rounded-xl bg-primary shadow-lg flex-shrink-0">
                  <svg
                    class="h-9 w-9 text-white"
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
                </div>
              <% end %>
              <div>
                <h1 class="text-3xl font-black text-base-content">{@venture.name}</h1>
                <%= if @venture.tagline do %>
                  <p class="text-base-content/70 mt-1">{@venture.tagline}</p>
                <% end %>
              </div>
            </div>

            <div class="flex items-center gap-2">
              <a href={~p"/admin/ventures/#{@venture.id}/edit"} class="btn btn-ghost btn-sm">
                <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M11 5H6a2 2 0 00-2 2v11a2 2 0 002 2h11a2 2 0 002-2v-5m-1.414-9.414a2 2 0 112.828 2.828L11.828 15H9v-2.828l8.586-8.586z"
                  />
                </svg>
                Edit Venture
              </a>
              <%= if @venture.url do %>
                <a
                  href={@venture.url}
                  target="_blank"
                  rel="noopener noreferrer"
                  class="btn btn-primary btn-sm"
                >
                  <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                    />
                  </svg>
                  Visit Site
                </a>
              <% end %>
            </div>
          </div>
        </div>
        
    <!-- Quick Links Section -->
        <div class="mb-8">
          <div class="flex items-center justify-between mb-6">
            <h2 class="text-xl font-bold text-base-content">Quick Links</h2>
            <button phx-click="show_add_link" class="btn btn-primary btn-sm">
              <svg class="h-4 w-4 mr-1" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M12 4v16m8-8H4"
                />
              </svg>
              Add Link
            </button>
          </div>

          <%= if Enum.empty?(@venture.links) do %>
            <div class="text-center py-16 rounded-2xl border-2 border-dashed border-base-300">
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
                  d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1"
                />
              </svg>
              <p class="text-base-content/60 font-semibold">No quick links yet</p>
              <p class="text-sm text-base-content/40 mt-1">
                Add links to dev environments, hosting, banking, and more
              </p>
              <button phx-click="show_add_link" class="btn btn-primary btn-sm mt-4">
                Add Your First Link
              </button>
            </div>
          <% else %>
            <div class="grid gap-6">
              <%= for {category, links} <- @links_by_category do %>
                <div class="rounded-2xl border-2 border-base-300 bg-base-100 overflow-hidden">
                  <div class="bg-base-200 px-6 py-3 border-b border-base-300">
                    <div class="flex items-center gap-2">
                      <.category_icon category={category} />
                      <h3 class="font-bold text-base-content">{category_label(category)}</h3>
                      <span class="badge badge-sm badge-ghost">{length(links)}</span>
                    </div>
                  </div>
                  <div class="divide-y divide-base-200">
                    <%= for link <- links do %>
                      <div class="px-6 py-4 flex items-center justify-between hover:bg-base-50 transition-colors group">
                        <div class="flex items-center gap-4 flex-1 min-w-0">
                          <div class="flex-shrink-0">
                            <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-base-200 group-hover:bg-base-300 transition-colors">
                              <.category_icon
                                category={link.category}
                                class="h-5 w-5 text-base-content/60"
                              />
                            </div>
                          </div>
                          <div class="flex-1 min-w-0">
                            <div class="flex items-center gap-2">
                              <a
                                href={link.url}
                                target="_blank"
                                rel="noopener noreferrer"
                                class="font-semibold text-base-content hover:text-primary transition-colors truncate"
                              >
                                {link.name}
                              </a>
                              <svg
                                class="h-4 w-4 text-base-content/40 flex-shrink-0"
                                fill="none"
                                viewBox="0 0 24 24"
                                stroke="currentColor"
                              >
                                <path
                                  stroke-linecap="round"
                                  stroke-linejoin="round"
                                  stroke-width="2"
                                  d="M10 6H6a2 2 0 00-2 2v10a2 2 0 002 2h10a2 2 0 002-2v-4M14 4h6m0 0v6m0-6L10 14"
                                />
                              </svg>
                            </div>
                            <%= if link.description do %>
                              <p class="text-sm text-base-content/60 truncate">{link.description}</p>
                            <% end %>
                            <p class="text-xs text-base-content/40 truncate">
                              {URI.parse(link.url).host}
                            </p>
                          </div>
                        </div>
                        <div class="flex items-center gap-2">
                          <button
                            type="button"
                            phx-click="edit_link"
                            phx-value-id={link.id}
                            class="btn btn-ghost btn-xs"
                          >
                            Edit
                          </button>
                          <button
                            type="button"
                            phx-click="delete_link"
                            phx-value-id={link.id}
                            data-confirm="Delete this link?"
                            class="btn btn-ghost btn-xs text-error"
                          >
                            Delete
                          </button>
                        </div>
                      </div>
                    <% end %>
                  </div>
                </div>
              <% end %>
            </div>
          <% end %>
        </div>
        
    <!-- Venture Details Card -->
        <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
          <h3 class="font-bold text-base-content mb-4">Venture Details</h3>
          <dl class="grid grid-cols-1 gap-4 sm:grid-cols-2">
            <div>
              <dt class="text-sm font-semibold text-base-content/60">Status</dt>
              <dd class="mt-1">
                <span class={"badge badge-#{status_badge_color(@venture.status)}"}>
                  {String.capitalize(@venture.status)}
                </span>
              </dd>
            </div>
            <div>
              <dt class="text-sm font-semibold text-base-content/60">Slug</dt>
              <dd class="mt-1 font-mono text-sm text-base-content">{@venture.slug}</dd>
            </div>
            <%= if @venture.url do %>
              <div class="sm:col-span-2">
                <dt class="text-sm font-semibold text-base-content/60">Website</dt>
                <dd class="mt-1">
                  <a
                    href={@venture.url}
                    target="_blank"
                    rel="noopener noreferrer"
                    class="text-primary hover:underline"
                  >
                    {@venture.url}
                  </a>
                </dd>
              </div>
            <% end %>
            <%= if @venture.description do %>
              <div class="sm:col-span-2">
                <dt class="text-sm font-semibold text-base-content/60">Description</dt>
                <dd class="mt-1 text-base-content/80">{@venture.description}</dd>
              </div>
            <% end %>
          </dl>
        </div>
        
    <!-- SaaS Launchpad Roadmap -->
        <div class="mt-8">
          <div class="flex items-center gap-3 mb-6">
            <div class="flex h-10 w-10 items-center justify-center rounded-lg bg-primary/10">
              <svg class="h-5 w-5 text-primary" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                <path
                  stroke-linecap="round"
                  stroke-linejoin="round"
                  stroke-width="2"
                  d="M9 5H7a2 2 0 00-2 2v12a2 2 0 002 2h10a2 2 0 002-2V7a2 2 0 00-2-2h-2M9 5a2 2 0 002 2h2a2 2 0 002-2M9 5a2 2 0 012-2h2a2 2 0 012 2m-3 7h3m-3 4h3m-6-4h.01M9 16h.01"
                />
              </svg>
            </div>
            <div>
              <h2 class="text-xl font-bold text-base-content">SaaS Launchpad</h2>
              <p class="text-sm text-base-content/60">
                Recommended tools to help you build and grow your venture
              </p>
            </div>
          </div>
          <.roadmap roadmap={@roadmap} user_links={@venture.links} />
        </div>
      </div>
    </div>

    <!-- Add/Edit Link Modal -->
    <%= if @show_link_modal do %>
      <div class="modal modal-open">
        <div class="modal-box">
          <h3 class="font-bold text-lg mb-4">
            {if @editing_link, do: "Edit Link", else: "Add Link"}
          </h3>
          <.form for={@link_form} phx-submit="save_link" phx-change="validate_link" class="space-y-4">
            <div class="form-control">
              <label class="label">
                <span class="label-text font-semibold">Name</span>
              </label>
              <input
                type="text"
                name={@link_form[:name].name}
                value={@link_form[:name].value}
                class={"input input-bordered #{if @link_form[:name].errors != [], do: "input-error"}"}
                placeholder="e.g., GitHub Codespace"
                required
              />
              <%= if @link_form[:name].errors != [] do %>
                <label class="label">
                  <span class="label-text-alt text-error">{error_message(@link_form[:name])}</span>
                </label>
              <% end %>
            </div>

            <div class="form-control">
              <label class="label">
                <span class="label-text font-semibold">URL</span>
              </label>
              <input
                type="url"
                name={@link_form[:url].name}
                value={@link_form[:url].value}
                class={"input input-bordered #{if @link_form[:url].errors != [], do: "input-error"}"}
                placeholder="https://..."
                required
              />
              <%= if @link_form[:url].errors != [] do %>
                <label class="label">
                  <span class="label-text-alt text-error">{error_message(@link_form[:url])}</span>
                </label>
              <% end %>
            </div>

            <div class="form-control">
              <label class="label">
                <span class="label-text font-semibold">Category</span>
              </label>
              <select
                name={@link_form[:category].name}
                class="select select-bordered"
                required
              >
                <%= for {label, value} <- VentureLink.category_labels() do %>
                  <option value={value} selected={@link_form[:category].value == value}>
                    {label}
                  </option>
                <% end %>
              </select>
            </div>

            <div class="form-control">
              <label class="label">
                <span class="label-text font-semibold">Description (optional)</span>
              </label>
              <input
                type="text"
                name={@link_form[:description].name}
                value={@link_form[:description].value}
                class="input input-bordered"
                placeholder="Brief description..."
              />
            </div>

            <div class="modal-action">
              <button type="button" phx-click="close_modal" class="btn btn-ghost">Cancel</button>
              <button type="submit" class="btn btn-primary">
                {if @editing_link, do: "Update Link", else: "Add Link"}
              </button>
            </div>
          </.form>
        </div>
        <div class="modal-backdrop" phx-click="close_modal"></div>
      </div>
    <% end %>
    """
  end

  # Category icons aligned with Launchpad categories
  defp category_icon(assigns) do
    assigns = assign_new(assigns, :class, fn -> "h-5 w-5 text-base-content/60" end)

    ~H"""
    <%= case @category do %>
      <% "legal" -> %>
        <%!-- Scale icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M3 6l3 1m0 0l-3 9a5.002 5.002 0 006.001 0M6 7l3 9M6 7l6-2m6 2l3-1m-3 1l-3 9a5.002 5.002 0 006.001 0M18 7l3 9m-3-9l-6-2m0-2v2m0 16V5m0 16H9m3 0h3"
          />
        </svg>
      <% "banking" -> %>
        <%!-- Banknotes icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M17 9V7a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2m2 4h10a2 2 0 002-2v-6a2 2 0 00-2-2H9a2 2 0 00-2 2v6a2 2 0 002 2zm7-5a2 2 0 11-4 0 2 2 0 014 0z"
          />
        </svg>
      <% "domains" -> %>
        <%!-- Globe icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M21 12a9 9 0 01-9 9m9-9a9 9 0 00-9-9m9 9H3m9 9a9 9 0 01-9-9m9 9c1.657 0 3-4.03 3-9s-1.343-9-3-9m0 18c-1.657 0-3-4.03-3-9s1.343-9 3-9m-9 9a9 9 0 019-9"
          />
        </svg>
      <% "learning" -> %>
        <%!-- Academic cap icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M12 14l9-5-9-5-9 5 9 5z"
          />
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M12 14l6.16-3.422a12.083 12.083 0 01.665 6.479A11.952 11.952 0 0012 20.055a11.952 11.952 0 00-6.824-2.998 12.078 12.078 0 01.665-6.479L12 14z"
          />
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M12 14l9-5-9-5-9 5 9 5zm0 0l6.16-3.422a12.083 12.083 0 01.665 6.479A11.952 11.952 0 0012 20.055a11.952 11.952 0 00-6.824-2.998 12.078 12.078 0 01.665-6.479L12 14zm-4 6v-7.5l4-2.222"
          />
        </svg>
      <% "planning-design" -> %>
        <%!-- Squares icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M4 5a1 1 0 011-1h4a1 1 0 011 1v4a1 1 0 01-1 1H5a1 1 0 01-1-1V5zM14 5a1 1 0 011-1h4a1 1 0 011 1v4a1 1 0 01-1 1h-4a1 1 0 01-1-1V5zM4 15a1 1 0 011-1h4a1 1 0 011 1v4a1 1 0 01-1 1H5a1 1 0 01-1-1v-4zM14 15a1 1 0 011-1h4a1 1 0 011 1v4a1 1 0 01-1 1h-4a1 1 0 01-1-1v-4z"
          />
        </svg>
      <% "code-repos" -> %>
        <%!-- Code bracket icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M10 20l4-16m4 4l4 4-4 4M6 16l-4-4 4-4"
          />
        </svg>
      <% "workspace" -> %>
        <%!-- Computer desktop icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
          />
        </svg>
      <% "ai-tools" -> %>
        <%!-- Sparkles icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M5 3v4M3 5h4M6 17v4m-2-2h4m5-16l2.286 6.857L21 12l-5.714 2.143L13 21l-2.286-6.857L5 12l5.714-2.143L13 3z"
          />
        </svg>
      <% "hosting" -> %>
        <%!-- Server icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M5 12h14M5 12a2 2 0 01-2-2V6a2 2 0 012-2h14a2 2 0 012 2v4a2 2 0 01-2 2M5 12a2 2 0 00-2 2v4a2 2 0 002 2h14a2 2 0 002-2v-4a2 2 0 00-2-2m-2-4h.01M17 16h.01"
          />
        </svg>
      <% "ci-cd" -> %>
        <%!-- Arrow path icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M4 4v5h.582m15.356 2A8.001 8.001 0 004.582 9m0 0H9m11 11v-5h-.581m0 0a8.003 8.003 0 01-15.357-2m15.357 2H15"
          />
        </svg>
      <% "email" -> %>
        <%!-- Envelope icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
          />
        </svg>
      <% "error-monitoring" -> %>
        <%!-- Exclamation triangle icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M12 9v2m0 4h.01m-6.938 4h13.856c1.54 0 2.502-1.667 1.732-3L13.732 4c-.77-1.333-2.694-1.333-3.464 0L3.34 16c-.77 1.333.192 3 1.732 3z"
          />
        </svg>
      <% "customer-support" -> %>
        <%!-- Chat bubble icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M8 12h.01M12 12h.01M16 12h.01M21 12c0 4.418-4.03 8-9 8a9.863 9.863 0 01-4.255-.949L3 20l1.395-3.72C3.512 15.042 3 13.574 3 12c0-4.418 4.03-8 9-8s9 3.582 9 8z"
          />
        </svg>
      <% "analytics" -> %>
        <%!-- Chart pie icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
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
      <% "marketing-ads" -> %>
        <%!-- Megaphone icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M11 5.882V19.24a1.76 1.76 0 01-3.417.592l-2.147-6.15M18 13a3 3 0 100-6M5.436 13.683A4.001 4.001 0 017 6h1.832c4.1 0 7.625-1.234 9.168-3v14c-1.543-1.766-5.067-3-9.168-3H7a3.988 3.988 0 01-1.564-.317z"
          />
        </svg>
      <% "social-media" -> %>
        <%!-- Share icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M8.684 13.342C8.886 12.938 9 12.482 9 12c0-.482-.114-.938-.316-1.342m0 2.684a3 3 0 110-2.684m0 2.684l6.632 3.316m-6.632-6l6.632-3.316m0 0a3 3 0 105.367-2.684 3 3 0 00-5.367 2.684zm0 9.316a3 3 0 105.368 2.684 3 3 0 00-5.368-2.684z"
          />
        </svg>
      <% "crm-email-marketing" -> %>
        <%!-- User group icon --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M17 20h5v-2a3 3 0 00-5.356-1.857M17 20H7m10 0v-2c0-.656-.126-1.283-.356-1.857M7 20H2v-2a3 3 0 015.356-1.857M7 20v-2c0-.656.126-1.283.356-1.857m0 0a5.002 5.002 0 019.288 0M15 7a3 3 0 11-6 0 3 3 0 016 0zm6 3a2 2 0 11-4 0 2 2 0 014 0zM7 10a2 2 0 11-4 0 2 2 0 014 0z"
          />
        </svg>
      <% _ -> %>
        <%!-- Default link icon for "other" or unknown categories --%>
        <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
          <path
            stroke-linecap="round"
            stroke-linejoin="round"
            stroke-width="2"
            d="M13.828 10.172a4 4 0 00-5.656 0l-4 4a4 4 0 105.656 5.656l1.102-1.101m-.758-4.899a4 4 0 005.656 0l4-4a4 4 0 00-5.656-5.656l-1.1 1.1"
          />
        </svg>
    <% end %>
    """
  end

  defp category_label(category) do
    VentureLink.category_labels()
    |> Enum.find(fn {_label, value} -> value == category end)
    |> case do
      {label, _} -> label
      nil -> String.capitalize(category)
    end
  end

  defp status_badge_color("active"), do: "success"
  defp status_badge_color("inactive"), do: "ghost"
  defp status_badge_color("coming_soon"), do: "warning"
  defp status_badge_color(_), do: "ghost"

  defp error_message(field) do
    case field.errors do
      [{msg, _} | _] -> msg
      _ -> nil
    end
  end

  @impl true
  def mount(%{"id" => id}, _session, socket) do
    venture = Ventures.get_venture_with_links!(socket.assigns.current_scope, id)
    links_by_category = Ventures.get_links_by_category(venture)
    roadmap = Launchpad.get_roadmap()

    {:ok,
     socket
     |> assign(:page_title, venture.name)
     |> assign(:venture, venture)
     |> assign(:links_by_category, links_by_category)
     |> assign(:roadmap, roadmap)
     |> assign(:show_link_modal, false)
     |> assign(:editing_link, nil)
     |> assign(:link_form, nil)}
  end

  @impl true
  def handle_event("show_add_link", _params, socket) do
    changeset =
      Ventures.change_venture_link(socket.assigns.current_scope, %VentureLink{
        venture_id: socket.assigns.venture.id,
        category: "code-repos"
      })

    {:noreply,
     socket
     |> assign(:show_link_modal, true)
     |> assign(:editing_link, nil)
     |> assign(:link_form, to_form(changeset))}
  end

  def handle_event("edit_link", %{"id" => id}, socket) do
    link = Ventures.get_venture_link!(socket.assigns.current_scope, id)
    changeset = Ventures.change_venture_link(socket.assigns.current_scope, link)

    {:noreply,
     socket
     |> assign(:show_link_modal, true)
     |> assign(:editing_link, link)
     |> assign(:link_form, to_form(changeset))}
  end

  def handle_event("close_modal", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_link_modal, false)
     |> assign(:editing_link, nil)
     |> assign(:link_form, nil)}
  end

  def handle_event("validate_link", %{"venture_link" => link_params}, socket) do
    link = socket.assigns.editing_link || %VentureLink{venture_id: socket.assigns.venture.id}

    changeset =
      Ventures.change_venture_link(socket.assigns.current_scope, link, link_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :link_form, to_form(changeset))}
  end

  def handle_event("save_link", %{"venture_link" => link_params}, socket) do
    link_params = Map.put(link_params, "venture_id", socket.assigns.venture.id)

    result =
      if socket.assigns.editing_link do
        Ventures.update_venture_link(
          socket.assigns.current_scope,
          socket.assigns.editing_link,
          link_params
        )
      else
        Ventures.create_venture_link(socket.assigns.current_scope, link_params)
      end

    case result do
      {:ok, _link} ->
        venture =
          Ventures.get_venture_with_links!(
            socket.assigns.current_scope,
            socket.assigns.venture.id
          )

        links_by_category = Ventures.get_links_by_category(venture)

        {:noreply,
         socket
         |> assign(:venture, venture)
         |> assign(:links_by_category, links_by_category)
         |> assign(:show_link_modal, false)
         |> assign(:editing_link, nil)
         |> assign(:link_form, nil)
         |> put_flash(
           :info,
           if(socket.assigns.editing_link, do: "Link updated", else: "Link added")
         )}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :link_form, to_form(changeset))}
    end
  end

  def handle_event("delete_link", %{"id" => id}, socket) do
    link = Ventures.get_venture_link!(socket.assigns.current_scope, id)
    {:ok, _} = Ventures.delete_venture_link(socket.assigns.current_scope, link)

    venture =
      Ventures.get_venture_with_links!(socket.assigns.current_scope, socket.assigns.venture.id)

    links_by_category = Ventures.get_links_by_category(venture)

    {:noreply,
     socket
     |> assign(:venture, venture)
     |> assign(:links_by_category, links_by_category)
     |> put_flash(:info, "Link deleted")}
  end
end
