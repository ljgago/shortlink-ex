defmodule ShortlinkWeb.HomeLive do
  use ShortlinkWeb, :live_view

  alias Shortlink.Links

  @impl true
  def mount(_params, _session, socket) do
    form =
      to_form(%{
        "long_url" => nil,
        "short_url" => nil
      })

    {:ok, assign(socket, form: form)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <.flash_group flash={@flash} />
    <div class="mx-6 grid place-items-center">
      <div class="flex flex-col gap-2 md:w-[720px] w-full">
        <h1 class="py-20 text-center text-6xl">
          Shortlink
        </h1>
        <div class="flex flex-col gap-6">
          <.form for={@form} phx-submit="generate">
            <div class="flex flex-col gap-6">
              <div>
                <div class="mb-2">
                  <.icon name="hero-link-micro" /> Your Long URL
                </div>
                <.input
                  id="long-url-id"
                  type="text"
                  autocomplete="off"
                  readonly={@form[:short_url].value != nil}
                  field={@form[:long_url]}
                />
              </div>

              <%= if @form[:short_url].value != nil do %>
                <div>
                  <div class="mb-2">
                    <.icon name="hero-sparkles-micro" /> Your Short URL
                  </div>
                  <.input
                    id="short-url-id"
                    type="text"
                    autocomplete="off"
                    name="result"
                    readonly={@form[:short_url].value != nil}
                    field={@form[:short_url]}
                  />
                </div>
              <% end %>

              <%= if @form[:short_url].value == nil do %>
                <.button type="submit" class="h-[42px]">
                  Shorten URL
                </.button>
              <% else %>
                <div class="grid grid grid-cols-[1fr,1fr] justify-stretch gap-2">
                  <.button type="reset" class="h-[42px]" phx-click="new-url">
                    New URL
                  </.button>
                  <.button
                    id="copy"
                    class="h-[42px]"
                    data-to="#short-url-id"
                    phx-hook="Copy"
                    phx-click="copy-clipboard"
                    value={@form[:short_url].value}
                  >
                    Copy to Clipboard
                  </.button>
                </div>
              <% end %>
            </div>
          </.form>
        </div>
      </div>
    </div>
    """
  end

  @impl true
  def handle_event("generate", params, socket) do
    {:noreply, generate_link(socket, params)}
  end

  def handle_event("new-url", _params, socket) do
    form =
      to_form(%{
        "long_url" => nil,
        "short_url" => nil
      })

    {:noreply, assign(socket, form: form)}
  end

  def handle_event("copy-clipboard", %{"value" => short_url}, socket) do
    Process.send_after(self(), :clear_flash, 5000)

    {:noreply, put_flash(socket, :info, "Short URL Copied: #{short_url}")}
  end

  @impl true
  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  defp generate_link(socket, %{"long_url" => long_url} = params) do
    %{
      long_url: long_url,
      token: generate_token(),
      expire: Date.add(Date.utc_today(), 7)
    }
    |> Links.create_link()
    |> case do
      {:ok, link} ->
        short_url =
          URI.append_path(socket.host_uri, "/#{link.token}")
          |> URI.to_string()

        form =
          to_form(%{
            "long_url" => long_url,
            "short_url" => short_url
          })

        assign(socket, :form, form)

      {:error, %{errors: errors}} ->
        assign(socket, form: to_form(params, errors: errors))
    end
  end

  defp generate_token() do
    {:ok, sqids} = Sqids.new(min_length: 5)
    current_date = DateTime.utc_now() |> DateTime.to_unix(:millisecond)
    numbers = [current_date]
    Sqids.encode!(sqids, numbers)
  end
end
