if [ "$(uname -s)" = "Darwin" ]; then
    export JAVA_HOME=$(/usr/libexec/java_home -v1.8);
fi
