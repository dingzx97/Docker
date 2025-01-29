# MACCMS10

https://github.com/magicblack/maccms10

## build

```
docker build . -t maccms10
```

## setup

```
docker run --rm -u 82 -v $PWD/html:/var/www/html_copy maccms10 sh -c "cp -r /var/www/html/* /var/www/html_copy"
```
