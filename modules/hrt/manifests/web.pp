# Define: hrt::web
# Example usage:
# hrt::web { "web-1": }

class hrt::web ($workers = 1) {

  $user                = $hrt::user
  $approot             = $hrt::app_dir
  $homedir             = $hrt::home_dir
  $app_public          = "${hrt::app_dir}/public"
  $socket              = "/home/hrt/app/tmp/hrt-passenger.sock"
  $logdir              = "/var/log/hrt"
  $nginx_upstream      = "hrt-passenger"


  File {
    owner  => 'root',
    group  => 'root',
  }

  realize File['/etc/init/hrt-web.conf']

  file { "/etc/init/hrt-passenger.conf":
    ensure  => file,
    content => template('hrt/upstart-web.conf.erb'),
    require => [
      Class['hrt::upstart'],
    ]
  }

  # SSL Certificates
  # ----------------

  include hrt::certificates

  # Nginx Reverse Proxy
  # -------------------

  nginx::resource::upstream { $nginx_upstream :
    ensure  => present,
    members => [ "unix:/${socket} fail_timeout=0" ],
  }

  # We needs these directives so that nginx correctly proxies redirects
  # for example 127.0.0.1:8080 will lose the port when 302'ing without
  # these settings.

  # For some reason, these settings exist in `proxy.conf`, but don't reflect in
  # this context, so we load them again via `location_cfg_prepend`.
  $proxy_headers = [
    'proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for',
    'proxy_set_header Host $http_host',
    'proxy_set_header X-Forwarded-Proto $scheme',
    'proxy_redirect off',
  ]

  Class['hrt::certificates']
  ->
  nginx::resource::vhost { 'hrt':
    server_name           => ['hrt.local'],
    listen_options        => ' default_server',
    ensure                => present,
    proxy                 => "http://$nginx_upstream",
    location_cfg_prepend  => $proxy_headers,
    ssl                   => true,
    ssl_cert              => '/etc/nginx/ssl/server.crt',
    ssl_key               => '/etc/nginx/ssl/server.key',
  }


}
