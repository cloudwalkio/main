class CloudwalkWizard < DaFunk::ScreenFlow
  include DaFunk::Helper

  setup do Device::Display.clear end

  screen :language do |result|
    I18n.pt :language
    key = try_key(["1","2",Device::IO::CANCEL], 0)
    if (key == "1")
      I18n.locale = "pt-br"
      Device::Setting.locale = I18n.locale
    elsif key == "2"
      I18n.locale = "en"
      Device::Setting.locale = I18n.locale
    else
      Device::IO::CANCEL
    end
  end

  screen :serial_number_1 do |result|
    confirm I18n.t(:serial_number_1)
  end

  screen :serial_number_2 do |result|
    confirm I18n.t(:serial_number_2, :args => Device::System.serial)
  end

  screen :logical_number_1 do |result|
    confirm I18n.t(:logical_number_1)
  end

  screen :logical_number_2 do |result|
    I18n.pt(:logical_number_2)
    if Device::Setting.logical_number == Device::IO::KEY_TIMEOUT
      logical = ""
    else
      logical = Device::Setting.logical_number
    end
    options = {:value => logical, :mode => :alpha, :column => 0, :line => 4,
      :label => ": "}
    Device::Setting.logical_number = Device::IO.get_format(1, 15, options)
    ! Device::Setting.logical_number.empty?
  end

  screen :communication_1 do |result|
    confirm I18n.t(:communication)
  end

  screen :communication_2 do |result|
    ret = false
    unless (ret = Device::Network.connected?)
      case(menu("Select Media:", {"WIFI" => :wifi, "GPRS" => :gprs}))
      when :wifi; ret = MediaConfiguration.wifi
      when :gprs; ret = MediaConfiguration.gprs
      end
    end

    Device::Setting.network_configured = "1"
    ret
  end

  screen :activation_1 do |result|
    confirm I18n.t(:activation_1)
  end

  screen :activation_2 do |result|
    I18n.pt(:activation_2)
    unless Device::Network.connected?
      if Device::Network.attach == Device::Network::SUCCESS
        params = DaFunk::ParamsDat.download
      end
    else
      params = DaFunk::ParamsDat.download
    end
    if params && DaFunk::ParamsDat.exists?
      true
    else
      Device::Display.clear
      confirm I18n.t(:activation_error)
      false
    end
  end

  screen :activation_3 do |result|
    if confirm(I18n.t(:activation_success)) == Device::IO::ENTER
      DaFunk::ParamsDat.update_apps
    end
  end
end

