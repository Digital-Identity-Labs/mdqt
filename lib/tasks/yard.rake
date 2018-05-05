require 'yard'

YARD::Rake::YardocTask.new do |t|
  t.files   = ['features/*.feature', 'features/*.rb']
  t.options = ['--any', '--extra', '--opts'] # optional
end