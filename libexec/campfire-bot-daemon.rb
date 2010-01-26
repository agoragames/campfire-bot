# Change this file to be a wrapper around your daemon code.

# Do your post daemonization configuration here
# At minimum you need just the first line (without the block), or a lot
# of strange things might start happening...
DaemonKit::Application.running! do |config|
  # Trap signals with blocks or procs
  config.trap( 'INT' ) do
    puts "Caught INT signal, later!"
  end

  config.trap('TERM') do
    puts 'Caught TERM signal, later!'
  end
end

CampfireBot::listen

