#!/bin/bash
USE_IFCONFIG=eth0
IP_ADDR=$(ifconfig $USE_IFCONFIG | grep "inet addr" | awk '{ print $2}' | awk -F: '{print $2}')
ntpdate ntp1.aliyun.com
tar -zxvf /opt/snort_install/daq-2.0.6.tar.gz -C /opt/snort_install
cd /opt/snort_install/daq-2.0.6 && ./configure && make && make install
tar -zxvf /opt/snort_install/snort-2.9.11.tar.gz -C /opt/snort_install
cd /opt/snort_install/snort-2.9.11 && ./configure --enable-sourcefire --prefix=/usr/local/snort &&  make && make install
tar -zxvf /opt/snort_install/snortrules-snapshot-29110.tar.gz -C /usr/local/snort/
rm -f  /usr/local/bin/snort
ln -s /usr/local/snort/bin/snort   /usr/local/bin/snort
sed -i 's/ipvar HOME_NET any/ipvar HOME_NET '$IP_ADDR'/g'  /usr/local/snort/etc/snort.conf
sed -i 's/ipvar EXTERNAL_NET any/ipvar EXTERNAL_NET !$HOME_NET/g'  /usr/local/snort/etc/snort.conf
sed -i 's#/usr/local/lib/snort_dynamicpreprocessor/#/usr/local/snort/lib/snort_dynamicpreprocessor/#g'  /usr/local/snort/etc/snort.conf
sed -i 's#/usr/local/lib/snort_dynamicengine/libsf_engine.so#/usr/local/snort/lib/snort_dynamicengine/libsf_engine.so#g' /usr/local/snort/etc/snort.conf
sed -i 's#/usr/local/lib/snort_dynamicrules#/usr/local/snort/lib/snort_dynamicrules#g' /usr/local/snort/etc/snort.conf
sed -i '325s/^/#&/g' /usr/local/snort/etc/snort.conf
touch /usr/local/snort/rules/white_list.rules
touch /usr/local/snort/rules/black_list.rules
[ ! -d /usr/local/snort/lib/snort_dynamicrules ] && mkdir  /usr/local/snort/lib/snort_dynamicrules
[ ! -d /var/log/snort ] &&mkdir -p /var/log/snort
touch /var/log/snort/alert
mv -f  /opt/snort_install/local.rules /usr/local/snort/rules/local.rules
mv -f  /opt/snort_install/ddos.rules /usr/local/snort/rules/ddos.rules
snort -Db   -c /usr/local/snort/etc/snort.conf
