require './lib/racker'

use Rack::Static, urls: ['/assets'], root: 'views'

run Racker.new