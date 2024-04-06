defmodule ShortexWeb.HomeLive do
  use ShortexWeb, :live_view

  @impl true
  def mount(_params, _session, socket) do
    url = ""
    {:ok, assign(socket, url: url), layout: false}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.flash_group flash={@flash} />
    <div>
      <h1>ShortEx</h1>
      <div>Enter your URL</div>
      <div class="flex align-center">
      <.input class="" name="Enter" value={@url} />
      <.button phx-click="generate">Generate</.button>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("generate", _params, %{"url" => url} = socket) do
    IO.inspect(url)
    {:noreply, socket}
  end
end
