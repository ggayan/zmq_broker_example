zmq_broker_example
==================

ZeroMQ pull-publish ruby broker example

I needed to make a small broker using ZeroMQ between some applications. The first application can have many processes (`pusher.rb`) and pushes messages to the broker (`broker.rb`). There can also be many clients (`subscriber.rb`) subscribed to the broker, consumming messages.

to try the application, run the following commands (tried on osx):

* `brew install zmq`
* `bundle install`
* `bundle exec ruby app.rb`
