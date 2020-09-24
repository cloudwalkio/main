class CloudwalkUpdate
  def self.application
    return unless Device::Network.connected?

    Device::Display.clear
    I18n.pt(:system_update_check)
    Device::Display.print(I18n.t(:system_update_cancel), 2)
    Device::Display.print("", 3)
    key = Device::IO::KEY_TIMEOUT

    10.times do |i|
      Device::Display.print((10 - i).to_s, 5, 11)
      key = getc(1000)
      break if key != Device::IO::KEY_TIMEOUT
    end

    if File.exists?("./shared/application_update")
      File.delete("./shared/application_update")
    end

    if key != Device::IO::CANCEL
      DaFunk::ParamsDat.update_apps(true)
      Device::System.restart
    end
  end

  def self.system
    return unless Device::Network.connected?

    BacklightControl.on
    Device::Display.clear
    I18n.pt(:system_update_check)
    Device::Display.print(I18n.t(:system_update_cancel), 2)
    Device::Display.print("", 3)
    key = Device::IO::KEY_TIMEOUT

    10.times do |i|
      Device::Display.print((10 - i).to_s, 5, 11)
      key = getc(1000)
      break if key != Device::IO::KEY_TIMEOUT
    end

    if key != Device::IO::CANCEL
      SystemUpdate.new.start
    else
      File.delete("./shared/system_update") if File.exists?("./shared/system_update")

  def self.wait_connection
    time = Time.now + 180

    Device::Display.clear
    I18n.pt(:system_update, :line => 0)
    I18n.pt(:attach_network, :line => 3)
    loop do
      if Device::Network.connected?
        break
      elsif time < Time.now && !Device::Network.connected?
        break
      elsif getc(100)== Device::IO::CANCEL
        File.delete('./shared/system_update') if File.exists?('./shared/system_update')
        break
      end
    end
  end
end

