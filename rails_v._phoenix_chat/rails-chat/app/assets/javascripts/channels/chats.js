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
