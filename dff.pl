#!/usr/bin/perl -w

######################################################################################
#
# (c) 2013 - Francesc Guasch Ortiz
#
#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see <http://www.gnu.org/licenses/>.
## 

use warnings;
use strict;

use Getopt::Long;
use IPC::Run qw(run timeout);

my $VERSION = "0.02";
# 0.01 : Works
# 0.02 : --real and --length args

my $LENGTH_DEV = 18;
my ($NO_TRIM, $HELP, $EXPORT);

GetOptions(        help => \$HELP
                  ,real => \$NO_TRIM
                ,export => \$EXPORT
            ,'length=s' => \$LENGTH_DEV
);
if ($HELP) {
    print "$0 [--help] [--export] [--real] [--length=$LENGTH_DEV]\n";
    exit;
}

###########################################################################

sub trim {
    my $dev = shift;
    return $dev if $NO_TRIM ;

	$dev .= " " x (32-length($dev));
	$dev =~ s!.*(uuid/.*)!$1!;
	$dev =~ s!.*(mapper/).*?-(.)!$1$2!;
    $dev =~ s!(.*?:).*/(.*)!$1$2!;
	$dev = substr("$dev     ",0,$LENGTH_DEV);

    return $dev;

}
###################################################################

my ($in,$out,$err) = ();

$ENV{LANG}='C';
push @ARGV,('-h')   if !$NO_TRIM;

my @cmd = ('df',@ARGV);

run \@cmd,\$in,\$out,\$err, timeout(10) or die $err;

if ($NO_TRIM) {
    print $out;
    exit;
}

my @length;
my @out;
for (split m{\n},$out) {
	my @items = split ;
    next if $items[-1] =~ m{^/export/};

	$items[0] = trim($items[0]);

	for my $n (0..$#items) {
		my $length = length($items[$n]);
		$length[$n] = $length if !$length[$n] || $length > $length[$n];
	}
	push @out,\@items;
}

for my $line (@out) {
	my @items = @$line;
	for my $n (1..$#items-1) {
		my $length = 1+$length[$n] - length($items[$n]);
		$items[$n]= (" " x $length).$items[$n];
	}
	if ($items[0] =~ /Filesystem/) {
		$items[$#items-1] = "Mounted on";
		$#items--;
	}
	print join(" ",@items)."\n";
}

warn $err if $err;
