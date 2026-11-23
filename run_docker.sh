#!/bin/bash

###############################################
# Author: SG Langer Jan 2016
# Purpose: put all the Docker commands to build/run 
#	ddw-gway in one easy place
#
# Notes: If you are building from scratch, run this whole thing
#	If pulling from Docker hub, just run the RUN and EXEC lines
##########################################


############## main ###############
# Purpose: Based on command line arg either
#		a) build all Docker from scratch or
#		b) kill running docker or
#		c) start Docker or
#		d) restart
# Caller: user
###############################
clear
# the dockers only see each other on the IP of the Docker host

vmtype=$(sudo virt-what|grep virtualbox)
if [ $vmtype ] ; then
        # Vbox
        echo $vmtype
        host="10.0.2.2"
else
        # VMware
        echo $vmtype
        host="172.17.0.1"
fi
ROOT=$(pwd)

image="policlass"
#instance=$(sudo docker inspect --format '{{ .Author }}' $image)
instance="political-classifier"
srvc=$instance

case "$1" in
	build)
		# first clean up if any running instance
		# Comment out the rmi line if you really don't want to rebuild the docker
		sudo docker stop $instance
		sudo docker rmi -f $image
		sudo docker rm $instance

		# we extend the base  image with tools of our own
		#sudo docker pull $image
		sudo docker build -t  $image .
		# $0 start
	;;

	conn)
		sudo docker exec -it $instance /bin/bash 
	;;

	conn_r)
		sudo docker exec -u root -it $instance /bin/bash
	;;

	restart)
		$0 stop
		$0 start
	;;

	status)
		sudo docker ps; echo
		sudo docker images 
	;;

	stop)
		# stops but does not remove image from DOcker engine
		sudo docker stop $instance
		sudo docker rm $instance
	;;

	start)
		sudo docker run --rm -e ANTHROPIC_API_KEY=sk-ant-... $image
	;;

	start_p)
		sudo docker rm -f $instance
		# here we launch DOcker w/out the --net="host" tag , but then no ports are exposed including 104
		# so we expose them one at a time with -p switches on the container address
		host=$(sudo docker inspect --format '{{ .NetworkSettings.IPAddress }}' $instance)
		# the trick is to know the IP before the docker is created, and yes it is a trick
		sudo docker run --rm \
  			-e ANTHROPIC_API_KEY=sk-ant-... \
  			-v "$(pwd)/data:/data" \
  			$image \
  			--input posts.csv --text-col text --id-col post_id --output results.csv

		sleep 3
		$0 status
	;;


	*)
		echo "invalid option"
		echo "valid options: build/start/stop/status/conn"
		exit
	;;
esac
