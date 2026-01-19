defmodule JutilisWeb.UrlHelpers do
  @moduledoc """
  Helpers for building URLs dynamically based on the request context.

  This is useful in development environments like GitHub Codespaces where
  the app is accessed via a forwarded URL that differs from localhost.
  """

  @doc """
  Builds a full URL from the connection's host and a path.

  In development, this uses the request's scheme and host to build URLs
  that work with port forwarding (e.g., Codespaces).

  ## Examples

      iex> url_from_conn(conn, "/users/log-in/abc123")
      "https://xxx-4000.app.github.dev/users/log-in/abc123"

  """
  def url_from_conn(conn, path) do
    scheme = get_scheme(conn)
    host = get_host(conn)
    port = get_port(conn, scheme)

    port_suffix =
      case {scheme, port} do
        {"https", 443} -> ""
        {"http", 80} -> ""
        {_, port} -> ":#{port}"
      end

    "#{scheme}://#{host}#{port_suffix}#{path}"
  end

  defp get_scheme(conn) do
    # Check for forwarded proto header (used by proxies/load balancers)
    case Plug.Conn.get_req_header(conn, "x-forwarded-proto") do
      [proto | _] -> proto
      [] -> to_string(conn.scheme)
    end
  end

  defp get_host(conn) do
    # Check for forwarded host header (used by proxies like Codespaces, Cloudflare, etc.)
    case Plug.Conn.get_req_header(conn, "x-forwarded-host") do
      [host | _] -> host
      [] -> conn.host
    end
  end

  defp get_port(conn, _scheme) do
    # Check for forwarded port header
    case Plug.Conn.get_req_header(conn, "x-forwarded-port") do
      [port | _] ->
        String.to_integer(port)

      [] ->
        # If using https with a non-standard port, check if we're behind a proxy
        # In Codespaces, the forwarded port is typically 443
        case Plug.Conn.get_req_header(conn, "x-forwarded-proto") do
          ["https" | _] -> 443
          _ -> conn.port
        end
    end
  end
end
