#!/bin/bash

# dirty hack to make the MQTT messages sent by deye2mqtt.sh known to Home Assistant.
# Basically sends some MQTT messages to the Mosquitto broker that make Home Assistant auto-detect
# the information submitted by deye2mqtt.sh
#
# This will allow you to integrate your Deye Inverter's information into a Home Assistant installation
# via MQTT.
#
# Hacked together by Niels Ott <niels@drni.de>
# Use at own risk. License is GPL v3.
# This program may blow up your cat.
#



#!/bin/bash

IDENTIFIER="hostname_of_my_deye_inverter"
TOPIC="mywizardcastle/power/deye/currentg"
BROKER="hostname_or_ip_of_my_mqtt_broker" # for most people: localhost

device="\"device\":{
   \"identifiers\":\"${IDENTIFIER}\",
   \"name\":\"${IDENTIFIER} Deye Inverter\",
   \"model\":\"Deye Inverter MQTT Adapter Hack\",
   \"manufacturer\" : \"DrNI\"
  }
"

JSON="
{
  \"name\": \"Current Power Output\",
  \"unit_of_measurement\":\"W\",
  \"device_class\" : \"power\",
  \"unique_id\" : \"deye_inverter_${IDENTIFIER}_cpo\",
  \"schema\": \"state\",
  \"state_topic\": \"${TOPIC}\",
   \"value_template\": \"{{ value_json.current_power_output.value }}\",
  ${device}
}  
"
T="homeassistant/sensor/${IDENTIFIER}/${IDENTIFIER}_current_power_output/config"
J=$(echo "$JSON" | tr '\n' ' ' | sed 's/  */ /g' )
echo "$J" | mosquitto_pub -h "$BROKER" -r -l -t "$T"


JSON="
{
  \"name\": \"Yield Today\",
  \"unit_of_measurement\":\"kWh\",
  \"device_class\" : \"energy\",
  \"unique_id\" : \"deye_inverter_${IDENTIFIER}_yt\",
  \"schema\": \"state\",
  \"state_topic\": \"${TOPIC}\",
   \"value_template\": \"{{ value_json.yield_today.value }}\",
  ${device}
}  
"
T="homeassistant/sensor/${IDENTIFIER}/${IDENTIFIER}_yield_today/config"
J=$(echo "$JSON" | tr '\n' ' ' | sed 's/  */ /g' )
echo "$J" | mosquitto_pub -h "$BROKER" -r -l -t "$T"



JSON="
{
  \"name\": \"Total Yield\",
  \"unit_of_measurement\":\"kWh\",
  \"device_class\" : \"energy\",
  \"unique_id\" : \"deye_inverter_${IDENTIFIER}_ty\",
  \"schema\": \"state\",
  \"state_topic\": \"${TOPIC}\",
   \"value_template\": \"{{ value_json.total_yield.value }}\",
  ${device}
}  
"
T="homeassistant/sensor/${IDENTIFIER}/${IDENTIFIER}_total_yield/config"
J=$(echo "$JSON" | tr '\n' ' ' | sed 's/  */ /g' )
echo "$J" | mosquitto_pub -h "$BROKER" -r -l -t "$T"
