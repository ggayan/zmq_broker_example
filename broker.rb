require 'celluloid/zmq'
require 'oj'

Celluloid::ZMQ.init

class ZmqBroker
  include Celluloid::ZMQ

  finalizer :close_sockets

  def initialize(name: 'broker', pull_addr: 'tcp://127.0.0.1:5555', pub_addr: 'tcp://127.0.0.1:5556')
    @name = name
    @pull_socket = PullSocket.new
    @pub_socket = PubSocket.new

    begin
      @pull_socket.bind pull_addr
      @pub_socket.bind pub_addr

      async.run
    rescue IOError
      close_sockets
      raise
    end
  end

  def close_sockets
    @pull_socket.close
    @pub_socket.close
  end

  def run
    loop { async.handle_message @pull_socket.read }
  end

  def handle_message(message)
    puts "#{@name}: pulled message #{message}"
    params = Oj.load(message)
    puts "#{@name}: publishing message #{message}"
    @pub_socket.write params["channel"], params["body"]
  rescue Oj::ParseError
    puts "#{@name}: couldn't parse message: #{message}"
  end
end
