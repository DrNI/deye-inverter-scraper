#!/usr/bin/perl
#
# A dirty hack to web-scrape data from the Deye Sun M60G inverter. (Probably also working for other models of the M-series)
#
# This script simply reads the web page of the inverter and looks for values in its source code.
# 
# The functionality of this script may break any time when the inverter firmware gets updated 
# and the webpage uses different code.
#
# Hacked together by Niels Ott <niels@drni.de>
# Use at own risk. License is GPL v3.
# This program may blow up your cat.
#

use strict;
use utf8;
use HTTP::Tiny;

my $json=0;
my $inverterHostName =$ARGV[0];

if ( "$inverterHostName" eq "-j" ) {
    $json = 1;
    $inverterHostName =$ARGV[1];
} 

# this is the page with the interesting stuff, include the default auth 
# credentials
my $URL = "http://admin:admin\@$inverterHostName/status.html";

# perform request and check for success
my $response = HTTP::Tiny->new->get($URL);
die "Failed to read $URL!" unless $response->{success};

# store webpage content
my $sPage = $response->{content};

# scrape desired data using cheap RegExes
my $powerOutput = "--";
if ( $sPage =~ /var webdata_now_p = \"([\d\.]+)\"/ ) {
    $powerOutput = $1;
}

my $yieldToday = "--";
if ( $sPage =~ /var webdata_today_e = \"([\d\.]+)\";/ ) {
    $yieldToday = $1;
}

my $yieldTotal = "--";
if ( $sPage =~ /var webdata_total_e = \"([\d\.]+)\";/ ) {
    $yieldTotal = $1;
}

if ( $powerOutput =~ m/--/ ) {
    die("Could not read proper data from $URL!");
}

# show result
if ( $json ) {
print("{
\"current_power_output\" : {
    \"value\" : \"$powerOutput\",
    \"unit\" : \"W\"
  },
\"yield_today\" : {
    \"value\" : \"$yieldToday\",
    \"unit\" : \"kWh\"
  },
\"total_yield\" : {
    \"value\" : \"$yieldTotal\",
    \"unit\" : \"kWh\"
  }
}
");
} else {
print("Current Power Output:\t$powerOutput W\n");
print("Yield Today:\t$yieldToday kWh\n");
print("Total Yield:\t$yieldTotal kWh\n");
}

