Dotfiles
========
Contains user dotfiles for bash, vim and gitconfigs.


# Boxen Puppet class

Per-user manifests live in `modules/people/manifests/$login.pp`, where
`$login` is a GitHub login. A simple user manifest example:

```puppet
class people::bcowdery {
  include projects::all

    $home     = "/Users/${::boxen_user}"
    $my       = "${home}/my"
    $dotfiles = "${my}/dotfiles"

    file { $my:
      ensure  => directory
    }
	        }
    repository { $dotfiles:
       source  => 'bcowdery/dotfiles',
       require => File[$my]
    }
}
```
