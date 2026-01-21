defmodule JutilisWeb.UserSettingsTwoFactorLive do
  @moduledoc """
  LiveView for managing 2FA settings.
  """
  use JutilisWeb, :live_view

  alias Jutilis.Accounts

  def render(assigns) do
    ~H"""
    <div class="min-h-screen bg-base-100">
      <div class="mx-auto max-w-3xl px-6 py-8 lg:px-8">
        <div class="mb-8">
          <.link
            navigate={~p"/users/settings"}
            class="text-sm text-base-content/60 hover:text-primary flex items-center gap-1 mb-4"
          >
            <svg class="h-4 w-4" fill="none" viewBox="0 0 24 24" stroke="currentColor">
              <path
                stroke-linecap="round"
                stroke-linejoin="round"
                stroke-width="2"
                d="M15 19l-7-7 7-7"
              />
            </svg>
            Back to Settings
          </.link>
          <h1 class="text-3xl font-black text-base-content">Two-Factor Authentication</h1>
          <p class="text-base-content/60 mt-2">
            Add an extra layer of security to your account
          </p>
        </div>

        <%= if @two_factor_enabled do %>
          <!-- 2FA Enabled State -->
          <div class="rounded-2xl border-2 border-success bg-success/10 p-6 mb-6">
            <div class="flex items-center gap-4">
              <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-success/20 text-success">
                <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                  <path
                    stroke-linecap="round"
                    stroke-linejoin="round"
                    stroke-width="2"
                    d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
                  />
                </svg>
              </div>
              <div>
                <h3 class="font-bold text-success">2FA is enabled</h3>
                <p class="text-sm text-base-content/60">
                  Using: {if @method == :totp, do: "Authenticator app", else: "Email codes"}
                </p>
              </div>
            </div>
          </div>
          
    <!-- Backup Codes Section -->
          <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6 mb-6">
            <h2 class="text-lg font-bold text-base-content mb-4">Backup Codes</h2>
            <p class="text-base-content/60 mb-4">
              Backup codes can be used to access your account if you lose your device.
              Each code can only be used once.
            </p>
            <%= if @backup_codes do %>
              <div class="bg-base-200 rounded-xl p-4 mb-4">
                <p class="text-sm font-semibold text-warning mb-2">
                  Save these codes in a safe place. They won't be shown again!
                </p>
                <div class="grid grid-cols-2 gap-2 font-mono text-sm">
                  <%= for code <- @backup_codes do %>
                    <div class="bg-base-100 px-3 py-2 rounded-lg text-center">
                      {String.pad_leading(Integer.to_string(code), 8, "0")}
                    </div>
                  <% end %>
                </div>
              </div>
              <button phx-click="hide_backup_codes" class="btn btn-ghost btn-sm">
                I've saved my codes
              </button>
            <% else %>
              <button phx-click="generate_backup_codes" class="btn btn-outline btn-sm">
                Generate New Backup Codes
              </button>
            <% end %>
          </div>
          
    <!-- Disable 2FA -->
          <div class="rounded-2xl border-2 border-error/30 bg-base-100 p-6">
            <h2 class="text-lg font-bold text-base-content mb-2">Disable 2FA</h2>
            <p class="text-base-content/60 mb-4">
              This will remove the extra security from your account.
            </p>
            <button
              phx-click="disable_2fa"
              data-confirm="Are you sure you want to disable two-factor authentication? This will make your account less secure."
              class="btn btn-error btn-outline btn-sm"
            >
              Disable Two-Factor Authentication
            </button>
          </div>
        <% else %>
          <!-- 2FA Setup Options -->
          <div class="space-y-6">
            <!-- TOTP Option -->
            <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
              <div class="flex items-start gap-4">
                <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-primary/20 text-primary flex-shrink-0">
                  <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M12 18h.01M8 21h8a2 2 0 002-2V5a2 2 0 00-2-2H8a2 2 0 00-2 2v14a2 2 0 002 2z"
                    />
                  </svg>
                </div>
                <div class="flex-1">
                  <h3 class="font-bold text-base-content">Authenticator App</h3>
                  <p class="text-sm text-base-content/60 mb-4">
                    Use an app like Google Authenticator, Authy, or 1Password to generate codes.
                    This is the most secure option.
                  </p>
                  <%= if @setup_mode == :totp do %>
                    <div class="bg-base-200 rounded-xl p-4 mb-4">
                      <p class="text-sm font-semibold mb-3">
                        1. Scan this QR code with your authenticator app:
                      </p>
                      <div class="flex justify-center mb-4 bg-white p-4 rounded-lg w-fit mx-auto">
                        {Phoenix.HTML.raw(@qr_code)}
                      </div>
                      <p class="text-xs text-base-content/60 text-center mb-4">
                        Or enter this key manually:
                        <code class="bg-base-300 px-2 py-1 rounded">
                          {Base.encode32(@totp_secret, padding: false)}
                        </code>
                      </p>
                      <p class="text-sm font-semibold mb-2">
                        2. Enter the 6-digit code from your app:
                      </p>
                      <.form for={@form} phx-submit="verify_totp" class="flex gap-2">
                        <input
                          type="text"
                          name="code"
                          class={"input input-bordered flex-1 font-mono text-center #{if @error, do: "input-error"}"}
                          placeholder="000000"
                          maxlength="6"
                          inputmode="numeric"
                        />
                        <button type="submit" class="btn btn-primary">Verify</button>
                      </.form>
                      <%= if @error do %>
                        <p class="text-sm text-error mt-2">{@error}</p>
                      <% end %>
                    </div>
                    <button phx-click="cancel_setup" class="btn btn-ghost btn-sm">Cancel</button>
                  <% else %>
                    <button phx-click="start_totp_setup" class="btn btn-primary btn-sm">
                      Set up Authenticator
                    </button>
                  <% end %>
                </div>
              </div>
            </div>
            
    <!-- Email OTP Option -->
            <div class="rounded-2xl border-2 border-base-300 bg-base-100 p-6">
              <div class="flex items-start gap-4">
                <div class="flex h-12 w-12 items-center justify-center rounded-xl bg-secondary/20 text-secondary flex-shrink-0">
                  <svg class="h-6 w-6" fill="none" viewBox="0 0 24 24" stroke="currentColor">
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                    />
                  </svg>
                </div>
                <div class="flex-1">
                  <h3 class="font-bold text-base-content">Email Codes</h3>
                  <p class="text-sm text-base-content/60 mb-4">
                    Receive a verification code via email each time you log in.
                    Less secure but doesn't require an additional app.
                  </p>
                  <button phx-click="enable_email_2fa" class="btn btn-secondary btn-sm">
                    Enable Email Codes
                  </button>
                </div>
              </div>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    user = socket.assigns.current_scope.user

    {:ok,
     socket
     |> assign(:user, user)
     |> assign(:two_factor_enabled, user.two_factor_enabled)
     |> assign(:method, Accounts.get_2fa_method(user))
     |> assign(:setup_mode, nil)
     |> assign(:totp_secret, nil)
     |> assign(:qr_code, nil)
     |> assign(:form, to_form(%{"code" => ""}))
     |> assign(:error, nil)
     |> assign(:backup_codes, nil)}
  end

  def handle_event("start_totp_setup", _params, socket) do
    secret = Accounts.generate_totp_secret()
    qr_code = Accounts.generate_totp_qr_code(socket.assigns.user, secret)

    {:noreply,
     socket
     |> assign(:setup_mode, :totp)
     |> assign(:totp_secret, secret)
     |> assign(:qr_code, qr_code)
     |> assign(:error, nil)}
  end

  def handle_event("cancel_setup", _params, socket) do
    {:noreply,
     socket
     |> assign(:setup_mode, nil)
     |> assign(:totp_secret, nil)
     |> assign(:qr_code, nil)}
  end

  def handle_event("verify_totp", %{"code" => code}, socket) do
    case Accounts.enable_totp_2fa(socket.assigns.user, socket.assigns.totp_secret, code) do
      {:ok, user} ->
        # Generate backup codes
        {:ok, codes} = Accounts.generate_backup_codes(user)

        {:noreply,
         socket
         |> assign(:user, user)
         |> assign(:two_factor_enabled, true)
         |> assign(:method, :totp)
         |> assign(:setup_mode, nil)
         |> assign(:totp_secret, nil)
         |> assign(:qr_code, nil)
         |> assign(:backup_codes, codes)
         |> put_flash(:info, "Two-factor authentication enabled successfully!")}

      {:error, :invalid_code} ->
        {:noreply, assign(socket, :error, "Invalid code. Please try again.")}
    end
  end

  def handle_event("enable_email_2fa", _params, socket) do
    case Accounts.enable_email_2fa(socket.assigns.user) do
      {:ok, user} ->
        # Generate backup codes
        {:ok, codes} = Accounts.generate_backup_codes(user)

        {:noreply,
         socket
         |> assign(:user, user)
         |> assign(:two_factor_enabled, true)
         |> assign(:method, :email)
         |> assign(:backup_codes, codes)
         |> put_flash(:info, "Email-based two-factor authentication enabled!")}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Failed to enable 2FA")}
    end
  end

  def handle_event("disable_2fa", _params, socket) do
    case Accounts.disable_2fa(socket.assigns.user) do
      {:ok, user} ->
        {:noreply,
         socket
         |> assign(:user, user)
         |> assign(:two_factor_enabled, false)
         |> assign(:method, nil)
         |> assign(:backup_codes, nil)
         |> put_flash(:info, "Two-factor authentication has been disabled")}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Failed to disable 2FA")}
    end
  end

  def handle_event("generate_backup_codes", _params, socket) do
    case Accounts.generate_backup_codes(socket.assigns.user) do
      {:ok, codes} ->
        {:noreply, assign(socket, :backup_codes, codes)}

      {:error, _} ->
        {:noreply, put_flash(socket, :error, "Failed to generate backup codes")}
    end
  end

  def handle_event("hide_backup_codes", _params, socket) do
    {:noreply, assign(socket, :backup_codes, nil)}
  end
end
