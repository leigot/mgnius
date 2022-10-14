FROM teddysun/xray

COPY config.json /etc/xray/config.json
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENV PATH /usr/bin/xray:$PATH
ENV PORT 8888
ENV TZ=Asia/Colombo

WORKDIR /etc/xray
ENTRYPOINT ["/entrypoint.sh"]
CMD ["xray", "-config=/etc/xray/config.json"]
