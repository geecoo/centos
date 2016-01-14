#! /bin/sh
# myssh manager script
# 

prefix=/data/geecoo/linux
exec_prefix=${prefix}

speeder_bin=${exec_prefix}/speeder-bin
speeder_pid=${prefix}/speeder.pid


speeder_opts="ssh_sf2cup 4642 my3.bestspeeder.com 5051"

# chmod +x 
if [ ! -x $speeder_bin ] ; then
    chmod +x $speeder_bin 
fi

wait_for_pid () {
	try=0

	while test $try -lt 35 ; do

		case "$1" in
			'created')
			if [ -f "$2" ] ; then
				try=''
				break
			fi
			;;

			'removed')
			if [ ! -f "$2" ] ; then
				try=''
				break
			fi
			;;
		esac

		echo -n .
		try=`expr $try + 1`
		sleep 1

	done

}

case "$1" in
	start)
		echo -n "Starting speeder-bin "

		$speeder_bin  $speeder_opts &

		if [ "$?" != 0 ] ; then
			echo " failed"
			exit 1
		fi

		wait_for_pid created $speeder_pid

        PID=`ps aux | grep -v 'grep' | grep speeder-bin | awk '{print $2}'`
        if [ "$PID" -gt 0 ] ; then
            echo $PID > $speeder_pid
        fi

		if [ -n "$try" ] ; then
			echo " failed"
			exit 1
		else
			echo " done"
		fi
	;;

	stop)
		echo -n "Stop speeder-bin "

		if [ ! -r "$speeder_pid" ] ; then
			echo "warning, no pid file found - speeder-bin is not running ?"
			exit 1
		fi

		kill -9 `cat $speeder_pid`
        if [ "$?" == 0 ] ; then
            rm -f $speeder_pid
        fi
		wait_for_pid removed $speeder_pid

		if [ -n "$try" ] ; then
			echo " failed. Use force-quit"
			exit 1
		else
			echo " done"
		fi
	;;

	status)
		if [ ! -r $speeder_pid ] ; then
			echo "speeder-bin is stopped"
			exit 0
		fi

		PID=`cat $speeder_pid`
		if ps -p $PID | grep -q $PID; then
			echo "speeder-bin (pid $PID) is running..."
		else
			echo "speeder-bin dead but pid file exists"
		fi
	;;

	force-quit)
		echo -n "Terminating speeder-bin "

		if [ ! -r $speeder_pid ] ; then
			echo "warning, no pid file found - speeder-bin is not running ?"
			exit 1
		fi

		kill -TERM `cat $speeder_pid`

		wait_for_pid removed $speeder_pid

		if [ -n "$try" ] ; then
			echo " failed"
			exit 1
		else
			echo " done"
		fi
	;;

	restart)
		$0 stop
		$0 start
	;;

	reload)

		echo -n "Reload service speeder-bin "

		if [ ! -r $speeder_pid ] ; then
			echo "warning, no pid file found - speeder-bin is not running ?"
			exit 1
		fi

		kill -USR2 `cat $speeder_pid`

		echo " done"
	;;

	*)
		echo "Usage: $0 {start|stop|force-quit|restart|reload|status}"
		exit 1
	;;

esac
