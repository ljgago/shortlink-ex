defmodule ShortlinkWeb.HomeLive.Index do
  use ShortlinkWeb, :live_view

  alias Shortlink.Links

  @impl true
  def mount(_params, _session, socket) do
    form =
      to_form(%{
        "long_url" => nil,
        "short_url" => nil
      })

    peer_data = get_connect_info(socket, :peer_data)

    {:ok, assign(socket, form: form, ip: peer_data.address)}
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

    {:noreply, put_flash(socket, :copy, "#{short_url}")}
  end

  @impl true
  def handle_info(:clear_flash, socket) do
    {:noreply, clear_flash(socket)}
  end

  @impl true
  def handle_params(_params, uri, socket) do
    %{path: path} = URI.parse(uri)

    {:noreply, assign(socket, :path, path)}
  end

  defp generate_link(socket, %{"long_url" => long_url} = params) do
    new_link(socket.assigns.current_user, long_url)
    |> Links.create_link()
    |> case do
      {:ok, link} ->
        short_url =
          URI.append_path(socket.host_uri, "/#{link.code}")
          |> URI.to_string()

        form =
          to_form(%{
            "long_url" => long_url,
            "short_url" => short_url
          })

        assign(socket, :form, form)

      {:error, %{errors: errors}} ->
        IO.inspect(socket.assigns.ip)
        assign(socket, form: to_form(params, errors: errors))
    end
  end

  defp new_link(user, long_url) do
    %{
      email: user,
      long_url: long_url,
      code: generate_code(),
      expire: DateTime.utc_now(:second) |> DateTime.add(7, :day)
    }
  end

  defp generate_code() do
    {:ok, sqids} = Sqids.new(min_length: 5)
    current_date = DateTime.utc_now() |> DateTime.to_unix(:millisecond)
    fixed_date = ~U[2024-01-01 00:00:00Z] |> DateTime.to_unix(:millisecond)

    diff_number = current_date - fixed_date
    rand_number = Enum.random(1..9999)

    numbers = [diff_number, rand_number]
    Sqids.encode!(sqids, numbers)
  end
end

