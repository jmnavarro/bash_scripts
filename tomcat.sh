export JAVA_OPTS="$JAVA_OPTS -Xmx1024m -XX:MaxPermSize=256m"
 
case $1 in
  start)
    sh $CATALINA_HOME/bin/startup.sh

    if [ -n "$2" ]; then
      if  echo $2 | egrep "log"; then
        tail -f $CATALINA_HOME/logs/catalina.out
      fi
    fi
    ;;
  stop)
    sh $CATALINA_HOME/bin/shutdown.sh

    if [ -n "$2" ]; then
      if  echo $2 | egrep "log"; then
        tail -f $CATALINA_HOME/logs/catalina.out
      fi
    fi
    ;;
  kill)
    kill -9 `ps -ef | grep tomcat | awk '{print $2}'`
    ;;
  restart)
    sh $CATALINA_HOME/bin/shutdown.sh
    sleep 2;
    sh $CATALINA_HOME/bin/startup.sh
    ;;
  running)
    if ps -ef | grep tomcat | grep -q java ; then
      echo "yes"
    else
      echo "no"
    fi
    ;;
  ls)
    ls $CATALINA_HOME/webapps
    ;;
  clear)
    if [ -n "$2" ]; then
      rm -rf $CATALINA_HOME/webapps/${2}*
    else
      rm -rf $CATALINA_HOME/webapps/*
    fi
    ;;
  log*)
    tail -f $CATALINA_HOME/logs/catalina.out
    ;;
  deploy)
    if [ -n "$3" ]; then
      if echo $3 | grep -q "\.war" ; then
        cp $2 $CATALINA_HOME/webapps/${3}
      else
        cp $2 $CATALINA_HOME/webapps/${3}.war
      fi
    else
      cp $2 $CATALINA_HOME/webapps/
    fi
    ;;
  edit)
    if [ -n "$2" ]; then
      if  echo $2 | egrep -q "properties|xml|policy"; then
        vim $CATALINA_HOME/conf/$2
      else
        vim $CATALINA_HOME/conf/${2}.xml
      fi
    fi
    ;;
  *)
    cat <<EOF
Usage:
    start                    start the server
    stop                     stop the server
    kill                     kills the server
    restart                  restart the server
    running                  check if the server is running
    clear <webapp>           remove the specified webapp. Should only be used if the server is stopped
    log[s]                   tail the logs
    ls                       list the webapps currently deployed
    deploy <war> [context]   deploy the specified war to the context. defaults to the name of the war
    edit <file>              edit the specified config file
EOF
    ;;
esac
