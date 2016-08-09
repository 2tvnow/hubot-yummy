# encoding: utf-8

require './bin/ckip_client-0.0.7/lib/CKIP_Client.rb'

text = ARGV.first.encode("utf-8", "ISO-8859-15")

puts CKIP.segment(text)