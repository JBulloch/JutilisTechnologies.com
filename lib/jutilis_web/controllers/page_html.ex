defmodule JutilisWeb.PageHTML do
  @moduledoc """
  This module contains pages rendered by PageController.

  See the `page_html` directory for all templates available.
  """
  use JutilisWeb, :html

  embed_templates "page_html/*"

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
end
