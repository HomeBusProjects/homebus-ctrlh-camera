require 'homebus'
require 'homebus_app'
require 'mqtt'
require 'json'

require 'net/http'
require 'base64'
require 'timeout'

class CamerasHomeBusApp < HomeBusApp
  def initialize(options)
    @options = options

    super
  end


  def setup!
  end

  def get_image
    begin
      Timeout::timeout(30) {
        uri = URI(url)
        response = Net::HTTP.get_response(uri)
        if response.is_a?(Net::HTTPSuccess)
          {
            mine_type: ,
            Base64.encode(response.body)
          }
        end
      }
    rescue
      nil
    end
  end

  def work!
    image = get_image

    if image
      @mqtt.publish '/cameras',
                    JSON.generate({
                                    id: @mqtt_uuid,
                                    timestamp: Time.now.to_i,
                                    image: image
                                }),
                    true
    end

    60
  end

  def manufacturer
    'HomeBus'
  end

  def model
    'D'
  end

  def friendly_name
    'Cameras'
  end

  def friendly_location
    'PDX Hackerspace'
  end

  def serial_number
    ''
  end

  def pin
    ''
  end

  def devices
    [
      { friendly_name: 'Who goes there',
        friendly_location: 'PDX Hackerspace',
        update_frequency: 60,
        index: 0,
        accuracy: 0,
        precision: 0,
        wo_topics: [ 'door' ],
        ro_topics: [],
        rw_topics: []
      }
    ]
  end
end
