require 'rack/test'
require 'simplecov'

SimpleCov.start do
  add_filter(%r{\/spec\/})
end

require_relative '../lib/racker'
