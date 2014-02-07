root = File.expand_path('..', __FILE__)
directories = Dir.glob(File.join(root, '*')).find_all {|e| File.directory?(e)}
directories.each {|d| $: << File.join(d, 'lib') }
