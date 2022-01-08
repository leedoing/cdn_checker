FROM ubuntu:20.04
LABEL title="cdn_checker"
ARG DEBIAN_FRONTEND=noninteractive
ENV container="docker"

WORKDIR /cdn_checker
COPY . .
RUN apt-get update && apt-get install && apt-get install apt-utils -y
RUN apt-get install -y \
    mutt \
    curl \
    traceroute \
    bc \
    dnsutils \
    sendmail \
    vim
RUN chmod +x cdn_checker.sh
ENTRYPOINT ["./cdn_checker.sh"]

CMD ["https://media.amazonwebservices.com/urchin.js", "lluckyy77@gmail.com"]
