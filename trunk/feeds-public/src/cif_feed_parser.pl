#!/usr/bin/perl -w

use strict;
use Getopt::Std;
use CIF::FeedParser;
use Config::Simple;
use Data::Dumper;
use Net::DNS::Resolver;

my %opts;
getopts('t:dFc:f:',\%opts);
my $debug = $opts{'d'};
my $full_load = $opts{'F'} || 0;
my $config = $opts{'c'} || $ENV{'HOME'}.'/.cif';
my $f = $opts{'f'} || die('missing feed');
my $c = Config::Simple->new($config) || die($!.' '.$config);
my $default = $c->param(-block => 'default');
my $hash = $c->param(-block => $f);
unless(keys %$hash){
    die('section doesn\'t exist: '.$f);
}

foreach my $h (keys %$hash){
    $default->{$h} = $hash->{$h};
}

$c = $default;
my $threaded = $opts{'t'} || $c->{'threads_count'};
$c->{'threads_count'} = $threaded if($threaded);

my $nsres;
unless($full_load){
    $c->{nsres} = Net::DNS::Resolver->new(recursive => 0);
}

my @items = CIF::FeedParser::parse($c);

if($threaded){
    CIF::FeedParser::t_insert($full_load,@items);
} else {
    CIF::FeedParser::insert($full_load,@items);
}
