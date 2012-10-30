#! /bin/sh
### BEGIN INIT INFO
# Provides:		memcached
# Required-Start:	$remote_fs $syslog
# Required-Stop:	$remote_fs $syslog
# Should-Start:		$local_fs
# Should-Stop:		$local_fs
# Default-Start:	2 3 4 5
# Default-Stop:		0 1 6
# Short-Description:	Start memcached daemon
# Description:		Start up memcached, a high-performance memory caching daemon
### END INIT INFO


PATH=/usr/local/sbin:/usr/local/bin:/sbin:/bin:/usr/sbin:/usr/bin
DAEMON=/usr/bin/memcached
DAEMONBOOTSTRAP=/usr/share/memcached/scripts/start-memcached
NAME=memcached
DESC=memcached
PIDFILE=/var/run/$NAME.pid

test -x $DAEMON || exit 0
test -x $DAEMONBOOTSTRAP || exit 0

set -e

. /lib/lsb/init-functions

# Edit /etc/default/memcached to change this.
ENABLE_MEMCACHED=no
test -r /etc/default/memcached && . /etc/default/memcached

case "$1" in
  start)
	echo -n "Starting $DESC: "
  if [ $ENABLE_MEMCACHED = yes ]; then
	start-stop-daemon --start --quiet --exec $DAEMONBOOTSTRAP
	echo "$NAME."
	else
		echo "$NAME disabled in /etc/default/memcached."
	fi
	;;
  stop)
	echo -n "Stopping $DESC: "
	start-stop-daemon --stop --quiet --oknodo --pidfile $PIDFILE --exec $DAEMON
	echo "$NAME."
	rm -f $PIDFILE
	;;

  restart|force-reload)
	#
	#	If the "reload" option is implemented, move the "force-reload"
	#	option to the "reload" entry above. If not, "force-reload" is
	#	just the same as "restart".
	#
	echo -n "Restarting $DESC: "
	start-stop-daemon --stop --quiet --oknodo --pidfile $PIDFILE
	rm -f $PIDFILE
	sleep 1
	start-stop-daemon --start --quiet --exec $DAEMONBOOTSTRAP
	echo "$NAME."
	;;
  status)
	status_of_proc $DAEMON $NAME
	;;
  *)
	N=/etc/init.d/$NAME
	echo "Usage: $N {start|stop|restart|force-reload|status}" >&2
	exit 1
	;;
esac

exit 0
