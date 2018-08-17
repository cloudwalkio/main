class CloudwalkUpdate
  def self.perform
    return unless Device::Network.connected?

    Device::Display.clear
    I18n.pt(:system_update_check)
    Device::Display.print(I18n.t(:system_update_cancel), 2)
    Device::Display.print("", 3)
    key = Device::IO::KEY_TIMEOUT

    5.times do |i|
      Device::Display.print((5 - i).to_s, 5, 11)
      key = getc(1000)
      break if key != Device::IO::KEY_TIMEOUT
    end

    if key != Device::IO::CANCEL
      DaFunk::ParamsDat.update_apps(true)
    end
  end
end