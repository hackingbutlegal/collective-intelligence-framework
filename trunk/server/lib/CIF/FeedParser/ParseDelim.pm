package CIF::FeedParser::ParseDelim;

use strict;
use warnings;

sub parse {
    my $f = shift;
    my $content = shift;
    my $split = shift;

    my @lines = split(/\n/,$content);
    my @cols = split(',',$f->{'values'});
    my @array;
    if(my $l = $f->{'feed_limit'}){
        my ($start,$end);
        if(ref($l) eq 'ARRAY'){
            ($start,$end) = @{$l};
        } else {
            ($start,$end) = (0,$l-1);
        }
        @lines = @lines[$start..$end];
    }
    foreach(@lines){
        next if(/^(#|$|<)/);
        my @m = split($split,$_);
        my $h;
        foreach (0 ... $#cols){
            $h->{$cols[$_]} = $m[$_];
        }
        map { $h->{$_} = $f->{$_} } keys %$f;
        push(@array,$h);
    }
    return(\@array);
}

1;
