# Phoenix Example Chat App

## Step 1 - Install

First you'll need:
* `mix archive.install https://github.com/phoenixframework/archives/raw/master/phoenix_new.ez`

Then we'll fire up a new Phoenix app with `mix phoenix.new phoenix_chat`. Allow Phoenix to build dependencies during this step or else you'll have to do it manually later. Phoenix comes with built in websocket support but we will need a DB*.

*Phoenix likes having at Postgresql instance even if we won't be using it in this example. If you already have Postgresql installed and configured and running then you can skip this part:

* `mkdir -p db/postgres`
* `initdb db/postgres -U postgres`
* `pg_ctl -D db/postgres/ start`
* `mix ecto.create && mix ecto.migrate`

Now we can fire up our app with: `mix phoenix.start`.

## Step 2 - Create Chat Page

Phoenix helpfully provides us with a default view and controller and controller spec. So we'll just update the view to hold our chat and update the test to check for it.

#### Test
`test/controllers/page_controller_test.exs`
```Elixir
test "Page has Chat Banner", %{conn: conn} do
  conn = get conn, "/"
  assert html_response(conn, 200) =~ "Welcome to the Chat Room"
end
```

#### View
`web/templates/page/index.html.eex`
```ERB
<h1>Welcome to the Chat Room</h1>

<div id="chat-box">
  <span>Messages: </span>
</div>

<form id="message-form">
  <input type="text" id="message-input"/>
  <input type="submit" />
</form>
```

## Step 3 - Sending and Receiving Messages

Phoenix has [build in channel test helpers](https://hexdocs.pm/phoenix/Phoenix.ChannelTest.html) so we can test channels pretty easily:

#### Test
`test/channel/chat_channel_test.exs`
```Elixir
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
```

First we stub out the socket with the `socket` helper and subscribe to the socket. Then we're just gonna push a test message to the channel and assert that the same message is rebroadcast out.

Now we need to fill in all the code to make that test pass. First we need to define the channel in our socket. We'll use the default UserSocket file somewhere near the top of the file:

#### Socket
`web/channels/user_socket.ex`
```Elixir
## Channels
channel "chat", PhoenixChat.ChatChannel
```

And now we need to define our channel behavior. We will write two functions, one for handling the join call and one for handling incoming messages. If we wanted to implement authentication that would take place in the `UserSocket.connect/2` function. The `join/3` function can be used to handle actions after a user has joined a channel. The `handle_in/3` function can be used to define all kinds of actions that the channel can accommodate via pattern matching. In our case we are defining the `message` action.

#### Channel
`web/channels/chat_channel.ex`
```Elixir
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
```

Now we just need to implement the front end client. First we are going to include jQuery so we can easily manipulate the DOM. We'll do that in the application layout. Make sure it is included before the rest of the JS:

#### Layout
`web/templates/layout/app.html.eex`
```ERB
.
.
.
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.1.1/jquery.min.js"></script>
<link rel="stylesheet" href="<%= static_path(@conn, "/css/app.css") %>">
.
.
.
```

Now we can use the simple socket lib that ships with Phoenix. This is a simple matter of uncommenting it in the app.js file:

#### App.js
`web/static/js/app.js`
```JS
import socket from "./socket"
```

Now we can open the socket lib and add our custom chat code. First connect to the default websocket. Next we add our channel/message handling code. We want to display messages when we receive a `message` action and we want to send messages when the user interacts with the input field. Finally we subscribe to our chat channel.

#### Client
`web/static/js/socket.js`
```JS
import {Socket} from "phoenix"

let socket = new Socket("/socket", {})

socket.connect()

// Now that you are connected, you can join channels with a topic:
let channel = socket.channel("chat", {})

channel.on('message', payload => {
  $('#chat-box').append(`<div>${payload.message}</div>`);
});

$('#message-form').submit(e => {
  e.preventDefault();

  let message = $('#message-input');

  if (message.val().length > 0) {
    channel.push('message', { message: message.val() });
    message.val('');
  }
});

channel.join()
  .receive("ok", resp => { console.log("Joined successfully", resp) })
  .receive("error", resp => { console.log("Unable to join", resp) })

export default socket
```

And that's it! Pretty slick.
