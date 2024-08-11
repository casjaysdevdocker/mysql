## 👋 Welcome to mysql 🚀  

mysql README  
  
  
## Install my system scripts  

```shell
 sudo bash -c "$(curl -q -LSsf "https://github.com/systemmgr/installer/raw/main/install.sh")"
 sudo systemmgr --config && sudo systemmgr install scripts  
```
  
## Automatic install/update  
  
```shell
dockermgr update mysql
```
  
## Install and run container
  
```shell
mkdir -p "$HOME/.local/share/srv/docker/mysql/rootfs"
git clone "https://github.com/dockermgr/mysql" "$HOME/.local/share/CasjaysDev/dockermgr/mysql"
cp -Rfva "$HOME/.local/share/CasjaysDev/dockermgr/mysql/rootfs/." "$HOME/.local/share/srv/docker/mysql/rootfs/"
docker run -d \
--restart always \
--privileged \
--name casjaysdevdocker-mysql \
--hostname mysql \
-e TZ=${TIMEZONE:-America/New_York} \
-v "$HOME/.local/share/srv/docker/casjaysdevdocker-mysql/rootfs/data:/data:z" \
-v "$HOME/.local/share/srv/docker/casjaysdevdocker-mysql/rootfs/config:/config:z" \
-p 80:80 \
casjaysdevdocker/mysql:latest
```
  
## via docker-compose  
  
```yaml
version: "2"
services:
  ProjectName:
    image: casjaysdevdocker/mysql
    container_name: casjaysdevdocker-mysql
    environment:
      - TZ=America/New_York
      - HOSTNAME=mysql
    volumes:
      - "$HOME/.local/share/srv/docker/casjaysdevdocker-mysql/rootfs/data:/data:z"
      - "$HOME/.local/share/srv/docker/casjaysdevdocker-mysql/rootfs/config:/config:z"
    ports:
      - 80:80
    restart: always
```
  
## Get source files  
  
```shell
dockermgr download src casjaysdevdocker/mysql
```
  
OR
  
```shell
git clone "https://github.com/casjaysdevdocker/mysql" "$HOME/Projects/github/casjaysdevdocker/mysql"
```
  
## Build container  
  
```shell
cd "$HOME/Projects/github/casjaysdevdocker/mysql"
buildx 
```
  
## Authors  
  
🤖 casjay: [Github](https://github.com/casjay) 🤖  
⛵ casjaysdevdocker: [Github](https://github.com/casjaysdevdocker) [Docker](https://hub.docker.com/u/casjaysdevdocker) ⛵  
