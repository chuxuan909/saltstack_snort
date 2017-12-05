#!/bin/sh
#
# chkconfig: 2345 98 82
# description: Starts and stops the snort intrusion detection system
#
# config: /etc/snort.conf
# processname: snort
# Source function library
. /etc/rc.d/init.d/functions
BASE=snort
DAEMON="-D"
INTERFACE="-i eth0"
CONF="/usr/local/snort/etc/snort.conf"
# Check that $BASE exists.
[ -f /usr/local/bin/$BASE ] || exit 0
# Source networking configuration.
. /etc/sysconfig/network
# Check that networking is up.
[ ${NETWORKING} = "no" ] && exit 0
RETVAL=0
# See how we were called.
case "$1" in
  start)
        if [ -n "`/sbin/pidof $BASE`" ]; then
                echo -n $"$BASE: already running"
                echo ""
                exit $RETVAL
        fi
        echo -n "Starting snort service: "
        /usr/local/bin/$BASE $INTERFACE -c $CONF $DAEMON
        sleep 1
        action "" /sbin/pidof $BASE
        RETVAL=$?
        [ $RETVAL -eq 0 ] && touch /var/lock/subsys/snort
        ;;
  stop)
        echo -n "Shutting down snort service: "
        killproc $BASE
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/snort
        ;;
  restart|reload)
        $0 stop
        $0 start
        RETVAL=$?
        ;;
  status)
        status $BASE
        RETVAL=$?
        ;;
  *)
        echo "Usage: snort {start|stop|restart|reload|status}"
        exit 1
esac
exit $RETVAL
