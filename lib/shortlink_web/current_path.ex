defmodule ShortlinkWeb.CurrentPath do
  import Plug.Conn

  def put_current_path(conn, _opts) do
    assign(conn, :path, "")
    # assign(conn, :on_settings, false)
  end
end
