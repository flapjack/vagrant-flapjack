# RPM Forge Puppet Module [![Build Status](https://travis-ci.org/Spredzy/puppet-repoforge.png)](https://travis-ci.org/Spredzy/puppet-repoforge)

This module aims to declare and enable rpm forge repositories

## Usage

### Simple Usage

    include repoforge

### Custom Usage

    class {'repoforge' :
      enabled     => ['rpmforge', 'extras'],
      baseurl     => 'http://apt.sw.be/redhat/el6/en/${::architecture}',
      includepkgs => { 'extras' => 'memcached' },
      exclude     => { 'rpmforge' => 'nagios*', 'testing' => 'perl*' },
    }

## License

Apache License v2


## Contact

Yanis Guenane - yguenane@gmail.com


## Support

Please log tickets and issues at our [Projects site](https://github.com/Spredzy/puppet-repoforge)
