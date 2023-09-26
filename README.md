# deye-inverter-scraper
A web scraping hack to obtain power production values from a Deye solar inverter

## How to use

Assuming 192.168.1.123 is your Deye inverter, you can obtain data on the command line like  this:

`deye-mXX-scrape.pl 192.168.1.123`

The command line switch `-j` will give you JSON formatted output.

## Feeding Mosquitto MQTT

Use `deye2mqtt.sh` to feed the data obtained with the Perl hack into your Mosquitto MQTT broker. Make sure to adjust the script to reflect your hostnames/IPs of the inverter and the broker.

## Home Assistant

Use `deye2mqtt2homeassist.sh` to announce the data submitted to the MQTT broker using `deye2mqtt.sh` to Home Assistant.

## Drawbacks

At least that Deye inverter in my home has a very lousy WLAN connection, so many times it is not reachable at all.

Another thing is that the Deye inverter goes into stand-by mode during the night. Which is of course a good idea in general, but it does not enable you to distinguish between night time and WLAN drop-outs during the day, because both will simply generate a connection time out.
