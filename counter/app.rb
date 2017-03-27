#!/usr/bin/env ruby

require 'sinatra'

class AtomicInteger
  def initialize(start = 0)
    @value = start
    @lock = Mutex.new
  end

  def increment_and_get
    value = @lock.synchronize do
      @value += 1
    end

    [200, value.to_s]
  end
end

counter = AtomicInteger.new

get '/getAndIncrement' do
  content_type 'text/plain'
  counter.increment_and_get
end
