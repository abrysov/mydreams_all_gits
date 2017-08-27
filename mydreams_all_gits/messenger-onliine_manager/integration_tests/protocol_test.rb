#!/usr/bin/env ruby

require 'pp'
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

class Client
  HOST = 'localhost'.freeze
  PORT = 8080
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

  def recv_last_messages(conversation_id)
    request_last_messages(conversation_id)
    last_messages = recv_paylod
    fail 'wrong type' if last_messages['type'] != 'last_messages'
    last_messages['messages']
  end

  def recv_paylod
    frame = WebSocket::Frame::Incoming::Client.new(version: version)
    wait_for_read
    frame << socket.read_nonblock(4096)
    JSON.parse(frame.next.to_s)
  end

  def request_last_messages(conversation_id)
    send_payload(
      type: :last_messages,
      conversation_id: conversation_id
    )
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

  def wait_for_read
    select([socket], [], [], 1)
  end

  def wait_for_write
    select([], [socket], [], 1)
  end
end

puts 'Connect as User#1'
client1 = Client.new(TOKEN1).tap(&:connect)
last_messages = client1.recv_last_messages(CONVERSATION_ID)
# puts :last_messages
# pp last_messages

puts 'User#1 sends message while User#2 is offline'
client1.send_payload({type: "message", text: "Helo", conversation_id: CONVERSATION_ID})
puts 'User#1 receives his own message'
fail if 'Helo' != client1.recv_paylod['message']['text']

puts 'Connect as User#2 after a second'
sleep 1
client2 = Client.new(TOKEN2).tap(&:connect)

puts 'User#2 receives message from User#1 in last messages'
last_message = client2.recv_last_messages(CONVERSATION_ID).first['text']
puts "last_message: [#{last_message}]"
fail if 'Helo' != last_message

puts 'User#2 requests online list'
client2.send_payload({type: "online_list", conversation_id: CONVERSATION_ID})
paylod = client2.recv_paylod
# pp paylod
fail if [1, 2] != paylod['online_list']

puts 'User#2 sends message to User#1'
client2.send_payload({type: "message", text: "pants", conversation_id: CONVERSATION_ID})

paylod = client1.recv_paylod
# pp paylod
fail if 'pants' != paylod['message']['text']
