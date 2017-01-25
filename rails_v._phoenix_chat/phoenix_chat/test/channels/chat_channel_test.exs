defmodule PhoenixChat.ChatChannelTest do
  use PhoenixChat.ChannelCase
  alias PhoenixChat.ChatChannel

  test "messages are rebroadcast" do
    {:ok, _, socket} = socket("", %{})
      |> subscribe_and_join(ChatChannel, "chat")

    message = %{"message" => "body"}

    push socket, "message", message
    assert_broadcast "message", message
  end
end
