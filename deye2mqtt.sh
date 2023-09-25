#!/bin/bash
#
# Another dirty hack to feed data web-scraped from a Deye inverter using deye-mXX-scrape.pl into 
# a Mosquitto MQTT broker
#
# Hacked together by Niels Ott <niels@drni.de>
# Use at own risk. License is GPL v3.
# This program may blow up your cat.
#


DEYE="ip_of_my_deye_inverter"
BROKER="ip_of_my_mqtt_broker"
TOPIC="mywizardcastle/power/deye/current"


while [ true ] ; do  
    CURRENT_JSON=$(deye-mXX-scrape.pl -j "$DEYE") && (
        JSON=$(echo "$CURRENT_JSON" | tr '\n' ' ' | sed 's/  */ /g')
        #echo "$JSON"
        echo "$JSON"|  mosquitto_pub -h "$BROKER" -l -t "$TOPIC" 
    )
    sleep 120
done
