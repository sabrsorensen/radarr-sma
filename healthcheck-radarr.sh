#! /bin/sh

config_path="/config/app/config.xml"
server_address=$(grep "<BindAddress>.*</BindAddress>" $config_path | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')
if [ "$server_address" = "*" ]
then
    server_address="localhost"
fi

server_port=$(grep "<Port>.*</Port>" $config_path | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')
api_key=$(grep "<ApiKey>.*</ApiKey>" $config_path | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')
url_base=$(grep "<UrlBase>.*</UrlBase>" $config_path | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')
echo $url_base
if [ -n "$url_base" ]
then
    url_base="$url_base/"
fi

url="http://${server_address}:${server_port}/${url_base}api/v3/health?apikey=${api_key}"

ssl_enabled=$(grep "<EnableSsl>.*</EnableSsl>" $config_path | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')
if [ "$ssl_enabled" = "True" ]
then
    ssl_server_port=$(grep "<SslPort>.*</SslPort>" $config_path | awk -F '>' '{print $2}' | awk -F '<' '{print $1}')
    ssl_url="https://${server_address}:${server_port}/${url_base}api/v3/health?apikey=${api_key}"
fi

if curl --silent --show-error -f $url
then
    if [ "$ssl_enabled" = "True" ]
    then
        if curl --silent --show-error -f $ssl_url
        then
            # both http and https are healthy
            exit 0
        else
            # https unhealthy
            exit 1
        fi
    else
        # http healthy, no https
        exit 0
    fi
else
    # http unhealthy
    exit 1
fi
