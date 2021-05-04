for p in ~/conf/guix/profiles/*; do
        pn=$(basename $p)
        #echo $GUIX_EXTRA_PROFILES/$pn/etc/profile
        if [ -e $GUIX_EXTRA_PROFILES/$pn/etc/profile ]; then
          unset GUIX_PROFILE
          #echo YES. $GUIX_EXTRA_PROFILES/$pn/etc/profile
          source $GUIX_EXTRA_PROFILES/$pn/etc/profile
        fi
done
unset GUIX_PROFILE

export PATH="/run/setuid-programs:$PATH"
