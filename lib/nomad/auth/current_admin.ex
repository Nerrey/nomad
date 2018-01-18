defmodule Nomad.CurrentAdmin do
  import Plug.Conn
  import Guardian.Plug

  def init(opts), do: opts

  def call(conn, _opts) do
    current_admin = current_resource(conn)
    assign(conn, :current_admin, current_admin)
  end
end
