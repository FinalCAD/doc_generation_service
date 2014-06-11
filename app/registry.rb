require 'singleton'

class Registry
  include Singleton

  FAILED_STATUS = %w(failed killed)
  FAILED, KILLED = FAILED_STATUS
  UNKNOWN, COMPLETED, WORKING = %w(unknown, completed working)

  attr_reader :registry

  def initialize
    @registry = {}
  end

  def status token
    self.registry[token] || { status: UNKNOWN, url: 'public/404.jpg' }
  end

  def start! token, file
    self.registry[token] = { status: WORKING, url: file }
  end

  def finish! token
    self.registry[token][:status] = COMPLETED
  end

end
