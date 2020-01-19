# sdrplay_dump1090
Docker container for ADS-B and SDRPlay devices

This docker container can be used to feed data to ADS-B applications like flightradar24, flightaware, radarbox24, virtualradar server, etc. It is a direct replacement of [ShoGinn/dump1090](https://github.com/ShoGinn/dump1090) for SDRPlay devices and could be used with the [ShoGinn](https://github.com/ShoGinn) suite of ADS-B applications.

It works with compatible devices including:
* RSP1, RSP1A, RSP2, RSPDuo (single tuner mode) SDRPlay devices
* Any RTLSDR USB device
* Any network AVR or BEAST device

This image is built from the dump1090 binary available at the [SDRPlay](https://www.sdrplay.com/downloads/) site. The sources are available at [SDRplay/dump1090](https://github.com/SDRplay/dump1090).

# Container Setup

Ensure you pass your USB device path.
Also make sure you add the capability ```--cap-add=SYS_NICE``` otherwise you will get errors (this helps it play nice ;) )
### Defaults
* Port 30002/tcp is used for raw output and is exposed by default
* Port 30003/tcp is used for BaseStation output and is exposed by default
* Port 30005/tcp is for Beast output and is exposed by default

### User Configured
* No user configurable options

#### Example docker run

```
docker run -d \
--restart unless-stopped \
--name='sdrplay_dump1090' \
--cap-add=SYS_NICE \
--device=/dev/bus/usb \
f4fhh/sdrplay_dump1090
```
### HISTORY
 - Version 0.1.0: Initial build

### Credits
 - [SDRPlay](https://github.com/SDRplay) for the SDK of the RSP devices
 - [ShoGinn](https://github.com/ShoGinn) for the suite of ADS-B applications
