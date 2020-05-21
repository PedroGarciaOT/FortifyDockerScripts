#!/bin/sh
export FORTIFY_HOME=/tools/fortify
export FORTIFY_SSC_HOME=$FORTIFY_HOME
export FORTIFY_SSC_SEARCH_INDEX=$FORTIFY_HOME/search-index
export CATALINA_HOME=$FORTIFY_SSC_HOME/tomcat
export PATH=$CATALINA_HOME/bin:$FORTIFY_SSC_HOME/bin:$FORTIFY_SSC_HOME/Tools/fortifyclient/bin:$PATH
