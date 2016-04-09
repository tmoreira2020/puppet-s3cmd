class s3cmd::install {

  Exec {
    path => '/bin',
  }

  package {'python-setuptools':
    ensure => 'installed'
  }

  wget::fetch { 'fetch-s3cmd':
    source      => "https://github.com/s3tools/s3cmd/tarball/${s3cmd::params::commit_sha1_abbreviation}",
    destination => "/tmp/s3cmd-${s3cmd::params::commit_sha1_abbreviation}.tar.gz",
    cache_dir   => $cache_dir,
    before      => Exec['untar-s3cmd'],
  }

  exec { 'untar-s3cmd':
    command => "tar -zxvf /tmp/s3cmd-${s3cmd::params::commit_sha1_abbreviation}.tar.gz -C /tmp"
  }

  exec { 'install-s3cmd':
    cwd     => "/tmp/s3tools-s3cmd-${s3cmd::params::commit_sha1_abbreviation}",
    command => 'python setup.py install',
    require => [Exec['untar-s3cmd'], Package['python-setuptools']]
  }
}