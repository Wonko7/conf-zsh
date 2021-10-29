unset GUIX_PROFILE
if [ -z $GUIX_EXTRA_PROFILES ]; then
  GUIX_EXTRA_PROFILES=/home/wjc/.guix-extra-profiles
fi
for p in ~/conf/guix/profiles/*; do
        pn=$(basename $p)
        if [ -e $GUIX_EXTRA_PROFILES/$pn/etc/profile ]; then
          source $GUIX_EXTRA_PROFILES/$pn/etc/profile
        fi
done

export PATH="/run/setuid-programs:$PATH"
