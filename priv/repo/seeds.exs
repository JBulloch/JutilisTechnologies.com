# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Jutilis.Repo.insert!(%Jutilis.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Jutilis.Repo
alias Jutilis.Accounts.User

# Create admin user
admin_email = "jbulloch@jutilistechnologies.com"

unless Repo.get_by(User, email: admin_email) do
  {:ok, admin} =
    %User{}
    |> User.email_changeset(%{email: admin_email})
    |> User.password_changeset(%{password: "admin123456789"})
    |> Ecto.Changeset.put_change(:admin_flag, true)
    |> Ecto.Changeset.put_change(:confirmed_at, DateTime.utc_now(:second))
    |> Repo.insert()

  IO.puts("✓ Created admin user:")
  IO.puts("  Email: #{admin.email}")
  IO.puts("  Password: admin123456789")
  IO.puts("  IMPORTANT: Change this password after first login!")
else
  IO.puts("⚠ Admin user already exists")
end
