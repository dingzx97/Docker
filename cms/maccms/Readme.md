# 苹果cms

## 开始使用

因为是基于php-fpm的，所以需要个nginx，还要有mysql数据库。可以直接在docker中拉取相关的镜像，或者是直接运行这个[`docker-compose.yml`](https://github.com/dingzx97/Docker/blob/master/cms/maccms/docker-compose.yml)，需要下载这个nginx的[配置文件](https://github.com/dingzx97/Docker/blob/master/cms/maccms/nginx/maccms.conf)。

容器运行起来后就直接访问[`localhost`](http://localhost)进行设置，主要就是连接数据库，如果是用我写的配置文件的话，数据库地址是`mariadb`，数据库账号`root`，密码是`123456`。

设置好了之后需要修改admin.php的名字，执行下面命令：

`docker exec <maccms容器名称> mv admin.php <新名称>.php`

要登录后台的话就访问`localhost/<新名称>.php`。

访问[`localhost`](http://localhost)就能看到网站的首页了，maccms不自带模板，我添加了个免费的模板，界面比较少，可以自行去网上下载别的maccms模板安装使用。



## 视频采集

网站搭好了，但是没有视频，需要自行去网上寻找视频采集网站，搜索`资源采集网站`，人家会告诉怎么去采集资源。

在`后台-采集-自定义接口`添加了采集站的链接之后，点击`资源站`那一列可以进行对资源站的数据进行分类绑定，绑定好分类之后就点右侧的采集就好。

## 自动采集

1. 首先右键`采集当天`，选择`复制链接地址`;
2. 在`系统-定时任务配置`里添加一个定时任务，在`附加参数`那块把复制的链接粘贴上，然后把前面的网址去掉，只要`?号`后面的参数；
3. 保存之后点击测试看看这个东西能不能用，应该是没有问题的，然后右键`测试`，选择`复制链接地址`；
4. 在`系统-网站参数配置-统计代码`里面添加`<script src="/api.php/timming/index.html?enforce=1&name=<任务名称>"></scrip>`。
```
# 好像还要加上 -v /etc/localtime:/etc/localtime:ro 才能自动采集
# 想要每十五分采集一次就不用改，每小时采集一次就把下面的`15min`改成`hourly`，每天改为`daily`，每周改为`weekly`，每月改为`monthly`
docker exec <maccms容器名称> sh -c 'echo -e "#!/bin/sh" > /etc/periodic/15min/auto_collect.sh'
docker exec <maccms容器名称> sh -c 'echo -e "curl -s -o /dev/null \"<复制测试的链接地址>\"" >> /etc/periodic/15min/auto_collect.sh'
docker exec <maccms容器名称> chmod +x /etc/periodic/15min/auto_collect.sh
```

## 网站统计

可以去看看怎么统计网站，把统计的js代码复制到`系统-网站参数配置-统计代码`里面即可。