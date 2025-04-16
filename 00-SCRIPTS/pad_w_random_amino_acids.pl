#!/usr/bin/perl

use strict;
use warnings;
use JFR::Fasta;
use List::Util qw(shuffle);

srand 420;  # set random seed

our $FILE5 = 'HoxPHox.5PRIME.fa';
our $FILE3 = 'HoxPHox.3PRIME.fa';
our @AA = qw(A R M D C Q E G H I L K M F P S T W Y V);
our $NUM   = 20;

MAIN: {
    pad_w_random($FILE5);
    pad_w_random($FILE3);
}

sub pad_w_random {
    my $file = shift;
    my $out  = "$file.padded_w_random_aa";
    my $fp = JFR::Fasta->new($file);
    open OUT, ">$out" or die "cannot open $out:$!";

    while (my $rec = $fp->get_record()) {
        print OUT "$rec->{'def'}\n";
        my @letters = split /|/, $rec->{'seq'};
        for (my $i = 0; $i < $NUM; $i++) {
            my $aa = $letters[$i] || '';
            unless ($letters[$i]) {
                my @rand = List::Util::shuffle(@AA);
                $aa = $rand[0];
            }
            print OUT $aa;
        }
        print OUT "\n";
    }
}
