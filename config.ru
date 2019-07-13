require './lib/racker'

use Rack::Static, urls: ['/assets'], root: 'views'

use Rack::Session::Cookie, key: 'rack.session',
                           expire_after: 2_592_000,
                           secret: 'secret'

run Racker
