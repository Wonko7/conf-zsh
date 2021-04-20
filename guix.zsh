unset GUIX_PROFILE
for p in ~/conf/guix/profiles/*; do
	echo $p
        pn=$(basename $p)
        if [ -e $GUIX_EXTRA_PROFILES/$pn/etc/profile ]; then
          source $GUIX_EXTRA_PROFILES/$pn/etc/profile
          echo $GUIX_EXTRA_PROFILES/$pn/etc/profile
          echo $PATH
        fi
done
