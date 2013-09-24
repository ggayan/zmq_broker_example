require 'celluloid/zmq'
require 'oj'

Celluloid::ZMQ.init


class ZmqPusher
  include Celluloid::ZMQ

  def initialize(name: 'pusher', push_addr: 'tcp://127.0.0.1:5555')
    @name = name
    @socket = PushSocket.new

    begin
      @socket.connect(push_addr)
    rescue IOError
      @socket.close
      raise
    end
  end

  def write(message)
    puts "#{@name}: pushing message #{message}"
    @socket.send(message)

    nil
  end
end
