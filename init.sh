#!/bin/bash
# definir vars
base_path="$(cd -- "$(dirname "$0")" > /dev/null 2>&1 ; pwd -P)"
read -p 'Nombre Compose: ' compose_name
read -p 'Puerto Nginx: ' nginx_port
read -p 'Versión Symfony: ' symfony_version

compose_user="$(whoami)"
compose_uid="$(id -u)"
compose_file="$base_path/docker/docker-compose.yaml"
local_compose_file="$base_path/docker/docker-compose-local.yaml"
compose_up="COMPOSE_NAME=$compose_name COMPOSE_USER=$compose_user COMPOSE_UID=$compose_uid NGINX_PORT=$nginx_port docker compose -f $compose_file -f $local_compose_file up -d --remove-orphans --build"

tempdir="tempdir"
docker_exec="docker exec -t $compose_name.app"
create_project="$docker_exec ash -c \"composer create-project symfony/skeleton:\"$symfony_version\" $tempdir\""
relocate_project="$docker_exec ash -c \"mv $tempdir/* . && mv $tempdir/.[!.]* .\""
remove_tempdir="$docker_exec ash -c \"rm -rf $tempdir\""

# crear docker-compose-local.yaml si no existe
if [ ! -f "$local_compose_file" ]; then
    cat $local_compose_file.dist > $local_compose_file
fi

# crear archivos de configuración si no existen
docker_file="$base_path/docker/app/prod/Dockerfile"
if [ ! -f "$docker_file" ]; then
    cat $docker_file.dist > $docker_file
fi

php_ini_file="$base_path/docker/app/prod/php.ini"
if [ ! -f "$php_ini_file" ]; then
    cat $php_ini_file.dist > $php_ini_file
fi

fpm_conf_file="$base_path/docker/app/prod/php-fpm.conf"
if [ ! -f "$fpm_conf_file" ]; then
    cat $fpm_conf_file.dist > $fpm_conf_file
fi

nginx_conf_file="$base_path/docker/nginx/app.conf"
if [ ! -f "$nginx_conf_file" ]; then
    cat $nginx_conf_file.dist > $nginx_conf_file
fi

# up + build app
eval $compose_up app

# crear proyecto symfony
eval $create_project

# modificar estructura del proyecto
eval $relocate_project
eval $remove_tempdir

# up + build nginx
eval $compose_up nginx

# inicializar archivo y variables .env docker
echo COMPOSE_NAME=$compose_name > $base_path/docker/.env
echo COMPOSE_USER=$compose_user >> $base_path/docker/.env
echo COMPOSE_UID=$compose_uid >> $base_path/docker/.env
echo NGINX_PORT=$nginx_port >> $base_path/docker/.env