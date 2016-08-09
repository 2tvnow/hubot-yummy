# encoding: utf-8

require './bin/ckip_client-0.0.7/lib/CKIP_Client.rb'

Encoding.default_external = Encoding::UTF_8
text = ARGV.first.encode("utf-8")

puts CKIP.segment(text)