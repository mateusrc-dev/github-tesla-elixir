defmodule GithubapiWeb.Auth.ErrorHandler do
  alias Guardian.Plug.ErrorHandler
  alias Plug.Conn

  @behaviour ErrorHandler

  def auth_error(conn, {error, _reason}, _opts) do
    # we will have to deal with the connection as we are not in the context of the controllers, we are in the context before the controller, so we cannot use fallback
    body = Jason.encode!(%{message: to_string(error)})

    Conn.send_resp(conn, 401, body)
  end
end
