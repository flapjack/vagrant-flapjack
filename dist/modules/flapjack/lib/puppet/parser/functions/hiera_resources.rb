# hiera_resources - A Hiera wrapper for Puppet's create_resources function
#
Puppet::Parser::Functions.newfunction(:hiera_resources) do |args|

  def error(message)
    raise Puppet::Error, message
  end

  file_name = File.basename(__FILE__, File.extname(__FILE__))

  error("%s requires 1 argument" % file_name) unless args.length >= 1

  if args[1]
    error("%s expects a hash as the 2nd argument; got %s" % [file_name, args[1].class]) unless args[1].is_a? Hash
  end

  function_hiera_hash(args.flatten).each do |type, resources|
    # function_create_resources is no workie so we'll do this
    method = Puppet::Parser::Functions.function :create_resources
    send(method, [type, resources])
  end
end
