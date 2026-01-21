defmodule JutilisWeb.UserTwoFactorLive do
  @moduledoc """
  LiveView for 2FA verification during login.

  Handles both TOTP (authenticator app) and email OTP verification methods.
  """
  use JutilisWeb, :live_view

  alias Jutilis.Accounts
  import JutilisWeb.AuthComponents

  # =============================================================================
  # Render
  # =============================================================================

  def render(assigns) do
    ~H"""
    <.auth_card>
      <.auth_header
        title="Two-Factor Authentication"
        subtitle={verification_subtitle(@method)}
        icon="lock"
      />

      <.verification_form form={@form} error={@error} />

      <div class="divider my-6">OR</div>

      <.alternative_actions method={@method} />
    </.auth_card>

    <.backup_code_modal
      :if={@show_backup_modal}
      form={@backup_form}
      error={@backup_error}
    />
    """
  end

  # =============================================================================
  # Sub-components
  # =============================================================================

  defp verification_subtitle(:totp), do: "Enter the code from your authenticator app"
  defp verification_subtitle(:email), do: "Enter the code sent to your email"
  defp verification_subtitle(_), do: "Enter your verification code"

  attr :form, :map, required: true
  attr :error, :string

  defp verification_form(assigns) do
    ~H"""
    <.form for={@form} phx-submit="verify" class="space-y-6">
      <.code_input
        name="code"
        value={@form[:code].value}
        error={@error}
        placeholder="000000"
        maxlength="8"
      />

      <button type="submit" class="btn btn-primary w-full" phx-disable-with="Verifying...">
        Verify
      </button>
    </.form>
    """
  end

  attr :method, :atom, required: true

  defp alternative_actions(assigns) do
    ~H"""
    <div class="space-y-3">
      <.ghost_button :if={@method == :totp} phx-click="use_backup_code">
        Use a backup code
      </.ghost_button>

      <.ghost_button :if={@method == :email} phx-click="resend_code" phx-disable-with="Sending...">
        Resend code to email
      </.ghost_button>

      <.link navigate={~p"/users/log-in"} class="btn btn-ghost btn-sm w-full">
        Cancel and go back
      </.link>
    </div>
    """
  end

  attr :form, :map, required: true
  attr :error, :string

  defp backup_code_modal(assigns) do
    ~H"""
    <.modal title="Use Backup Code" on_close="close_backup_modal">
      <.form for={@form} phx-submit="verify_backup" class="space-y-4">
        <.code_input
          name="backup_code"
          value=""
          error={@error}
          label="Backup Code"
          placeholder="12345678"
          maxlength="8"
        />

        <div class="modal-action">
          <button type="button" phx-click="close_backup_modal" class="btn btn-ghost">
            Cancel
          </button>
          <button type="submit" class="btn btn-primary">
            Verify Backup Code
          </button>
        </div>
      </.form>
    </.modal>
    """
  end

  # =============================================================================
  # Lifecycle
  # =============================================================================

  def mount(_params, session, socket) do
    case get_pending_user(session) do
      {:ok, user, return_to} ->
        {:ok, initialize_socket(socket, user, return_to)}

      :error ->
        {:ok, push_navigate(socket, to: ~p"/users/log-in")}
    end
  end

  # =============================================================================
  # Event Handlers
  # =============================================================================

  def handle_event("verify", %{"code" => code}, socket) do
    case verify_code(socket.assigns.user, socket.assigns.method, code) do
      :ok ->
        {:noreply, redirect(socket, to: ~p"/users/two-factor/complete")}

      :error ->
        {:noreply, assign(socket, :error, "Invalid code. Please try again.")}
    end
  end

  def handle_event("use_backup_code", _params, socket) do
    {:noreply,
     socket
     |> assign(:show_backup_modal, true)
     |> assign(:backup_error, nil)}
  end

  def handle_event("close_backup_modal", _params, socket) do
    {:noreply, assign(socket, :show_backup_modal, false)}
  end

  def handle_event("verify_backup", %{"backup_code" => code}, socket) do
    case Accounts.verify_backup_code(socket.assigns.user, code) do
      :ok ->
        {:noreply, redirect(socket, to: ~p"/users/two-factor/complete")}

      :error ->
        {:noreply, assign(socket, :backup_error, "Invalid backup code")}
    end
  end

  def handle_event("resend_code", _params, socket) do
    Accounts.send_email_otp(socket.assigns.user, "login")

    {:noreply, put_flash(socket, :info, "A new code has been sent to your email")}
  end

  # =============================================================================
  # Private Helpers
  # =============================================================================

  defp get_pending_user(session) do
    case session["pending_2fa_user_id"] do
      nil ->
        :error

      user_id ->
        user = Accounts.get_user!(user_id)
        return_to = session["pending_2fa_return_to"] || ~p"/admin/dashboard"
        {:ok, user, return_to}
    end
  end

  defp initialize_socket(socket, user, return_to) do
    method = Accounts.get_2fa_method(user)

    socket
    |> assign(:user, user)
    |> assign(:method, method)
    |> assign(:return_to, return_to)
    |> assign(:form, to_form(%{"code" => ""}))
    |> assign(:error, nil)
    |> assign(:show_backup_modal, false)
    |> assign(:backup_form, to_form(%{"backup_code" => ""}))
    |> assign(:backup_error, nil)
    |> maybe_send_email_otp(method)
  end

  defp maybe_send_email_otp(socket, :email) do
    # Only send email on connected mount, and track to prevent duplicates
    socket = assign_new(socket, :email_sent, fn -> false end)

    if connected?(socket) and not socket.assigns.email_sent do
      Accounts.send_email_otp(socket.assigns.user, "login")
      assign(socket, :email_sent, true)
    else
      socket
    end
  end

  defp maybe_send_email_otp(socket, _method), do: socket

  defp verify_code(user, :totp, code), do: Accounts.verify_totp_code(user, code)
  defp verify_code(user, :email, code), do: Accounts.verify_email_otp(user, code, "login")
end
