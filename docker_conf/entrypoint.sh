#!/usr/bin/dumb-init /bin/sh
# ----------------------------------------------------------------------------
# entrypoint for container
# ----------------------------------------------------------------------------
set -e

HOST_IP=`/bin/grep $HOSTNAME /etc/hosts | /usr/bin/cut -f1`
export HOST_IP=${HOST_IP}
echo
echo "container started with ip: ${HOST_IP}..."
echo
for script in /container-init.d/*; do
	case "$script" in
		*.sh)     echo "... running $script"; . "$script" ;;
		*)        echo "... ignoring $script" ;;
	esac
	echo
done

if [ "$1" == "airwatch" ]; then
	echo "starting with air watch...."
	cd /go
	exec /usr/local/go/bin/air -d -c /etc/air.conf
elif [ "$1" == "shell" ]; then
	echo "starting /bin/sh..."
	/bin/sh
else
	echo "Running something else ($@)"
	exec "$@"
fi