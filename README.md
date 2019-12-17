# enginefeeder101/docker-cups-brother-mfc-l2710dw
CUPS Server Docker image for the Brother MFC-L2710DW

## Setup
### Volumes:
`/config`: where the persistent configurations will be stored
### Environment Variables:
`CUPSADMIN`: the CUPS admin user, defaults to `admin`
`CUPSPASSWORD`: the password for the CUPS admin user, defaults to `admin`
### Ports:
`631`: CUPS port

## Run with docker-compose
```
version: '3'

services:
  docker-cups-brother-mfc-l2710dw:
    image: enginefeeder101/docker-cups-brother-mfc-l2710dw:latest
    container_name: docker-cups-brother-mfc-l2710dw
    environment:
      - CUPSADMIN=admin
      - CUPSPASSWORD=admin
    volumes:
      - /data/docker-cups-brother-mfc-l2710dw:/config:rw
    ports:
      - 631:631
```

## Configure
Either configure CUPS through the files in `config` or use the web interface. The web interface can be found at [http://your-docker-server:631](#). Use `CUPSADMIN` & `CUPSPASSWORD` when you need to do something administrative.
