# encoding: utf-8

require './bin/ckip_client-0.0.7/lib/CKIP_Client.rb'

text = ARGV.first.encode("utf-8")

puts CKIP.segment(text)