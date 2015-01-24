require 'optparse'
require 'ostruct'

$options = OpenStruct.new

optparser = OptionParser.new do |opts|
  opts.banner = 'Usage: ruby importer.rb -i /path/to/input -o /path/to/output'

  opts.on('-i', '--input=', 'Input file path') do |b|
    $options.input = b
  end

  opts.on('-o', '--output=', 'Output file path') do |f|
    $options.output = f
  end
end

optparser.parse!

unless $options.input && $options.output
  puts optparser.help
  fail("Option -b and -o are both required")
end
