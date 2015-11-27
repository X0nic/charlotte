$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "charlotte"

require "fakeweb"

FakeWeb.allow_net_connect = false
