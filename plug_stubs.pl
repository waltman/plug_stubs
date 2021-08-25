#!/usr/bin/env perl

# Print out the stubs for one month of PLUG meetings
#
# Example:
#
# <tr class="central">
#   <td><a name="c20191002" />PLUG Central</td>
#   <td class="date">10/2/2019</td>
#   <td class="tbd">To be determined</td>
#   <td class="tbd">To be determined</td>
#   <td><a href="locations/usp.html">USP</a></td>
# </tr>

# <tr class="north">
#   <td><a name="n20191008" />PLUG North</td>
#   <td class="date">10/8/2019</td>
#   <td class="tbd">To be determined</td>
#   <td class="tbd">To be determined</td>
#   <td><a href="locations/coredial.html">Coredial, Blue Bell</a></td>
# </tr>

# <tr class="west">
#   <td><a name="w20191021" />PLUG West</td>
#   <td class="date">10/21/2019</td>
#   <td class="tbd">To be determined</td>
#   <td class="tbd">To be determined</td>
#   <td><a href="locations/ats.html">ATS</a></td>
# </tr>


use strict;
use warnings;
use feature qw(:5.30);
use experimental qw(signatures);

use DateTime;
use Getopt::Long;

my $online;
my $yyyy;
my $mm;
GetOptions("year=i"  => \$yyyy,
           "month=i" => \$mm,
           "online"  => \$online);
usage() unless ($yyyy && $mm);

my $dt = DateTime->new(
                       year  => $yyyy,
                       month => $mm,
                       day   => 1,
                      );
my $dow = $dt->day_of_week;
my $central = first_wed($dow);
my $north = second_tue($dow);

my $central_tag = sprintf "c%4d%02d%02d", $yyyy, $mm, $central;
my $central_date = sprintf "%d/%d/%d", $mm, $central, $yyyy;
my $north_tag = sprintf "n%4d%02d%02d", $yyyy, $mm, $north;
my $north_date = sprintf "%d/%d/%d", $mm, $north, $yyyy;

my ($central_loc, $north_loc);
if ($online) {
    my $url_stub = 'https://meet.jit.si/PLUG%s%s%d';
    my $central_url = sprintf $url_stub, 'Central', $dt->month_name, $dt->year;
    my $north_url   = sprintf $url_stub, 'North', $dt->month_name, $dt->year;
    $central_loc = "<a href='$central_url'>$central_url";
    $north_loc   = "<a href='$north_url'>$north_url";
} else {
    $central_loc = '<a href="locations/usp.html">USP</a>';
    $north_loc   = '<a href="locations/coredial.html">Coredial, Blue Bell</a>';
}

print <<EOT;
<tr class="central">
  <td><a name="$central_tag" />PLUG Central</td>
  <td class="date">$central_date</td>
  <td class="tbd">To be determined</td>
  <td class="tbd">To be determined</td>
  <td>$central_loc</td>
</tr>

<tr class="north">
  <td><a name="$north_tag" />PLUG North</td>
  <td class="date">$north_date</td>
  <td class="tbd">To be determined</td>
  <td class="tbd">To be determined</td>
  <td>$north_loc</td>
</tr>

EOT

sub usage() {
    say "plug_stubs [--online] --year=YYYY --month=MM";
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
