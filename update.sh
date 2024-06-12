#!/bin/bash
if [ -z "$1" ]; then
    update_url="https://plugins.nessus.org/v2/nessus.php?f=all-2.0.tar.gz&u=fcf0fa67cab62e128098107854dab54f&p=3d69527244f31ff36a7cdd861fe273df"
else
    update_url=$1
fi
echo -e "---------------------\n"
echo -e "update_url: $update_url\n"
echo -e "---------------------\n"


echo -e "---------------------\n\n\n
 \033[1;32m「 正在下载插件，请耐心等待。。。 」\033[0m
 \033[1;32m「 Downloading plugins, please wait....」\033[0m\n\n\n\n---------------------"

wget -O "all-2.0.tar.gz" $update_url --no-check-certificate

RESULT=$(curl -s -k  https://plugins.nessus.org/v2/plugins.php)

filename=all-2.0.tar.gz
filesize=`ls -l $filename | awk '{ print $5 }'`
maxsize=$((1024*10))
if [ $filesize -gt $maxsize ]
then
    echo -e "\033[1;32m「 文件下载成功！\ndownload succeed! 」\033[0m\n\n"
else 
    echo -e "---------------------\n\n\n
    \033[1;31m「 文件下载出错，请检查网络！」\n    「download plugins error, please check network! 」\033[0m
    \n\n\n---------------------"
    exit
fi

/etc/init.d/nessusd stop  > /dev/null 2>&1

/bin/rm -rf /opt/nessus/lib/nessus/plugins/plugin_feed_info.inc

rm -rf /opt/nessus/var/nessus/agent-activity.db  > /dev/null 2>&1

/opt/nessus/sbin/nessuscli update all-2.0.tar.gz 

/etc/init.d/nessusd start 
echo -e "---------------------\n\n\n
\033[1;32m「 正在破解，请耐心等待。。。\n Cracking, please wait... 」\033[0m \n\n
\033[1;32m「 Crack by twitter@Elliot58616851 \n   && Thanks Open Source Enthusiast 」\033[0m  \n\n\n---------------------"

TIME_USED=0;
while true
do
    if [ ! -f "/opt/nessus/var/nessus/agent-activity.db" ]; then
        echo -e "dang cai dat vui long doi\ncompiling...please wait\ncount: $TIME_USED s\n---------------------";
        TIME_USED=$(($TIME_USED+3));
        sleep 3;
    else
        sleep 10;
        echo -e "---------------------\n
        \033[1;32m「 编译完成！\n      compile complete! 」\033[0m\n---------------------";
        break;
    fi

done

/etc/init.d/nessusd stop 

echo -e "---------------------\n\n\n\033[1;32m  「 破解成功，重启中。。。\n     Crack succeed, restarting...」\033[0m\n\n
\033[1;32m  「 Crack by twitter@Elliot58616851 \n   && Thanks Open Source Enthusiast 」\033[0m  \n---------------------"

echo -e ' 
#!/bin/bash\n
/bin/echo -e "PLUGIN_SET = \"'$RESULT'\";\nPLUGIN_FEED = \"ProfessionalFeed (Direct)\";\nPLUGIN_FEED_TRANSPORT = \"Tenable Network Security Lightning\";" > /opt/nessus/var/nessus/plugin_feed_info.inc 
/bin/rm -rf /opt/nessus/lib/nessus/plugins/plugin_feed_info.inc
/etc/init.d/nessusd start ' > /nessus/start.sh

rm -rf all-2.0.tar.gz 

/bin/echo -e "PLUGIN_SET = \"$RESULT\";\nPLUGIN_FEED = \"ProfessionalFeed (Direct)\";\nPLUGIN_FEED_TRANSPORT = \"Tenable Network Security Lightning\";" > /opt/nessus/var/nessus/plugin_feed_info.inc 
/bin/rm -rf /opt/nessus/lib/nessus/plugins/plugin_feed_info.inc
/etc/init.d/nessusd start

exit