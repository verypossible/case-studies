defmodule PhoenixChat.PageControllerTest do
  use PhoenixChat.ConnCase

  test "Page has Chat Banner", %{conn: conn} do
    conn = get conn, "/"
    assert html_response(conn, 200) =~ "Welcome to the Chat Room"
  end
end
