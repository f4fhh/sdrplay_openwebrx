## From 2020-1-20 sdrplay_openwebrx development is discontinued.

I would like to say big thanks to everyone who supported me during this project.

Please go to the repository of [Jakob Ketterl](https://github.com/jketterl/openwebrx) who added docker builds to the official repository.

# sdrplay_openwebrx
Docker container for OpenwebRX web sdr on SDRPlay devices

It works with compatible devices including:
* RSP1, RSP1A, RSP2, RSPDuo (single tuner mode) SDRPlay devices
* Any RTLSDR USB device

### Defaults
* Port 8073/tcp is used for the GUI and is exposed by default

### User Configured
* No user configurable options

#### Example docker run

```
docker run -d \
--restart unless-stopped \
--name='sdrplay_openwebrx' \
--device=/dev/bus/usb \
f4fhh/sdrplay_openwebrx
```
### HISTORY
 - Version 0.1.0: Initial build
 - Version 0.2.0: New openwebrx version

### Credits
 - [SDRPlay](https://github.com/SDRplay) for the SDK of the RSP devices

