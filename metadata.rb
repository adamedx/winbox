name             'winbox'
maintainer       'Adam Edwards'
maintainer_email 'adamedx'
license          'Apache 2.0'
description      'Configures tools for development on Windows'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '0.9.101'

depends          'git'
depends          'windows'

supports         'windows'

source_url 'https://github.com/adamedx/winbox' if respond_to?(:source_url)
issues_url 'https://github.com/adamedx/winbox/issues' if respond_to?(:issues_url)


