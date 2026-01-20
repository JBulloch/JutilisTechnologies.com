defmodule JutilisWeb.AuthComponents do
  @moduledoc """
  UI components for authentication flows including 2FA verification.
  """
  use Phoenix.Component
  use JutilisWeb, :verified_routes

  @doc """
  Renders a centered auth card container.
  """
  attr :class, :string, default: nil
  slot :inner_block, required: true

  def auth_card(assigns) do
    ~H"""
    <div class="min-h-screen flex items-center justify-center bg-base-200 px-4">
      <div class="w-full max-w-md">
        <div class={["rounded-2xl border-2 border-base-300 bg-base-100 p-8 shadow-xl", @class]}>
          {render_slot(@inner_block)}
        </div>
      </div>
    </div>
    """
  end

  @doc """
  Renders an auth header with icon, title, and subtitle.
  """
  attr :title, :string, required: true
  attr :subtitle, :string, default: nil
  attr :icon, :string, default: "lock"

  def auth_header(assigns) do
    ~H"""
    <div class="text-center mb-8">
      <div class="flex h-16 w-16 mx-auto items-center justify-center rounded-2xl bg-primary/20 text-primary mb-4">
        <.auth_icon name={@icon} class="h-8 w-8" />
      </div>
      <h1 class="text-2xl font-black text-base-content">{@title}</h1>
      <p :if={@subtitle} class="text-base-content/60 mt-2">{@subtitle}</p>
    </div>
    """
  end

  @doc """
  Renders a verification code input field.
  """
  attr :name, :string, default: "code"
  attr :value, :string, default: ""
  attr :error, :string, default: nil
  attr :placeholder, :string, default: "000000"
  attr :maxlength, :string, default: "6"
  attr :label, :string, default: "Verification Code"

  def code_input(assigns) do
    ~H"""
    <div class="form-control">
      <label class="label">
        <span class="label-text font-semibold">{@label}</span>
      </label>
      <input
        type="text"
        name={@name}
        value={@value}
        class={[
          "input input-bordered input-lg text-center tracking-widest font-mono",
          @error && "input-error"
        ]}
        placeholder={@placeholder}
        maxlength={@maxlength}
        autocomplete="one-time-code"
        inputmode="numeric"
        autofocus
      />
      <label :if={@error} class="label">
        <span class="label-text-alt text-error">{@error}</span>
      </label>
    </div>
    """
  end

  @doc """
  Renders a ghost button for secondary actions.
  """
  attr :rest, :global, include: ~w(phx-click phx-disable-with type disabled)
  slot :inner_block, required: true

  def ghost_button(assigns) do
    ~H"""
    <button class="btn btn-ghost btn-sm w-full" {@rest}>
      {render_slot(@inner_block)}
    </button>
    """
  end

  @doc """
  Renders a modal dialog.
  """
  attr :title, :string, required: true
  attr :on_close, :string, required: true
  slot :inner_block, required: true

  def modal(assigns) do
    ~H"""
    <div class="modal modal-open">
      <div class="modal-box">
        <h3 class="font-bold text-lg mb-4">{@title}</h3>
        {render_slot(@inner_block)}
      </div>
      <div class="modal-backdrop" phx-click={@on_close}></div>
    </div>
    """
  end

  @doc """
  Renders auth-related icons.
  """
  attr :name, :string, required: true
  attr :class, :string, default: "h-6 w-6"

  def auth_icon(%{name: "lock"} = assigns) do
    ~H"""
    <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M12 15v2m-6 4h12a2 2 0 002-2v-6a2 2 0 00-2-2H6a2 2 0 00-2 2v6a2 2 0 002 2zm10-10V7a4 4 0 00-8 0v4h8z"
      />
    </svg>
    """
  end

  def auth_icon(%{name: "key"} = assigns) do
    ~H"""
    <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M15 7a2 2 0 012 2m4 0a6 6 0 01-7.743 5.743L11 17H9v2H7v2H4a1 1 0 01-1-1v-2.586a1 1 0 01.293-.707l5.964-5.964A6 6 0 1121 9z"
      />
    </svg>
    """
  end

  def auth_icon(assigns) do
    ~H"""
    <svg class={@class} fill="none" viewBox="0 0 24 24" stroke="currentColor">
      <path
        stroke-linecap="round"
        stroke-linejoin="round"
        stroke-width="2"
        d="M9 12l2 2 4-4m5.618-4.016A11.955 11.955 0 0112 2.944a11.955 11.955 0 01-8.618 3.04A12.02 12.02 0 003 9c0 5.591 3.824 10.29 9 11.622 5.176-1.332 9-6.03 9-11.622 0-1.042-.133-2.052-.382-3.016z"
      />
    </svg>
    """
  end
end
