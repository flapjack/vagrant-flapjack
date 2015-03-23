puppet-phantomjs
===============

Simple puppet module that installs PhantomJS - headless WebKit scriptable with a Javascript API.

Using
-----

	class { '::phantomjs':
		package_version => '1.9.7',
		package_update => true,
		install_dir => '/usr/local/bin',
		source_dir => '/opt',
		timeout => 300
	}

The module pulls in *curl*, *bzip2* and *libfontconfig1* if you haven't defined those packages yourself.
This module depends on puppetlabs/stdlib 4.x module.
