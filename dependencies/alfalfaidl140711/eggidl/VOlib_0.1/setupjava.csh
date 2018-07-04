setenv JAVA_HOME /usr/java/j2sdk1.4.2_04
setenv IDL_HOME /home/chrism/idl
set path = ($JAVA_HOME/bin $path)
setenv VOlib_DATA  $IDL_HOME/VOlib_0.1/data
set lib = $IDL_HOME/VOlib_0.1/classes

setenv CLASSPATH $lib
setenv CLASSPATH ${CLASSPATH}:$lib/axis.jar:$lib/commons-logging.jar
setenv CLASSPATH ${CLASSPATH}:$lib/xmlParserAPIs.jar:$lib/mail.jar:$lib/activation.jar
setenv CLASSPATH ${CLASSPATH}:$lib/commons-discovery.jar:$lib/saaj.jar:$lib/jaxrpc.jar:$lib/wsdl4j.jar
