require 'tweet'
class CampfireBot

  include HTTParty

  # Load the config file
  @config = DaemonKit::Config.load('campfire')

  # Configure HTTParty
  base_uri   "https://#{@config['base_uri']}"
  headers    'Content-Type' => 'application/json'
  basic_auth @config['token'], 'x'

  # Configure Streaming
  @options = {
    :path => "/room/#{@config['room_id']}/live.json",
    :host => @config['streaming_uri'],
    :auth => "#{@config['token']}:x"
  }

  @bot_name_pattern = Regexp.new("#{@config['bot_name']}:\s", Regexp::IGNORECASE)


  # Monitor the Campfire feed, dispatch to handlers
  def self.listen
    
    EventMachine::run do

      # This is a bit confusing because it uses the Twitter Gem's streaming method, YAJL-Ruby didn't work as advertised
      # FIXME: We need some error handling code here
      post "/room/#{@config['room_id']}/join.xml"
      stream = Twitter::JSONStream.connect(@options)
 
      stream.each_item do |item|
        # Convert to HASH
        params = JSON.parse(item)
        DaemonKit.logger.info 'Received a message' if DaemonKit::env == 'development'
       
        # FIXME: Needs to be refactored to dispatch to ALL handlers
       if params['body'] and params['body'].split(/\S+/).size > 1 and params['type'] == 'TextMessage' and params['body'].index(@bot_name_pattern) == 0 
          DaemonKit.logger.info "Received message for #{@config['bot_name']}" if DaemonKit::env == 'development'
          
          # Strip the botname from the message and dispatch to all commands
          params['body'] = params['body'].sub(@bot_name_pattern, '').strip
          puts params['body']
          #Decide which command to call
          Tweet::dispatch(params)
          
          # We should post problems back to the room
       end
      end
 
      stream.on_error do |message|
        puts "ERROR:#{message.inspect}"
      end
 
      stream.on_max_reconnects do |timeout, retries|
        puts "Tried #{retries} times to connect."
        exit
      end

    end
  end
end
