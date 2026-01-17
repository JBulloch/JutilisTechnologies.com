defmodule JutilisWeb.UserSessionHTML do
  use JutilisWeb, :html

  embed_templates "user_session_html/*"

  defp local_mail_adapter? do
    Application.get_env(:jutilis, Jutilis.Mailer)[:adapter] == Swoosh.Adapters.Local
  end
end
