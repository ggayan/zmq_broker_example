require 'celluloid/zmq'
require 'oj'

Celluloid::ZMQ.init

class ZmqBroker
  include Celluloid::ZMQ

  def initialize(name: 'broker', pull_addr: 'tcp://127.0.0.1:5555', pub_addr: 'tcp://127.0.0.1:5556')
    @name = name
    @pull_socket = PullSocket.new
    @pub_socket = PubSocket.new

    begin
      @pull_socket.bind pull_addr
      @pub_socket.bind pub_addr
    rescue IOError
      @pull_socket.close
      @pub_socket.close
      raise
    end
  end

  def run
    loop { async.handle_message @pull_socket.read }
  end

  def handle_message(message)
    puts "#{@name}: pulled message #{message}"
    params = Oj.load(message)
    puts "#{@name}: publishing message #{message}"
    @pub_socket.write params["channel"], params["body"]
  end
end
