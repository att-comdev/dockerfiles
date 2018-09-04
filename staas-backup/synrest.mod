#!/usr/bin/env ruby
#
# The application 'synaptic4r' is installed as part of a gem, and
# this file is here to facilitate running it.
#

require 'rubygems'
require 'rest-client'

version = ">= 0"

if ARGV.first =~ /^_(.*)_$ and Gem::Version.correct? $1 then
version = $1
ARGV.shift
end

RestClient.proxy = ""

gem 'synaptic4r', version
load Gem.bin_path('synaptic4r', 'synrest', version)
