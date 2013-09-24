require 'celluloid'
require './broker'

class BrokerSupervisionGroup < Celluloid::SupervisionGroup
  supervise ::ZmqBroker, as: :broker
end
