defmodule PhoenixChat.ChatChannel do
  use Phoenix.Channel

  def join("chat", _payload, socket) do
    {:ok, socket}
  end

  def handle_in("message", payload, socket) do
    broadcast! socket, "message", payload
    {:noreply, socket}
  end
end
