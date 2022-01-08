#!/bin/bash

##CDN performance checker
OS=$(cat /etc/*-release | grep -w NAME | cut -d= -f2 | tr -d '"')

if [ -z $1 ]||[ -z $2 ];then
        URL="https://media.amazonwebservices.com/urchin.js"
        EMAIL="lluckyy77@gmail.com"
else
        URL=$1
        EMAIL=$2
fi
echo "- URL: $URL"
echo "- EMAIL: $EMAIL"
#HOST NAME
echo "- Installing packages(mutt, curl, traceroute, sendmail)"
host_name=$(hostname)
if [ "$container" != "docker" ];then
        case $OS in
                *"Amazon"*|*"CentOS"*)
                echo "- OS: Amazon/CentOS"
                update=$(yum -y upgrade)
                #echo "$update"
                mutt=$(yum -y install mutt)
                #echo "$mutt"
                curl=$(yum -y install curl-devel)
                #echo "$curl"
        ;;
        *"Ubuntu"*)
                echo "- OS: Ubuntu"
                update=$(apt-get update && apt-get upgrade -y)
                #echo "$update"
                mutt=$(apt-get install mutt -y)
                #echo "$mutt"
                curl=$(apt-get install curl -y)
                #echo "$curl"
                traceroute=$(apt-get install traceroute -y)
                #echo "$traceroute"
                sendmail=$(apt-get install sendmail -y)
                #echo "$sendmail"
                ;;
        esac

else
        echo "- OS: Ubuntu/Docker"
fi
echo "- Installed packages"
dns_resolv=$(cat /etc/resolv.conf)
checking_time=$(date +"%Y-%m-%d_%H:%M:%S")
$(mkdir -p ./log)
# echo -n "- Input URL(ex. https://media.amazonwebservices.com/urchin.js): "
# read URL
# echo -n "- Input mail Address(ex. user@hostname.com): "
# read MAIL

pwd=$(pwd)
path="$pwd"/log/checked_cdn_"$checking_time"_"$host_name.log"
HOST=`echo $URL | cut -f3 -d"/"`

#Host Infomation
exec 3<> $path
echo "[HOST NAME]" >&3
echo "$host_name" >&3
echo >&3
echo "[HOST DNS RESOLVER]" >&3
echo "$dns_resolv" >&3
echo >&3

echo "[TARGET URL]" >&3
echo "$URL" >&3
echo >&3

echo "[CHECKING TIME]" >&3
echo "$checking_time" >&3
echo >&3

##1.DNS RESOLVER
echo "- [1. DNS RESOLVE]"
echo "[1. DNS RESOLVE]" >&3
SET=$(seq 0 10)
for i in $SET
do
        dns_query=$(dig resolver-identity.cloudfront.net +short)
        echo "$dns_query" >&3
done
echo >&3

##2. CURL SPEED
#curl_speed=$(curl -w "%{time_namelookup}/%{time_connect}/%{time_starttransfer}/%{time_total}" -tlsv1.2 -o /dev/null -s "https://images-na.ssl-images-amazon.com/images/G/01/awssignin/static/aws_logo_smile.png")
echo "- [2. CURL SPEED]"
echo "[2. CURL SPEED]" >&3
curl_speed=$(curl -w "%{time_namelookup}/%{time_connect}/%{time_starttransfer}/%{time_total}" -tlsv1.2 -o /dev/null -s "$URL")
        time_namelookup=`echo $curl_speed | cut -f1 -d"/"`
        time_connect=`echo $curl_speed | cut -f2 -d"/"`
        time_starttransfer=`echo $curl_speed | cut -f3 -d"/"`
        time_total=`echo $curl_speed | cut -f4 -d"/"`
        time_connect_r=`echo "$time_connect - $time_namelookup"|bc`
        time_starttransfer_r=`echo "$time_starttransfer - $time_connect"|bc`
echo $(date) time_namelookup=$time_namelookup time_connect=$time_connect_r time_starttransfer=$time_starttransfer_r time_total=$time_total >&3
echo >&3

##3. RESPONSE HEADER
#curl_header=$(curl -v -tlsv1.2 -o /dev/null -s "https://images-na.ssl-images-amazon.com/images/G/01/awssignin/static/aws_logo_smile.png")
echo "- [3. RESPONSE HEADER]"
echo "[3. RESPONSE HEADER]" >&3
curl_header=$(curl -I -tlsv1.2 -s "$URL")
echo "$curl_header" >&3
echo >&3

##4. NETWORK TRACE
echo "- [4. NETWORK TRACEROUTE]"
echo "[4. NETWORK TRACEROUTE]" >&3
network_trace=$(traceroute -T "$HOST")
echo "$network_trace" >&3
echo >&3

#Send mail
echo "- [5. Mailing...]"
mutt -s "CHECKED CDN_$URL" $EMAIL < $path
echo "- Sent mail, Please check inbox with spam"
echo - log path: $path
#echo Result
#echo "- Result"
#echo "$(cat "$path")"
