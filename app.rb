require 'optparse'
require 'ostruct'

require_relative 'init'

$options = OpenStruct.new

optparser = OptionParser.new do |opts|
  opts.banner = "Usage: ruby #{__FILE__} -i /path/to/input -o /path/to/output"

  opts.on('-i', '--input=', 'Input file path') do |i|
    $options.input = i
  end

  opts.on('-o', '--output=', 'Output file path') do |o|
    $options.output = o
  end
end

optparser.parse!

unless $options.input && $options.output
  puts optparser.help
  exit(-1)
end

ShopKeep::TransformerFactory.get_transformer(
  ShopKeep::TransformerFactory::TYPES[:csv],
  {
    input:  $options.input,
    output: $options.output
  }
).transform.to_file
