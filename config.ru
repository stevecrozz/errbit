# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment',  __FILE__)

# use Profiler
if ENV['PROF']
  use Rack::RubyProf, :path => 'tmp/profile', :printers => {
    RubyProf::CallTreePrinter => 'calltree'
  }
end

use Rack::Deflater
run Rails.application
