class munin::node::autoconf () {

  require munin::node::params

  if $munin::node::params::autoconf {
    # TODO: add concat as dependency
    include concat::setup

    $filter_file = '/tmp/munin_autoconf_filter'

    concat{ 'munin_node_autoconf_excl' :
      path  => $filter_file,
      force => true,
    }

    $filter = "$(cat ${filter_file})"
  
    exec {"munin-node-configure":
      #refreshonly => true,
      command     => "munin-node-configure --shell ${filter} | sh",
      unless      => "[ $(munin-node-configure --shell ${filter} 2> /dev/null | wc -l) = 0 ]",
      path        => ["/usr/bin", "/usr/sbin", "/bin"],
      notify      => Service[$munin::node::params::service_name],
    }
  }

}
