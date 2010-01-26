class Command

  def self.dispatch
    DaemonKit.logger.info 'You fogot to override the dispatch method'
  end

end
