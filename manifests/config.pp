define s3cmd::config(
  $aws_access_key,
  $aws_secret_key,
  $ensure                = 'present',
  $user                  = $title,
  $bucket_location       = 'US',
  $use_https             = true,
  $encryption_passphrase = undef,
  $path_to_gpg           = '/usr/bin/gpg',
  $proxy_host            = undef,
  $proxy_port            = 0,
  $home_dir              = undef
) {

  if !($ensure in ['present', 'absent']) {
    fail('ensure must be either present or absent')
  }

  if $home_dir {
    $home_path = $home_dir
  }
  else {
    $home_path = $user ? {
      'root'  => '/root',
      default => "/home/${user}"
    }
  }

  file { "${home_path}/.s3cfg":
    ensure  => $ensure,
    content => template('s3cmd/s3cfg.erb'),
    owner   => $user,
    mode    => '0600',
  }
}