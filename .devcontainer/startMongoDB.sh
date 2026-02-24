#!/bin/bash

set -euo pipefail

# Start MongoDB service
if pgrep -x mongod >/dev/null 2>&1; then
	echo "MongoDB is already running."
else
	sudo mkdir -p /data/db /var/log/mongodb
	if id -u mongodb >/dev/null 2>&1; then
		sudo chown -R mongodb:mongodb /data/db /var/log/mongodb
	fi

	sudo mongod \
		--fork \
		--dbpath /data/db \
		--bind_ip 127.0.0.1 \
		--port 27017 \
		--logpath /var/log/mongodb/mongod.log \
		--pidfilepath /tmp/mongod.pid
fi

echo "MongoDB has been started successfully!"
mongod --version

# Run sample MongoDB commands
echo "Current databases:"
mongosh --host 127.0.0.1 --port 27017 --eval "db.getMongo().getDBNames()"