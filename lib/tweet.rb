require 'twitter'
require 'twitter/json_stream'
require 'command'

class Tweet < Command
  config = DaemonKit::Config.load('twitter')
  auth = Twitter::HTTPAuth.new(config['login'], config['password'])
  @twitter = Twitter::Base.new(auth)
  @command_name = Regexp.new("tweet\s", Regexp::IGNORECASE)

  def self.dispatch(message)

    # FIXME: There should be a method devoted to deciding if this command should handle the message.  It should return errors (like "message exceeds length" which should be posted back to the room
    if message['body'].split(/\S+/).size > 1 and message['body'].index(@command_name) == 0
      tweet = message['body'].sub(@command_name, '').strip
      
      DaemonKit.logger.info "Attempting to Tweet: #{tweet}" if DaemonKit::env == 'development'
      
      # Make three attempts, then bail
      attempts = 0
      begin
        @twitter.update(tweet)
      rescue Exception => e
        attempts += 1
        retry if attempts <= 3
         DaemonKit.logger.error "Failboat.  Damn Twitter.  On the last attempt we got #{e.message}"
      end

      true
    else
      # This was not a command meant for us!
      false
    end

  end

end

