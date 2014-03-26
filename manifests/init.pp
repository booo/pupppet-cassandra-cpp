class cassandra-cpp(
  $branch = 'master'
) {

  #TODO fix this, bad style
  # move common packages in one module
  if ! defined(Package['build-essential']) {
    package { 'build-essential':
      ensure => installed,
    }
  }
  if ! defined(Package['libssl-dev']) {
    package { 'libssl-dev':
      ensure => installed,
    }
  }
  if ! defined(Package['libboost-all-dev']) {
    package { 'libboost-all-dev':
      ensure => installed,
    }
  }

  package { [
    'libssh2-1-dev',
    'cmake'
    ]:
      ensure => installed
  }

  exec { 'git clone https://github.com/datastax/cpp-driver.git /usr/src/cassandra-cpp':
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    creates => '/usr/src/cassandra-cpp/README.md',
  }
  exec { "git checkout ${branch}":
    path     => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    cwd      => '/usr/src/cassandra-cpp',
    requires => Exec['git clone https://github.com/datastax/cpp-driver.git /usr/src/cassandra-cpp'],
  }

  #TODO build only once
  exec { 'cmake . && make && make install && ldconfig':
    path    => '/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin',
    cwd     => '/usr/src/cassandra-cpp',
    timeout => 900,
    require => [
  		Exec["git checkout ${branch}"],
      Package[
        'build-essential',
        'libssl-dev',
        'libboost-all-dev',
        'libssh2-1-dev',
        'cmake'
      ]
    ]
  }
}
