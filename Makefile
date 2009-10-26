install:
	install mpdstat.pl /usr/local/sbin
	mkdir -p /usr/local/etc/periodic/security
	install 900.mpdstat /usr/local/etc/periodic/security
	echo 'To use with periodic script, add $$daily_status_security_mpdstatus_enable="YES" in /etc/periodic.conf.'
