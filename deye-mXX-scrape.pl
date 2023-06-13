#!/usr/bin/perl
#
# A dirty hack to web-scrape data from the Deye Sun M60G inverter. (Probably also working for other models of the M-series)
#
# This script simply reads the web page of the inverter and looks for values in its source code.
# 
# The functionality of this script may break any time when the inverter firmware gets updated 
# and the webpage uses different code.
#
# 
#

use strict;
use utf8;
use HTTP::Tiny;

my $inverterHostName =$ARGV[0];


# this is the page with the interesting stuff, include the default auth 
# credentials
my $URL = "http://admin:admin\@$inverterHostName/status.html";

# perform request and check for success
my $response = HTTP::Tiny->new->get($URL);
die "Failed to read $URL!\n" unless $response->{success};

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

# show result
print("Current Power Output:\t$powerOutput W\n");
print("Yield Today:\t$yieldToday kWh\n");
print("Total Yield:\t$yieldToday kWh\n");
