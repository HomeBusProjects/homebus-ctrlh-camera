require 'homebus_app_options'

class CamerasHomeBusAppOptions < HomeBusAppOptions
  def app_options(op)
    camera_still_help = 'URL that returns still image from camera'

    op.separator 'Cameras options:'
    op.on('-u', '--url CAMERA_STILL_URL', camera_still_help) { |value| options[:camera_still_url] = value }
  end

  def banner
    'HomeBus CTRL-H cameras'
  end

  def version
    '0.0.1'
  end

  def name
    'homebus-ctrlh-cameras'
  end
end