name              'devstack'
maintainer        'Davide Guerri'
maintainer_email  'davide.guerri@hp.com'
license           'Apache 2.0'
description       ''
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version           '0.1.0'
recipe            'devstack', 'Install Devstack'

%w{ ubuntu }.each do |os|
  supports os
end

depends 'git'
