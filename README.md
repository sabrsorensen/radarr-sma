# radarr-aphrodite-sma

![Image OS](https://img.shields.io/badge/Image_OS-Alpine-blue)
[![Base Image](https://img.shields.io/badge/Base_Image-ghcr.io/hotio/radarr:musl-yellow)](https://ghcr.io/hotio/radarr)

## Upstream Projects

[![Upstream](https://img.shields.io/badge/upstream-Radarr-yellow)](https://github.com/Radarr/Radarr)
[![Upstream](https://img.shields.io/badge/upstream-sickbeard__mp4__automator-blue)](https://github.com/mdhiggins/sickbeard_mp4_automator)
[![Upstream](https://img.shields.io/badge/upstream-hotio/radarr-yellow)](https://github.com/hotio/docker-radarr)

## docker run

```sh
docker run --rm --name radarr \
    -p 8989:8989 \
    -v /docker/host/configs/radarr:/config/app \
    -v /docker/host/configs/sickbeard_mp4_automator/config:/opt/sma/config \
    -v /docker/host/configs/sickbeard_mp4_automator/post_process:/opt/sma/post_process \
    -v /docker/host/media:/data \
    ghcr.io/sabrsorensen/radarr-aphrodite-sma
```

From [hotio/radarr's documentation](https://github.com/hotio/docker-radarr/blob/master/README.md#starting-the-container):
The environment variables below are all optional, the values you see are the defaults.

```shell
-e PUID=1000
-e PGID=1000
-e UMASK=002
-e TZ="Etc/UTC"
-e ARGS=""
-e DEBUG="no"
```

## docker-compose.yml example

```yaml
radarr:
  ...
  image: ghcr.io/sabrsorensen/radarr-aphrodite-sma
  container_name: radarr
  environment:
    - PUID=1000
    - PGID=1000
    - TZ="Etc/UTC"
    - ARGS=""
    - DEBUG="no"
  ports:
    - 7878:7878
  volumes:
    - /docker/host/configs/radarr:/config/app                                           # Radarr config, database, logs, etc
    - /docker/host/configs/sickbeard_mp4_automator/config:/opt/sma/config               # sickbeard_mp4_automator's autoProcess.ini
    - /docker/host/configs/sickbeard_mp4_automator/post_process:/opt/sma/post_process   # sickbeard_mp4_automator's post-processing scripts
    - /docker/host/media:/data                                                          # The location of your media library
  labels:
    com.centurylinklabs.watchtower.enable: "false"                                      # Disable autoupdates to prevent interrupted conversions
  ...
```

## Additional documentation

Refer to the respective documentations for additional information on configuring and using
[Radarr](https://github.com/Radarr/Radarr),
[sickbeard_mp4_automator](https://github.com/mdhiggins/sickbeard_mp4_automator), and
[hotio/radarr](https://github.com/hotio/docker-radarr).

sickbeard_mp4_automator's `postRadarr.py` can be located at `/opt/sma/postRadarr.py`, use this path in your Radarr->Connect->Custom Script location.
