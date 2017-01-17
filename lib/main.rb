require 'posxml_parser'
require 'funky-emv'
require "funky-simplehttp"

class Main < Device
  include Device::Helper

  def self.call
    Cloudwalk.boot
    DaFunk::Engine.app_loop do
      Device::Display.print_main_image
      Device::Display.print(I18n.t(:time, :time => Time.now), STDOUT.max_y - 1, 0)
    end
  end

  def self.version
    "1.3.0"
  end
end

