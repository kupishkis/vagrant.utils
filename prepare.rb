#!/bin/env ruby

require 'yaml'
require 'pathname'
require 'socket'

def write_inventory(map, root)
  inventory = root + 'inventory'
  inventory.mkdir unless inventory.exist?

  map.each do |key, value|
    File.open(inventory + key, 'w') do |f|
      f.write("["+key+"]\n")
      f.write(value+"\n")
    end
  end
end

def public_ip
    Socket.ip_address_list.detect{|intf| intf.ipv4? and !intf.ipv4_loopback? and !intf.ipv4_multicast?}
end

def validate_map(map)
  # Automagically fill 'localhost' in map.
  unless map['localhost']
    map['localhost'] = public_ip.ip_address unless public_ip.nil?
    raise "Could not determine local ip. Please add in to config.yml." unless map['localhost']
  end
  map
end

