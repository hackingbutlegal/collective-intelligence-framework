package CIF::Archive::Storage::Plugin::Iodef::ShareWith;

use Regexp::Common qw/net/;

sub prepare {
    my $class   = shift;
    my $info    = shift;
    return unless($info->{'sharewith'});
    return(1);
}

sub convert {
    my $class = shift;
    my $info = shift;
    my $iodef = shift;

    my @share;
    if(ref($info->{'sharewith'}) eq 'ARRAY'){
        @share = @{$info->{'sharewith'}};
    } else {
        push(@share,$info->{'sharewith'});
    }

    foreach(@share){
        $iodef->add('IncidentAdditionalDatadtype','string');
        $iodef->add('IncidentAdditionalDatameaning','sharewith');
        $iodef->add('IncidentAdditionalData',$_);
    }


    return($iodef);
}

1;
