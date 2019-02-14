source  $INIT_TMUX_SESSION_CONF
journalctl --no-hostname -p 6 -efb | ccze -A -o nolookups
