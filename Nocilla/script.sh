while [$(ps aux | grep otest | wc -l | awk {'print $1'} -gt 1)]; do
	sleep 1
done