#!/usr/bin/env perl

# Print out the date for a PLUG meeting
#
# Example:
#
# $ plug_date west 2019 8
# 2019-08-19

use strict;
use warnings;
use feature qw(:5.30);
use experimental qw(signatures);

use DateTime;

usage() unless @ARGV == 3;
my ($plug, $yyyy, $mm) = @ARGV;
my $dt = DateTime->new(
                       year  => $yyyy,
                       month => $mm,
                       day   => 1,
                      );
my $dow = $dt->day_of_week;
my $plug_day;
if ($plug eq "central") {
    $plug_day = first_wed($dow);
} elsif ($plug eq "north") {
    $plug_day = second_tue($dow);
} elsif ($plug eq "west") {
    $plug_day = third_mon($dow);
} else {
    usage();
}

printf "%4d-%02d-%02d\n", $yyyy, $mm, $plug_day;

sub usage() {
    say "plug_date central|north|west YYYY MM";
    exit;
}

sub first_dow($dow, $first_dow) {
    ($dow - $first_dow) % 7 + 1;
}

sub first_wed($first_dow) {
    return first_dow(3, $first_dow);
}

sub second_tue($first_dow) {
    return first_dow(2, $first_dow) + 7;
}

sub third_mon($first_dow) {
    return return first_dow(1, $first_dow) + 14;
}
