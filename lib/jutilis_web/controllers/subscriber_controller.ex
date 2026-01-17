defmodule JutilisWeb.SubscriberController do
  use JutilisWeb, :controller

  alias Jutilis.Subscribers

  def create(conn, %{"subscriber" => subscriber_params}) do
    case Subscribers.create_subscriber(subscriber_params) do
      {:ok, _subscriber} ->
        conn
        |> put_flash(
          :info,
          "Thanks for subscribing! We'll keep you updated on investment opportunities."
        )
        |> redirect(to: ~p"/")

      {:error, %Ecto.Changeset{} = changeset} ->
        error_message =
          case changeset.errors[:email] do
            {"has already been taken", _} -> "This email is already subscribed."
            {msg, _} -> msg
            nil -> "Could not subscribe. Please try again."
          end

        conn
        |> put_flash(:error, error_message)
        |> redirect(to: ~p"/")
    end
  end
end
