## _CDN CHECKER_

## Features
1) Host Information for example host name, dns_resolver
2) Resolving CDN DNS Query
3) Checking Object download speed and response header
4) Network traceroute
5) Mailing

Sometimes you have a failure of CDN like CloudFront, Akamai and so on.
You need information about cdn and the host environment.
It will help you to get the information and prove that it's not your fault easily.

## Installation and Result
The script supports Amazon Linux2 and Ubuntu
```sh
git clone https://github.com/leedoing/cdn_checker.git
cd cdn_checker
chmod +x cdn_checker.sh
sudo ./cdn_checker.sh "targetUrl" "email"

e.g)
ubuntu@ip-10-0-0-100:~/cdn_checker$ sudo ./cdn_checker.sh https://media.amazonwebservices.com/urchin.js leedoing@openrun.com
- URL: https://media.amazonwebservices.com/urchin.js
- EMAIL: leedoing@openrun.com
- Installing packages(mutt, curl, traceroute, sendmail)
- OS: Ubuntu
- Installed packages
- [1. DNS RESOLVE]
- [2. CURL SPEED]
- [3. RESPONSE HEADER]
- [4. NETWORK TRACEROUTE]
- [5. Mailing...]
- Sent mail, Please check inbox with spam
- log path: /home/ubuntu/cdn_checker/log/checked_cdn_2022-01-08_06:24:37_ip-10-0-0-100.log
```
---
If you use other Linux, you can use docker. (Installed docker, sendmail package)
```sh
docker run -it -v `pwd`:/cdn_checker/log --net=host lluckyy/cdn_checker https://media.amazonwebservices.com/urchin.js leedoing@openrun.com

e.g) 
ubuntu@ip-10-0-0-100:~/cdn_checker$ docker run -it -v `pwd`:/cdn_checker/log --net=host "targetUrl" "email"
Unable to find image 'lluckyy/cdn_checker:latest' locally
latest: Pulling from lluckyy/cdn_checker
ea362f368469: Already exists
49ac8e2e7446: Pull complete
084d9983929c: Pull complete
05fc1d80bea5: Pull complete
aaf5c9d13d23: Pull complete
255146f717cc: Pull complete
Digest: sha256:e3c8e550fae69889e73eeefe31585e359d1b4c59cfd54dd37cc2c0cf07cbdf27
Status: Downloaded newer image for lluckyy/cdn_checker:latest
- URL: https://media.amazonwebservices.com/urchin.js
- EMAIL: leedoing@openrun.com
- Installing packages(mutt, curl, traceroute, sendmail)
- OS: Ubuntu/Docker
- Installed packages
- [1. DNS RESOLVE]
- [2. CURL SPEED]
- [3. RESPONSE HEADER]
- [4. NETWORK TRACEROUTE]
- [5. Mailing...]
- Sent mail, Please check inbox with spam
- log path: /cdn_checker/log/checked_cdn_2022-01-09_02:35:44_ip-10-0-0-100.log

## Return Results

##### [HOST NAME]
ip-10-0-1-168.ap-northeast-2.compute.internal

##### [Host DNS RESOLVER]
options timeout:2 attempts:5
; generated by /usr/sbin/dhclient-script
search ap-northeast-2.compute.internal
nameserver 10.0.0.2

##### [TARGET URL]
https://img.nxxxx17054_700.jpg

##### [CHECKING TIME]
2021-12-10_03:47:28

##### [1. DNS RESOLVE]
13.209.1.5
13.209.1.5
13.209.1.5
13.209.1.5
13.209.1.5
13.209.1.5

##### [2. CURL SPEED]
Fri Dec 10 03:25:38 UTC 2021 time_namelookup=0.003348 time_connect=.001010 time_starttransfer=.072312 time_total=0.081663


##### [3. RESPONSE HEADER]
HTTP/2 200  
content-type: image/jpeg  
content-length: 96775  
date: Fri, 10 Dec 2021 03:25:39 GMT  
last-modified: Fri, 10 Dec 2021 00:40:12 GMT  
etag: "bef3f126c296e610bcad5aed65451360"  
accept-ranges: bytes  
server: AmazonS3  
x-cache: Hit from cloudfront  
via: 1.1 4bf8622e8adc65246ece8c303890ee89.cloudfront.net (CloudFront)  
x-amz-cf-pop: ICN55-C1  
x-amz-cf-id: ruhHsBRa-QLKm_-YXhVtLFqeM61zSHDNQwEcQW9OkSgNAqOJriZuBw==  

##### [4. NETWORK TRACEROUTE]
traceroute to img.newsorigin.sbs.co.kr (52.85.231.48), 30 hops max, 60 byte packets  
1  * * *  
2  * * *  
3  * * *  
13  54.239.123.253 (54.239.123.253)  8.506 ms 54.239.123.247 (54.239.123.247)  8.483 ms 54.239.123.253 (54.239.123.253)  
15  100.64.50.111 (100.64.50.111)  6.700 ms 100.64.50.75 (100.64.50.75)  6.399 ms 100.64.50.91 (100.64.50.91)  6.197 ms  
16  100.64.50.254 (100.64.50.254)  6.753 ms  6.154 ms  4.570 ms  
17  * * *  
18  * * *  
19  server-52-85-231-48.icn55.r.cloudfront.net (52.85.231.48)  0.902 ms  0.876 ms  0.843 ms

