#!/usr/bin/perl -w

use strict;

#
# Parse MPASM include files to extract SDCC header/device library files
# This script is (c) 2007 by Raphael Neider <rneider AT web.de>,
# it is licensed under the terms of the GPL v2.
#
# Usage: perl inc2h-pic16.pl /path/to/pDEVICE.inc
# where pDEVICE.inc might be contained in a gputils(.sf.net) package.
#
# Steps to add a new target device to SDCC/PIC16:
#
# 1. Create picDEVICE.c and picDEVICE.h from pDEVICE.inc using
#    perl inc2h-pic16.pl /path/to/pDEVICE.inc
# 2. mv picDEVICE.h $SDCC/device/include/pic16
# 3. mv picDEVICE.c $SDCC/device/lib/pic16/libdev
# 4. add DEVICE to $SDCC/device/lib/pic16/pics.all (and .build)
# 5. either
#    (a) adjust $SDCC/device/lib/pic16/libio/*.ignore
#        if the device does not support ADC, I2C, or USART
#        OR
#    (b) adjust $SDCC/device/include/pic16/adc.h
#        adding the new device to the correct ADC style class
# 6. edit $SDCC/device/include/pic16/pic18fregs.h
# 7. edit $SDCC/device/include/pic16/pic16devices.txt
#
# The file format of steps 6 and 7 is self explanatory, in most
# if not all cases you can copy and paste another device's records
# and adjust them to the newly added device.
#
# Please try to add device families (with a common datasheet) rather
# than a single device and use the .h and .c files of the largest
# device for all (using #include "largest.c" and #include "largest.h").
#

my $SCRIPT = $0;
$SCRIPT =~ s/.*\///g; # remove path prefix

sub max
{
    my ($a,$b) = @_;
    if ($a < $b) { return $b; }
    else { return $a; }
}

sub LOG
{
    foreach my $i (@_) {
      print $i;
    }
}

sub setup
{
    my ($proc) = @_;
    $proc = lc ($proc);
    $proc =~ s,^pic,,;
    $proc =~ s,^p,,;
    my $header = "pic${proc}.h";
    my $library = "pic${proc}.c";
    open (HEADER, '>', "$header") or die "Could not open header file $header: $!";
    open (LIBRARY, '>', "$library") or die "Could not open library file $library: $!.";


    $proc = uc($proc);

    print HEADER <<"HEREDOC"
/*
 * $header - device specific declarations
 *
 * This file is part of the GNU PIC library for SDCC,
 * originally devised by Vangelis Rokas <vrokas AT otenet.gr>
 *
 * It has been automatically generated by $SCRIPT,
 * (c) 2007 by Raphael Neider <rneider AT web.de>
 */

#ifndef __PIC${proc}_H__
#define __PIC${proc}_H__ 1

HEREDOC
;

    print LIBRARY <<"HEREDOC"
/*
 * $library - device specific definitions
 *
 * This file is part of the GNU PIC library for SDCC,
 * originally devised by Vangelis Rokas <vrokas AT otenet.gr>
 *
 * It has been automatically generated by $SCRIPT,
 * (c) 2007 by Raphael Neider <rneider AT web.de>
 */

#include <$header>

HEREDOC
;
}

sub release
{
    print HEADER <<HEREDOC

#endif

HEREDOC
;

    print LIBRARY <<HEREDOC

HEREDOC
;
    close HEADER;
    close LIBRARY;
}

sub header
{
    my $i;
    foreach $i (@_) {
	print HEADER $i;
	#print $i;
    }
}

sub library
{
    my $i;
    foreach $i (@_) {
	print LIBRARY $i;
	#print $i;
    }
}

sub DEFINE
{
    my ($name, $val, $comment) = @_;
    header (sprintf("#define\t%-20s\t%s", $name, $val));
    if (defined $comment) { header ("\t // $comment"); }
    header "\n";
}

#######################
# main
#######################

my $state = 0;
my $sfrs = {};
my ($processor, $name);

while (<>) {
    # extract processor type
    chomp;
    s/\s+/ /g;
    next if (/^\s*$/);

    if (/IFNDEF _*(18.*[0-9]+)/i) {
	$processor = lc($1);
	#LOG "Found processor: $processor.\n";
	setup($processor);
	next;
    }

    # extract SFR declarations
    if (/;--.*Register Files.*--/i) {
	$state = 1;
    }
    if ($state == 1 and /(\w+) EQU H'([0-9a-f]+)/i) {
	my $addr = oct("0x" . $2);
	$name = uc ($1);
	$sfrs->{"$name"} = { "addr" => $addr,
	    "maxnames" => 0,
	    "bit0" => [],
	    "bit1" => [],
	    "bit2" => [],
	    "bit3" => [],
	    "bit4" => [],
	    "bit5" => [],
	    "bit6" => [],
	    "bit7" => [],
	};

	#LOG sprintf("Found register definition: $name @ 0x%X.\n", $addr);
	next;
    } elsif ($state == 1 and /(\w+) EQU ([0-9]+)/i) {
	my $addr = 0+$2;
	$name = uc ($1);
	$sfrs->{"$name"} = { "addr" => $addr,
	    "maxnames" => 0,
	    "bit0" => [],
	    "bit1" => [],
	    "bit2" => [],
	    "bit3" => [],
	    "bit4" => [],
	    "bit5" => [],
	    "bit6" => [],
	    "bit7" => [],
	};

	#LOG sprintf("Found register definition: $name @ 0x%X.\n", $addr);
	next;
    }

    # extract device id positions
    if (/(_DEVID[0-9a-f]*) EQU H'([0-9a-f]+)/i) {
	my $addr = oct("0x" . $2);
	#LOG sprintf("Found device ID $1 at 0x%X.\n", $addr);
	if ($state != 6) {
	    #print "\n// device IDs\n";
	    $state = 6;
	}
	DEFINE ($1, sprintf ("0x%X", $addr));
	next;
    }

    if (/(_IDLOC[0-9a-f]*) EQU H'([90-9a-f]+)/i) {
	my $addr = oct("0x" . $2);
	#LOG sprintf("Found ID location: $1 at 0x%X.\n", $addr);
	if ($state != 5) {
	    #print "\n// ID locations\n";
	    $state = 5;
	}
	DEFINE ($1, sprintf ("0x%X", $addr));
	next;
    }

    # extract configuration bits
    if (/Configuration Bits/i) {
	$state = 3;
	#print "\n\n// Configuration Bits\n";
	header "\n\n// Configuration Bits\n";
	next;
    }

    if ($state == 3 and /(_\w+) EQU H'([0-9a-f]+)/i) {
	$name = $1;
	my $addr = oct("0x" . $2);
	# convert to double underscore form for SDCC internal consistency
	$name =~ s/^_//g;
	$name = "__".$name;
	#LOG sprintf("Found config word $1 at 0x%X.\n", $addr);
	DEFINE ($name, sprintf ("0x%X", $addr));
	next;
    }

    if (($state == 3 or $state == 4) and /;--+ ((\w+) Options) --/i) {
	$name = uc($2);
	$state = 4;
	#print "\n// $1\n";
	header "\n// $1\n";
	next;
    }
    if ($state == 4 and /(\w+) EQU H'([0-9a-f]+)(.*)/i) {
	my $option = $1;
	my $mask = oct ("0x" . $2);
	my $comment = $3;
	if ($comment =~ /[^;]*;\s*(.*)$/) {
	    $comment = $1;
	}
	#LOG sprintf ("Found config option $option, mask 0x%X in $name; comment: $comment.\n", $mask);
	DEFINE ($option, sprintf("0x%X", $mask), $comment);
	next;
    }

    # extract bit definitions
    if (/;\s*-+\s*(\w+)\s*(Bits)?\s*-+/i) {
	$state = 2;
	$name = uc ($1);
	next;
    }
    if ($state == 2 and /(\w+) EQU H'([0-9a-f]+)/i) {
	my $bit = oct("0x" . $2);
	#LOG "Found bit declaration: $1 as bit $bit in reg $name.\n";
	push @{$sfrs->{"$name"}->{"bit$bit"}}, $1;
	$sfrs->{"$name"}->{"maxnames"} = max(
	    scalar @{$sfrs->{"$name"}->{"bit$bit"}},
	    $sfrs->{"$name"}->{"maxnames"}
	);
	next;
    } elsif ($state == 2 and /(\w+) EQU ([0-9]+)/i) {
	#print "@@@@ FOUND $1 $2 for $name\n";
	my $bit = 0+$2;
	#LOG "Found bit declaration: $1 as bit $bit in reg $name.\n";
	push @{$sfrs->{"$name"}->{"bit$bit"}}, $1;
	$sfrs->{"$name"}->{"maxnames"} = max(
	    scalar @{$sfrs->{"$name"}->{"bit$bit"}},
	    $sfrs->{"$name"}->{"maxnames"}
	);
	next;
    }

    # unknown/unhandled line
    #print "// $_\n";
}

header "\n";
library "\n";
my $namelut = {};
foreach my $reg (keys %$sfrs) {
    if (!defined $namelut->{$sfrs->{"$reg"}->{"addr"}}) {
	$namelut->{$sfrs->{"$reg"}->{"addr"}} = ();
    }
    push @{$namelut->{$sfrs->{"$reg"}->{"addr"}}}, $reg;
}

foreach my $idx (sort keys %$namelut) {
    foreach my $reg (sort @{$namelut->{$idx}}) {
	my $names = $sfrs->{"$reg"}->{"maxnames"};

	header sprintf ("extern __sfr __at (0x%03X) %s;\n", $idx, $reg);
	library sprintf (      "__sfr __at (0x%03X) %s;\n", $idx, $reg);

	#print sprintf ("$reg @ %X (<= %d bit names)\n", $sfrs->{"$reg"}->{"addr"}, $names);
	if ($names > 0) {
	    header sprintf ("typedef union {\n");

	    for (my $j=0; $j < $names; $j++) {
		header sprintf ("\tstruct {\n");
		for (my $bit=0; $bit < 8; $bit++) {
		    my $bitname = $sfrs->{"$reg"}->{"bit$bit"}->[$j];
		    if (defined $bitname) {
			header sprintf ("\t\tunsigned %-10s\t: 1;\n", $bitname);
		    } else {
			header sprintf ("\t\tunsigned %-10s\t: 1;\n", "");
		    }
		}
		header sprintf ("\t};\n");
	    }

	    header sprintf ("} __${reg}bits_t;\n");
	    header sprintf ("extern volatile __${reg}bits_t __at (0x%03X) ${reg}bits;\n", $idx);
	    library sprintf (      "volatile __${reg}bits_t __at (0x%03X) ${reg}bits;\n", $idx);
	}

	header "\n";
	library "\n";
    }
}

release;
