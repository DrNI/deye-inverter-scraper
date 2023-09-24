# deye-inverter-scraper
A web scraping hack to obtain power production values from a Deye solar inverter

## How to use

Assuming 192.168.1.123 is your Deye inverter, you can obtain data on the command line like  this:

`deye-mXX-scrape.pl 192.168.1.123`

Now let's say you want to store the current power production into a Mosquitto MQTT broker. Unroll your Unix magician skills and use the following magic on the command line:

`while [ true ] ; do CURRENT=$(./deye-mXX-scrape.pl 192.168.1.123 |grep "Current" | grep '[0-9]' | awk -F "\t" '{print($2)}') && mosquitto_pub -h 192.168.1.124 -m "$CURRENT" -t "mywizardcastle/power/deye/current" ; sleep 120 ; done`

Assuming 192.168.1.124 to be your Mosquitto MQTT Server/Broker: this will obtain the current power output from your inverter and message it to the broker. Then it will wait 2 minutes and repeat. 

## Drawbacks

At least that Deye inverter in my home has a very lousy WLAN connection, so many times it is not reachable at all.

Another thing is that the Deye inverter goes into stand-by mode during the night. Which is of course a good idea in general, but it does not enable you to distinguish between night time and WLAN drop-outs during the day, because both will simply generate a connection time out.
