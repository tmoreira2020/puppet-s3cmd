class s3cmd::install {

  package {"python-setuptools":
    ensure     => "installed"
  }

  wget::fetch { 'fetch-s3cmd':
    source      => "https://github.com/s3tools/s3cmd/tarball/${s3cmd::params::commit_sha1}",
    destination => /tmp/s3cmd-${s3cmd::params::commit_sha1}.tar.gz,
    cache_dir   => $cache_dir,
    before      => Exec['untar-s3cmd'],
  }

  exec { "untar-s3cmd":
    path       => "/bin",
    command    => "tar -zxvf /tmp/s3cmd-${s3cmd::params::commit_sha1}.tar.gz -C /tmp"
  }

  exec { "install-s3cmd":
    path       => "/bin",
    cwd        => "/tmp/s3tools-s3cmd-${s3cmd::params::commit_sha1}",
    command    => "python setup.py install",
    require    => [Exec["untar-s3cmd"], Package["python-setuptools"]]
  }
}