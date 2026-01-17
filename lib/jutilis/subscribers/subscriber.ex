defmodule Jutilis.Subscribers.Subscriber do
  use Ecto.Schema
  import Ecto.Changeset

  schema "subscribers" do
    field :email, :string
    field :name, :string
    field :subscribed_at, :utc_datetime

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(subscriber, attrs) do
    subscriber
    |> cast(attrs, [:email, :name])
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must be a valid email address")
    |> unique_constraint(:email)
    |> put_subscribed_at()
  end

  defp put_subscribed_at(changeset) do
    if changeset.valid? and is_nil(get_field(changeset, :subscribed_at)) do
      put_change(changeset, :subscribed_at, DateTime.utc_now() |> DateTime.truncate(:second))
    else
      changeset
    end
  end
end
