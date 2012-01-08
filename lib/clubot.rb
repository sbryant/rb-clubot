require 'zmq'
require 'json'

Thread.abort_on_exception = true

# Public: Clubot module
# See https://github.com/hackinggibsons/clubot/ for more information on
# running a clubot.
module Clubot
  class << self
    # Internal: reader for client to access ZMQ context. 
    attr_reader :ctx
  end

  @ctx = ZMQ::Context.new(1)

  # Public: The Clubot client class
  # Clubot clients bind SUB and DEALER sockets for receiving chat
  # broadcast and request/reply communication respectively.
  class Client
    # Public: The ZMQ::SUB socket
    attr_reader :sub_sock
    # Public: The ZMQ::DEALER socket
    attr_reader :dealer_sock

    # Public: Create the ZMQ sockets for commutation.
    #
    # sub_addr - A ZMQ address string. (default: 'tcp://localhost:14532')
    # dealer_addr - A ZMQ dealer string.
    #               (default: 'tcp://localhost:14533')
    # filters - An array of strings used set subscriptions filters.
    #           (default: [":PRIVMSG",
    #                      ":INVITE",
    #                      ":JOIN",
    #                      ":BOOT",
    #                      ":PART"])
    def initialize(sub_addr = "tcp://localhost:14532",
                   dealer_addr = "tcp://localhost:14533",
                   filters = [":PRIVMSG",
                              ":INVITE",
                              ":JOIN",
                              ":BOOT",
                              ":PART"])
      
      @sub_addr, @dealer_addr, @filters  = sub_addr, dealer_addr, filters
      @sub_sock = Clubot.ctx.socket ZMQ::SUB
      @dealer_sock = Clubot.ctx.socket ZMQ::DEALER
    end

    # Public: Connect the ZMQ::PUB and ZMQ::DEALER. Also setup up the
    # subscription filters
    #
    # Returns nothing.
    def connect
      @filters.each do |filter|
        @sub_sock.setsockopt ZMQ::SUBSCRIBE, filter
      end
      @sub_sock.connect @sub_addr
      @dealer_sock.connect @dealer_addr
    end

    # Public: Make a request to clubot.
    #
    # data - A hash representing the kind of request. The data is first
    #        encoded as JSON and sent.
    # blk  - An optional callback if the request being made expects a
    #        reply. (optional)
    #
    # Returns nothing or if a block was provided the result of calling
    # the block.
    def request data, &blk
      json = JSON.generate data
      @dealer_sock.send json
      if block_given?
        blk.call JSON.parse(@dealer_sock.recv)
      end
    end
  end
end

