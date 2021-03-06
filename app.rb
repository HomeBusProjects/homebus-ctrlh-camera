require 'homebus'
require 'homebus_app'
require 'mqtt'
require 'json'
require 'dotenv'

require 'net/http'
require 'base64'
require 'timeout'

class CameraHomeBusApp < HomeBusApp
  DDC = 'org.homebus.experimental.image'

  def initialize(options)
    @options = options

    super
  end

  def setup!
    Dotenv.load('.env')
    @url = ENV['CAMERA_URL']
    @publish_delay = ENV['PUBLISH_DELAY'] || 60
  end

  def _get_image
    begin
      response = Timeout::timeout(30) do
        uri = URI(@url)
        response = Net::HTTP.get_response(uri)
      end

      if response.code == "200"
        return {
          mime_type: 'image/jpeg',
          data: Base64.encode64(response.body)
        }
      else
        nil
      end
    rescue
      puts "timeout"
      nil
    end
  end

  def work!
    image = _get_image

    if image
      publish! DDC, image
    else
      puts "no image"
    end

    sleep @publish_delay
 end

  def manufacturer
    'HomeBus'
  end

  def model
    ''
  end

  def friendly_name
    'Cameras'
  end

  def friendly_location
    'PDX Hackerspace'
  end

  def serial_number
    @url
  end

  def pin
    ''
  end

  def devices
    [
      { friendly_name: '^H Cameras',
        friendly_location: 'PDX Hackerspace',
        update_frequency: @publish_delay,
        index: 0,
        accuracy: 0,
        precision: 0,
        wo_topics: [ DDC ],
        ro_topics: [],
        rw_topics: []
      }
    ]
  end
end
