# encoding: utf-8

require './bin/ckip_client-0.0.7/lib/CKIP_Client.rb'

text = ARGV.first

puts CKIP.segment(text)