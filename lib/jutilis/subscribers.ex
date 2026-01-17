defmodule Jutilis.Subscribers do
  @moduledoc """
  The Subscribers context for managing investor email list.
  """

  import Ecto.Query, warn: false
  alias Jutilis.Repo
  alias Jutilis.Subscribers.Subscriber

  @doc """
  Returns all subscribers.
  """
  def list_subscribers do
    Repo.all(from s in Subscriber, order_by: [desc: s.subscribed_at])
  end

  @doc """
  Gets a single subscriber by id.
  """
  def get_subscriber!(id), do: Repo.get!(Subscriber, id)

  @doc """
  Gets a subscriber by email.
  """
  def get_subscriber_by_email(email) do
    Repo.get_by(Subscriber, email: String.downcase(email))
  end

  @doc """
  Creates a subscriber.
  """
  def create_subscriber(attrs \\ %{}) do
    attrs = normalize_email(attrs)

    %Subscriber{}
    |> Subscriber.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Deletes a subscriber.
  """
  def delete_subscriber(%Subscriber{} = subscriber) do
    Repo.delete(subscriber)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking subscriber changes.
  """
  def change_subscriber(%Subscriber{} = subscriber, attrs \\ %{}) do
    Subscriber.changeset(subscriber, attrs)
  end

  defp normalize_email(%{"email" => email} = attrs) when is_binary(email) do
    Map.put(attrs, "email", String.downcase(String.trim(email)))
  end

  defp normalize_email(%{email: email} = attrs) when is_binary(email) do
    Map.put(attrs, :email, String.downcase(String.trim(email)))
  end

  defp normalize_email(attrs), do: attrs
end
