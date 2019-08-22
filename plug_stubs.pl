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

usage() unless @ARGV == 2;
my ($yyyy, $mm) = @ARGV;
my $dt = DateTime->new(
                       year  => $yyyy,
                       month => $mm,
                       day   => 1,
                      );
my $dow = $dt->day_of_week;
my $central = first_wed($dow);
my $north = second_tue($dow);
my $west = third_mon($dow);

my $central_tag = sprintf "c%4d%02d%02d", $yyyy, $mm, $central;
my $central_date = sprintf "%d/%d/%d", $mm, $central, $yyyy;
my $north_tag = sprintf "n%4d%02d%02d", $yyyy, $mm, $north;
my $north_date = sprintf "%d/%d/%d", $mm, $north, $yyyy;
my $west_tag = sprintf "w%4d%02d%02d", $yyyy, $mm, $west;
my $west_date = sprintf "%d/%d/%d", $mm, $west, $yyyy;

print <<EOT;
<tr class="central">
  <td><a name="$central_tag" />PLUG Central</td>
  <td class="date">$central_date</td>
  <td class="tbd">To be determined</td>
  <td class="tbd">To be determined</td>
  <td><a href="locations/usp.html">USP</a></td>
</tr>

<tr class="north">
  <td><a name="$north_tag" />PLUG North</td>
  <td class="date">$north_date</td>
  <td class="tbd">To be determined</td>
  <td class="tbd">To be determined</td>
  <td><a href="locations/coredial.html">Coredial, Blue Bell</a></td>
</tr>

<tr class="west">
  <td><a name="$west_tag" />PLUG West</td>
  <td class="date">$west_date</td>
  <td class="tbd">To be determined</td>
  <td class="tbd">To be determined</td>
  <td><a href="locations/ats.html">ATS</a></td>
</tr>
EOT

sub usage() {
    say "plug_stubs YYYY MM";
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
