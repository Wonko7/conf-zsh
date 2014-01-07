source  $INIT_TMUX_SESSION_CONF

tail -n $lines /var/log/daemon.log -f
