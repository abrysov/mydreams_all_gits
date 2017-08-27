#!/usr/bin/env ruby

require 'pp'
require 'pry'
require 'json'
require 'socket'
require 'websocket'

TOKEN1 = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9." \
         "eyJ1c2VyX2lkIjoxfQ." \
         "rpWgOBaCjeZW-34cmFQLmbJQ1gRbTyy-bycPYXc5Zts".freeze
TOKEN2 = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9." \
         "eyJ1c2VyX2lkIjoyfQ." \
         "FDzZ9cDuecdcuXJx2qIFz1ipDNsnkUnQqfE3bpMY2rU".freeze

CONVERSATION_ID = 1
RESOURCE_TYPE = 'Dream'
RESOURCE_ID = 11

class Client
  HOST = 'localhost'.freeze
  PORT = 8081
  URL_TPL = '/bullet?token=%{user_token}'.freeze

  attr_reader :handshake, :version

  def initialize(user_token)
    url = URL_TPL % { user_token: user_token }
    @handshake = WebSocket::Handshake::Client.new(url: "ws://#{HOST}:#{PORT}#{url}")
    @version = handshake.version
  end

  def socket
    @socket ||= TCPSocket.new(HOST, PORT)
  end

  def connect
    socket.print(handshake.to_s)
    recv_hanshake
  end

  def recv_hanshake
    response = ''
    line = nil
    wait_for_read
    while line != "\r\n"
      line = socket.gets
      response += line
    end
    handshake << response
    fail 'unfinished handshake' unless handshake.finished?
    fail 'invalid handshake' unless handshake.valid?
  end

  def recv_payload(timeout = 1)
    frame = WebSocket::Frame::Incoming::Client.new(version: version)
    wait_for_read(timeout)
    frame << socket.read_nonblock(4096)
    JSON.parse(frame.next.to_s)
  end

  def send_payload(data)
    frame = WebSocket::Frame::Outgoing::Client.new(
      version: version,
      data: JSON.generate(data),
      type: :text
    )
    wait_for_write
    socket.print frame.to_s
  end

  def wait_for_read(timeout = 1)
    select([socket], [], [], timeout)
  end

  def wait_for_write
    select([], [socket], [], 1)
  end
end

puts 'Connect as User#1'
client1 = Client.new(TOKEN1).tap(&:connect)

puts 'User#1 sends message while User#2 is offline'
client1.send_payload({
  type:            :im,
  command:         :send,
  message:         "Helo",
  conversation_id: CONVERSATION_ID
})
puts 'User#1 receives his own message'
paylod = client1.recv_payload
fail if 'Helo' != paylod['payload']['message']

puts 'Connect as User#2 after a second...'
sleep 1
client2 = Client.new(TOKEN2).tap(&:connect)

puts 'User#2 receives message from User#1 in last messages'
client2.send_payload({
  type:            :im,
  command:         :list,
  conversation_id: CONVERSATION_ID
})
last_message = client2.recv_payload['payload']['messages'].first['message']
puts "last_message: [#{last_message}]"
fail if 'Helo' != last_message

puts 'User#2 requests online list'
client2.send_payload({
  type:            :im,
  command:         :online_list,
  conversation_id: CONVERSATION_ID
})
paylod = client2.recv_payload
# pp paylod
fail if [1, 2] != paylod['payload']

puts 'User#2 sends message to User#1'
client2.send_payload({
  type:            :im,
  command:         :send,
  message:         "pants",
  conversation_id: CONVERSATION_ID
})
payload1 = client1.recv_payload
payload2 = client2.recv_payload
# pp payload
fail unless payload1 == payload2
fail if 'pants' != payload1['payload']['message']

puts 'User1 requests comments for some resource'
client1.send_payload({
  type:          :comments,
  command:       :list,
  resource_type: RESOURCE_TYPE,
  resource_id:   RESOURCE_ID
})
payload = client1.recv_payload
fail if payload['type'] != 'comments'
fail if payload['command'] != 'list'
fail unless payload['payload'].is_a? Array

puts 'User1 subscribes comments for some resource'
client1.send_payload({
  type:          :comments,
  command:       :subscribe,
  resource_type: RESOURCE_TYPE,
  resource_id:   RESOURCE_ID
})

puts 'User2 post comment'
client2.send_payload({
  type:          :comments,
  command:       :post,
  resource_type: RESOURCE_TYPE,
  resource_id:   RESOURCE_ID,
  body:          'Первый нах'
})

puts 'User1 receives comment'
payload = client1.recv_payload
# pp payload
fail if payload['payload']['body'] != 'Первый нах'

puts 'User1 sends a message with a link'
client1.send_payload({
  type:            :im,
  command:         :send,
  message:         "https://bookmate.com",
  conversation_id: CONVERSATION_ID
})
link_message1 = client1.recv_payload
link_message2 = client2.recv_payload
# pp [:link_message, link_message1, link_message2]
fail unless link_message1 == link_message2

puts 'User1 and User2 receives a message with meta for embed'
link_embed1 = client1.recv_payload(10)
# pp link_embed1
fail unless link_embed1["payload"]["attachments"]
link_embed2 = client2.recv_payload
