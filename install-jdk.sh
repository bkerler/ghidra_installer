#!/bin/sh
echo "Downloading JDK .. please wait..."
wget https://download.java.net/java/GA/jdk11/9/GPL/openjdk-11.0.2_linux-x64_bin.tar.gz
echo "Done downloading. Instlaling ..."
sudo tar xzvf openjdk-11.0.2_linux-x64_bin.tar.gz --directory /usr/lib/jvm
sudo cp .jdk-11.0.2.jinfo /usr/lib/jvm

sudo update-alternatives --install /usr/bin/appletviewer appletviewer /usr/lib/jvm/jdk-11.0.2/bin/appletviewer 180
sudo update-alternatives --install /usr/bin/extcheck extcheck /usr/lib/jvm/jdk-11.0.2/bin/extcheck 180
sudo update-alternatives --install /usr/bin/idlj idlj /usr/lib/jvm/jdk-11.0.2/bin/idlj 180
sudo update-alternatives --install /usr/bin/jar jar /usr/lib/jvm/jdk-11.0.2/bin/jar 180
sudo update-alternatives --install /usr/bin/jarsigner jarsigner /usr/lib/jvm/jdk-11.0.2/bin/jarsigner 180
sudo update-alternatives --install /usr/bin/java java /usr/lib/jvm/jdk-11.0.2/jre/bin/java 180
sudo update-alternatives --install /usr/bin/javac javac /usr/lib/jvm/jdk-11.0.2/bin/javac 180
sudo update-alternatives --install /usr/bin/javadoc javadoc /usr/lib/jvm/jdk-11.0.2/bin/javadoc 180
sudo update-alternatives --install /usr/bin/javafxpackager javafxpackager /usr/lib/jvm/jdk-11.0.2/bin/javafxpackager 180
sudo update-alternatives --install /usr/bin/javah javah /usr/lib/jvm/jdk-11.0.2/bin/javah 180
sudo update-alternatives --install /usr/bin/javap javap /usr/lib/jvm/jdk-11.0.2/bin/javap 180
sudo update-alternatives --install /usr/bin/javapackager javapackager /usr/lib/jvm/jdk-11.0.2/bin/javapackager 180
sudo update-alternatives --install /usr/bin/javaws javaws /usr/lib/jvm/jdk-11.0.2/bin/javaws 180
sudo update-alternatives --install /usr/bin/jcmd jcmd /usr/lib/jvm/jdk-11.0.2/bin/jcmd 180
sudo update-alternatives --install /usr/bin/jconsole jconsole /usr/lib/jvm/jdk-11.0.2/bin/jconsole 180
sudo update-alternatives --install /usr/bin/jcontrol jcontrol /usr/lib/jvm/jdk-11.0.2/bin/jcontrol 180
sudo update-alternatives --install /usr/bin/jdb jdb /usr/lib/jvm/jdk-11.0.2/bin/jdb 180
sudo update-alternatives --install /usr/bin/jdeps jdeps /usr/lib/jvm/jdk-11.0.2/bin/jdeps 180
sudo update-alternatives --install /usr/bin/jexec jexec /usr/lib/jvm/jdk-11.0.2/jre/lib/jexec 180
sudo update-alternatives --install /usr/bin/jhat jhat /usr/lib/jvm/jdk-11.0.2/bin/jhat 180
sudo update-alternatives --install /usr/bin/jinfo jinfo /usr/lib/jvm/jdk-11.0.2/bin/jinfo 180
sudo update-alternatives --install /usr/bin/jjs jjs /usr/lib/jvm/jdk-11.0.2/bin/jjs 180
sudo update-alternatives --install /usr/bin/jmap jmap /usr/lib/jvm/jdk-11.0.2/bin/jmap 180
sudo update-alternatives --install /usr/bin/jmc jmc /usr/lib/jvm/jdk-11.0.2/bin/jmc 180
sudo update-alternatives --install /usr/bin/jps jps /usr/lib/jvm/jdk-11.0.2/bin/jps 180
sudo update-alternatives --install /usr/bin/jrunscript jrunscript /usr/lib/jvm/jdk-11.0.2/bin/jrunscript 180
sudo update-alternatives --install /usr/bin/jsadebugd jsadebugd /usr/lib/jvm/jdk-11.0.2/bin/jsadebugd 180
sudo update-alternatives --install /usr/bin/jstack jstack /usr/lib/jvm/jdk-11.0.2/bin/jstack 180
sudo update-alternatives --install /usr/bin/jstat jstat /usr/lib/jvm/jdk-11.0.2/bin/jstat 180
sudo update-alternatives --install /usr/bin/jstatd jstatd /usr/lib/jvm/jdk-11.0.2/bin/jstatd 180
sudo update-alternatives --install /usr/bin/jvisualvm jvisualvm /usr/lib/jvm/jdk-11.0.2/bin/jvisualvm 180
sudo update-alternatives --install /usr/bin/keytool keytool /usr/lib/jvm/jdk-11.0.2/jre/bin/keytool 180
sudo update-alternatives --install /usr/bin/native2ascii native2ascii /usr/lib/jvm/jdk-11.0.2/bin/native2ascii 180
sudo update-alternatives --install /usr/bin/orbd orbd /usr/lib/jvm/jdk-11.0.2/jre/bin/orbd 180
sudo update-alternatives --install /usr/bin/pack200 pack200 /usr/lib/jvm/jdk-11.0.2/jre/bin/pack200 180
sudo update-alternatives --install /usr/bin/policytool policytool /usr/lib/jvm/jdk-11.0.2/jre/bin/policytool 180
sudo update-alternatives --install /usr/bin/rmic rmic /usr/lib/jvm/jdk-11.0.2/bin/rmic 180
sudo update-alternatives --install /usr/bin/rmid rmid /usr/lib/jvm/jdk-11.0.2/jre/bin/rmid 180
sudo update-alternatives --install /usr/bin/rmiregistry rmiregistry /usr/lib/jvm/jdk-11.0.2/jre/bin/rmiregistry 180
sudo update-alternatives --install /usr/bin/schemagen schemagen /usr/lib/jvm/jdk-11.0.2/bin/schemagen 180
sudo update-alternatives --install /usr/bin/serialver serialver /usr/lib/jvm/jdk-11.0.2/bin/serialver 180
sudo update-alternatives --install /usr/bin/servertool servertool /usr/lib/jvm/jdk-11.0.2/jre/bin/servertool 180
sudo update-alternatives --install /usr/bin/tnameserv tnameserv /usr/lib/jvm/jdk-11.0.2/jre/bin/tnameserv 180
sudo update-alternatives --install /usr/bin/unpack200 unpack200 /usr/lib/jvm/jdk-11.0.2/jre/bin/unpack200 180
sudo update-alternatives --install /usr/bin/wsgen wsgen /usr/lib/jvm/jdk-11.0.2/bin/wsgen 180
sudo update-alternatives --install /usr/bin/wsimport wsimport /usr/lib/jvm/jdk-11.0.2/bin/wsimport 180
sudo update-alternatives --install /usr/bin/xjc xjc /usr/lib/jvm/jdk-11.0.2/bin/xjc 180

sudo update-java-alternatives -s jdk-11.0.2
rm openjdk-11.0.2_linux-x64_bin.tar.gz
