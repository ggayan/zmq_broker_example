require 'celluloid/zmq'
require 'oj'

Celluloid::ZMQ.init

class ZmqSubscriber
  include Celluloid::ZMQ

  def initialize(name: 'client', sub_addr: 'tcp://127.0.0.1:5556')
    @name = name
    @sub_socket = SubSocket.new

    begin
      @sub_socket.subscribe '' # subscribe to everything
      @sub_socket.connect sub_addr
    rescue IOError
      @sub_socket.close
      raise
    end
  end

  def run
    loop do
      channel = @sub_socket.read
      async.handle_message @sub_socket.read
    end
  end

  def handle_message(message)
    puts "#{@name}: received message: #{message}"
  end
end
