require 'celluloid'
require './broker_supervision_group'
require './pusher'
require './subscriber'

BrokerSupervisionGroup.run!

subscriber1 = ZmqSubscriber.new name: 'client 1'
subscriber2 = ZmqSubscriber.new name: 'client 2'
subscriber3 = ZmqSubscriber.new name: 'client 3'
subscriber1.async.run
subscriber2.async.run
subscriber3.async.run

pusher1 = ZmqPusher.new name: 'pusher 1'
pusher2 = ZmqPusher.new name: 'pusher 2'
pusher3 = ZmqPusher.new name: 'pusher 3'

1.upto(10) do |i|
  pusher1.write "{\"channel\": \"some_channel\", \"body\": \"message ##{i} from pusher 1\"}"
  pusher2.write "{\"channel\": \"some_channel\", \"body\": \"message ##{i} from pusher 2\"}"
  pusher3.write "{\"channel\": \"some_channel\", \"body\": \"message ##{i} from pusher 3\"}"
end

sleep # wait for tasks to finish
