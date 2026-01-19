defmodule JutilisWeb.PortfolioHTML do
  @moduledoc """
  HTML module for portfolio templates.

  Provides dynamic rendering of portfolio pages based on portfolio configuration.
  """

  use JutilisWeb, :html

  alias JutilisWeb.PortfolioComponents

  embed_templates "portfolio_html/*"
end
