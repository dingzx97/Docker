FROM ubuntu:18.04

LABEL maintainer="dingzx97"

# 新建mysql用户
RUN groupadd -r mysql; \
	useradd -r -g mysql mysql

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
COPY mysqlclient-2.0.2-cp36-cp36m-linux_x86_64.whl /
RUN apt-get update; \
	apt-get upgrade; \
	apt-get install -y --no-install-recommends \
		python3.6 \
		python3-distutils \
		mysql-server \
		libmysqlclient20 \
		apache2 \
		libapache2-mod-wsgi-py3 \
		gosu;\
		
	ln -s /usr/bin/python3.6 /usr/bin/python3; \
	ln -s /usr/bin/python3 /usr/bin/python; \

	python get-pip.py --no-cache-dir -i https://pypi.tuna.tsinghua.edu.cn/simple \
		django==3.1.4 \
		Pillow==8.0.1 \
		mysqlclient-2.0.2-cp36-cp36m-linux_x86_64.whl; \

	apt-get clean; \
	rm -rf get-pip.py; \
	rm -rf mysqlclient-2.0.2-cp36-cp36m-linux_x86_64.whl; \
	rm -rf /var/lib/apt/lists/*

# 配置数据库和apache2
# 还是不太会写sh，还是先学习学习，暂时就手动启动服务吧
RUN echo "character-set-server = utf8" >> /etc/mysql/mysql.conf.d/mysqld.cnf

EXPOSE 80
EXPOSE 3306

CMD ["bash"]
