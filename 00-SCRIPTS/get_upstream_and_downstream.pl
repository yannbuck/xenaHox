#!/usr/bin/perl

use strict;
use warnings;
use JFR::Fasta;
use Data::Dumper;

our $FASTA = 'HoxPHox_LONGORF.fa';
our $CSV   = 'xena_HOXL_IDLIST.csv';
our $UPSTREAM = 20;
our $HDLEN    = 60;
our $DNSTREAM = 20;
our $PREFIX   = 'HoxPHox';

MAIN: {
    my $rh_c = get_coords($CSV);
    my $rh_s = get_seqs($FASTA);
    get_up_down($rh_c,$rh_s);
}

sub get_up_down {
    my $rh_c = shift;
    my $rh_s = shift;

    open OUT5, ">$PREFIX.5PRIME.fa" or die "cannot open >$PREFIX.5PRIME.fa:$!";
    open OUTH, ">$PREFIX.HD.fa" or die "cannot open >$PREFIX.HD.fa:$!";
    open OUT3, ">$PREFIX.3PRIME.fa" or die "cannot open >$PREFIX.3PRIME.fa:$!";

    foreach my $id (keys %{$rh_c}) {
        die "$id from $CSV has no entry in $FASTA" unless ($rh_s->{$id});
        my $start_5p = $rh_c->{$id} - $UPSTREAM;
        my $start_3p = $rh_c->{$id} + $HDLEN;
        my $hd = substr $rh_s->{$id}, ($rh_c->{$id} - 1), $HDLEN;
        print OUTH ">$id\n$hd\n";
        if ($start_5p > 0) {
            my $hd5 = substr $rh_s->{$id}, ($start_5p - 1), $UPSTREAM;
            print OUT5 ">$id\n$hd5\n";
        }
        my $length_needed = $start_3p + $DNSTREAM;
        my $length = length $rh_s->{$id};
        if ($length_needed <= $length) {
            my $hd3 = substr $rh_s->{$id}, ($start_3p - 1), $DNSTREAM;
            print OUT3 ">$id\n$hd3\n";
        }
    }
}

sub get_seqs {
    my $file = shift;
    my %seqs = ();
    my $fp   = JFR::Fasta->new($file);
    while (my $rec = $fp->get_record()) {
        my $id = JFR::Fasta->get_def_w_o_gt($rec->{'def'});
        $seqs{$id} = $rec->{'seq'};
    }
    return \%seqs;
}

sub get_coords {
    my $file = shift;
    my %coords = ();
    open IN, $file or die "cannot open $file:$!";
    while (my $line = <IN>) {
        chomp $line;
        $line =~ m/^"([^"]+)"/ or die "unexpected line format: $line\n";
        my $str = $1;
        my @fields = split /,/, $str;
        $coords{$fields[0]} = $fields[1];
    }
    return \%coords;
}
