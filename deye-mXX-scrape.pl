#!/usr/bin/perl
#
# A dirty hack to web-scrape data from the Deye Sun M60G inverter. (Probably also working for other models of the M-series)
#
# This script simply reads the web page of the inverter and looks for values in its source code.
# 
# The functionality of this script may break any time when the inverter firmware gets updated 
# and the webpage uses different code.
#
# Written by Niels Ott <niels@drni.de>, released under GNU GPL3 – no warranties, you know that stuff. Use at own risk. May blow up your cat.
#

use strict;
use utf8;
use LWP::UserAgent;

my $inverterHostName =$ARGV[0];




my $URL = "http://$inverterHostName/status.html";

my $oHTTPAgent = new LWP::UserAgent;
my $oRequest = HTTP::Request->new('GET');
$oRequest->url($URL);
my $sResponse = $oHTTPAgent->request($oRequest);
my $sPage ='';
if ($sResponse->is_success) {
    $sPage = $sResponse->content;
} else {
    die("Cannot GET webpage $URL");
}


my $powerOutput = "";
if ( $sPage =~ /var webdata_now_p = \"([\d\.]+)\"/ ) {
    $powerOutput = $1;
}

my $yieldToday = "";
if ( $sPage =~ /var webdata_today_e = \"([\d\.]+)\";/ ) {
    $yieldToday = $1;
}

my $yieldTotal = "";
if ( $sPage =~ /var webdata_total_e = \"([\d\.]+)\";/ ) {
    $yieldTotal = $1;
}


print("Current Power Output:\t $powerOutput W\n");
print("Yield Today:\t $yieldToday kWh\n");
print("Total Yield:\t $yieldToday kWh\n");
