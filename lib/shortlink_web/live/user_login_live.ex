defmodule ShortlinkWeb.UserLoginLive do
  use ShortlinkWeb, :live_view

  def render(assigns) do
    ~H"""
    <div class="mx-6">
      <!-- <.header class="text-center"> -->
      <!--   Log in to account -->
      <!--   <:subtitle> -->
      <!--     Don't have an account? -->
      <!--     <.link navigate={~p"/_/signup"} class="font-semibold text-brand hover:underline"> -->
      <!--       Sign up -->
      <!--     </.link> -->
      <!--     for an account now. -->
      <!--   </:subtitle> -->
      <!-- </.header> -->

      <div class="flex items-center justify-center gap-6 text-center">
        <div>
          <h1 class="text-lg font-semibold leading-8 text-zinc-800 dark:text-zinc-50">
            Log in to account
          </h1>
          <p class="mt-2 text-sm leading-6 text-zinc-600 dark:text-zinc-300">
            Don't have an account?
            <.link navigate={~p"/_/signup"} class="font-semibold text-brand hover:underline">
              Sign up
            </.link>
            for an account now.
          </p>
        </div>
        <div class="flex-none"></div>
      </div>

      <div class="max-w-96 m-auto">
        <.simple_form for={@form} id="login_form" action={~p"/_/login"} phx-update="ignore">
          <.input field={@form[:email]} type="email" label="Email" required />
          <.input field={@form[:password]} type="password" label="Password" required />

          <:actions>
            <.input field={@form[:remember_me]} type="checkbox" label="Keep me logged in" />
            <.link href={~p"/_/reset-password"} class="text-sm font-semibold">
              Forgot your password?
            </.link>
          </:actions>
          <:actions>
            <.button phx-disable-with="Logging in..." class="w-full">
              Log in <span aria-hidden="true">→</span>
            </.button>
          </:actions>
        </.simple_form>
      </div>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    email = Phoenix.Flash.get(socket.assigns.flash, :email)
    form = to_form(%{"email" => email}, as: "user")
    {:ok, assign(socket, form: form), temporary_assigns: [form: form]}
  end
end
