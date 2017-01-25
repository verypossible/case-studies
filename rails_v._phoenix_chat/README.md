# [Rails](http://rubyonrails.org/) [v](http://www.eraofwisdom.org/wp-content/uploads/2015/10/anon.png). [Phoenix](http://www.phoenixframework.org/) Chat

## Goals
* Show how to build a (very) simple chat in both frameworks
* Weight the pros and cons of each framework for real time interactions

## [Rails Chat Build Instructions](https://github.com/spartansystems/case-studies/blob/master/rails_v._phoenix_chat/rails-chat/README.md)

## [Phoenix Chat Build Instructions](https://github.com/spartansystems/case-studies/blob/master/rails_v._phoenix_chat/phoenix_chat/README.md)

## Comparison

Feature | Rails | Phoenix
--------|-------|--------
Out of the Box | Since Rails 5 you've got everything you need websocket communication. Nothing else is needed but a clean rails install. Unless you are doing TDD, then you'll notice the nice built in Rails testing tools do not accommodate channels. [Yet!](https://github.com/rails/rails/pull/23211) | Phoenix comes with all the socket features you could want out of the box including testing tools. Although we did need to setup Postgres to get the server running without errors and we included jQuery for convenience. Nothing too bad.
Ease of use | The [ActionCable documentation](http://edgeguides.rubyonrails.org/action_cable_overview.html) feels a little scattered and disorganized. A lot of information is dumped on the reader without a thorough explanation. For instance the `stream_from` and `stream_for` methods are hardly addressed. That said, nothing here is too difficult to overcome with a little trial and error. | The [Phoenix Channel documentation](https://hexdocs.pm/phoenix/Phoenix.Channel.html) is vastly superior to the rails documentation in my opinion. Their [test documentation](https://hexdocs.pm/phoenix/Phoenix.ChannelTest.html) is very good as well. In addition the pattern matching abilities of Phoenix make the API a little simpler to understand and reason about in my opinion.
Performance | There have been some good [experiments](https://dockyard.com/blog/2016/08/09/phoenix-channels-vs-rails-action-cable) performed to compare the performance of these two frameworks. We won't be attempting to recreate those tests at this time as the results appear to be pretty conclusive. | [See previous](https://dockyard.com/blog/2016/08/09/phoenix-channels-vs-rails-action-cable)

## Conclusion

While both frameworks now support Sockets and channels out of the box and do so with relative ease, Phoenix takes the cake with documentation and performance that Rails cannot match. If you have a need for real time web apps that can communicate of WebSockets I would recommend investigation Phoenix as a great option.
