# Seacms

> 还是用中文介绍吧

## 准备工作

拉去 nginx 和 mariadb 这两个镜像

## 编写nginx配置文件

nginx/seacms.conf

```
server {
    listen       80;
    # 可以改成自己的域名
    server_name  localhost;

    rewrite ^([^.]*[^/])$ $1/ permanent;
    rewrite ^/frim/index(.+?)\.html$ /list/index.php?$1 last;
    rewrite ^/movie/index(.+?)\.html$ /detail/index.php?$1 last;
    rewrite ^/play/([0-9]+)-([0-9]+)-([0-9]+)\.html$ /video/index.php?$1-$2-$3 last;
    rewrite ^/topic/index(.+?)\.html$ /topic/index.php?$1 last;
    rewrite ^/topic/index\.html$ /topic/index.php?$1 last;
    rewrite ^/topiclist/(.+?).html$ /topiclist/index.php?$1 last;
    rewrite ^/index\.html$ index.php permanent;
    rewrite ^/news/index\.html$ /news/index.php?$1 last;
    rewrite ^/html/part/index(.+?)\.html$ /articlelist/index.php?$1 last;
    rewrite ^/html/article/index(.+?)\.html$ /article/index.php?$1 last;
	
    location ~ \.(css|js|ico|png|woff2|jpg|gif|html)$ {
    	# 这块是网站文件在nginx容器中的挂载位置
        root /www/movie/;
    }
	
    location / {
    	# 这块的seacms本来是指网站部署的地址，我这直接用容器的名称了
        fastcgi_pass  seacms:9000;
        fastcgi_index index.php;

        fastcgi_param SCRIPT_FILENAME /var/www/html$fastcgi_script_name;
        fastcgi_param QUERY_STRING    $query_string;
        fastcgi_param REQUEST_METHOD  $request_method;
        fastcgi_param CONTENT_TYPE    $content_type;
        fastcgi_param CONTENT_LENGTH  $content_length;
    }
}
```

## 编写docker-compose.yml 文件

docker-compose.yml

```
version: "3.9"

services:
    nginx:
        image: nginx
        container_name: nginx
        hostname: nginx
        restart: always
        networks:
            - seacms
        ports:
            - 80:80
        volumes:
            # 上面写的seacms.conf文件
            - ./nginx/seacms.conf:/etc/nginx/conf.d/default.conf
            # 将seacms的文件挂载到nginx容器的/www/movie/目录下了
            - seacms:/www/movie/

    mariadb:
        image: mariadb
        container_name: mariadb
        hostname: mariadb
        restart: always
        networks:
            - seacms
        volumes:
            - mariadb:/var/lib/mysql
        environment:
            # 设置数据库密码
            - MYSQL_ROOT_PASSWORD=123456

    
    seacms:
        image: dingzx97/cms:seacms
        container_name: seacms
        hostname: seacms
        restart: always
        networks:
            - seacms
        volumes:
            - seacms:/var/www/html/

volumes:
    mariadb:
    seacms:

networks:
    seacms:

```

## 运行

`docker-compose up -d`

然后直接用浏览器打开localhost就应该直接是安装的界面了。

在填写数据库地址的时候可以直接填写`mariadb`就好。

## 说明

在容器中运行的话还是会有许多的问题，比如说在资源库管理中添加了一个资源站，但是在资源库列表中看不到东西，要采集资源的话需要访问`http://localhost/<生成的后台地址>/admin_reslib.php?ac=list&rid=&url=<资源库地址>`。设置下分类的绑定就能采集了，但是也只是采集当天的，如果会改采集时的链接的话，把`day`改成`all`即可采集这个资源库中所有的资源。