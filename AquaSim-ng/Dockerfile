FROM ubuntu:18.04

LABEL maintainer="dingzx97"

# 换源
COPY sources.list /etc/apt/sources.list
RUN apt-get update; \
	apt-get install -y --no-install-recommends ca-certificates; \
	sed -i 's/http/https/g' /etc/apt/sources.list; \
	rm -rf /var/lib/apt/lists/*

# 设置中文编码
RUN apt-get update; \
	apt-get upgrade; \
	apt-get install -y --no-install-recommends language-pack-zh-hans; \
	rm -rf /var/lib/apt/lists/*
ENV LANG="zh_CN.utf8" LANGUAGE="zh_CN.utf8" LC_ALL="zh_CN.utf8" 

# 开始安装需要的东西
COPY get-pip.py /
ADD aquasim-ng.tgz /root/
RUN apt-get update; \
	apt-get upgrade; \
	apt-get install -y --no-install-recommends \
		build-essential \
		cmake \
		unzip \
		python3.6 \
		python3-distutils;\
		
	ln -s /usr/bin/python3.6 /usr/bin/python3; \
	ln -s /usr/bin/python3 /usr/bin/python; \

	python get-pip.py --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple; \

	apt-get clean; \
	rm -rf get-pip.py; \
	rm -rf /var/lib/apt/lists/*

# 编译aquasim-ng，运行startwork.sh脚本
WORKDIR /root
COPY startwork.sh /root/

CMD ["bash"]
