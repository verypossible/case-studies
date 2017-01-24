# Rails Example Chat App

## Step 1 - Install

First you'll need:
* gem install rails -v '5.0.1'

We'll install a new Rails app with `rails new rails-chat`. Since we're on Rails 5 we should have everything we need. Let's setup a simple view/controller.

## Step 2 - Create Chat Page

Like with any good code. We'll start with our tests and work our out from there.

#### Test
`test/controllers/chats_controller_test.rb`
```Ruby
class ChatsControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get root_url
    assert_response :success
  end
end
```

#### Route
`config/routes.rb`
```Ruby
Rails.application.routes.draw do
  root 'chats#index'
end
```

#### Controller
`app/controllers/chats_controller.rb`
```Ruby
class ChatsController < ApplicationController
  def index
  end
end
```

#### View
`app/views/chats/index.html.erb`
```ERB
<h1>Welcome to the Chat Room</h1>
```

Now that we've got basic setup out of the way let's dig into some [ActionCable](http://edgeguides.rubyonrails.org/action_cable_overview.html)

## Step 3 - Sending and Receiving Messages

*Note - [Testing of Channels is not fully supported via the Rails API.](https://github.com/rails/rails/pull/23211) The official recommendation is to use full integration testing for now. We do not incorporate all of that at this time.

We'll start by defining two callbacks in our channel.rb file.
`app/channels/chat_channel.rb`
```Ruby
class ChatChannel < ApplicationCable::Channel
  def subscribed
  end

  def receive
  end
end
```
The first callback `#subscribed` handles any subscription request. We could do all sorts of things here such as trigger notifications that a user is online or send a default message. We will simply use it to stream from the channel:

```Ruby
def subscribed
  stream_from 'chat'
end
```

*Note - It is possible to pass params from the client during the subscription process that are accessible in this function via a `params` hash.

Our Second callback is the `#receive` function. This function controls what happens to any messages received from subscribers. We could store data in the DB or, as we do in this case, send messages to other users:

```Ruby
def receive(data)
  ActionCable.server.broadcast('chat', data)
end
```

Now we have to implement the interaction from the client side. This uses the ActionCable JS API available in Javascript and Coffeescript. First we create a subscription and provide a callback for when we receive messages on the subscription. We also included some fancy JS for displaying the messages in the UI:
`app/assets/javascripts/channels/chats.js`
```JS
App.chat = App.cable.subscriptions.create({ channel: 'ChatChannel' }, {
  received: function (data) {
    $('#chat-box').append('<div>' + data.message + '</div>')
  }
});

$(document).ready(function () {
  $('#message-form').submit(function (e) {
    e.preventDefault();

    var input = $('#message-input');
    if(input.val().length > 0) {
      App.chat.send({ message: input.val() })
    }

    input.val('')
  });
});
```

And with that we just need spruce up our initial view and we're ready to go!

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
