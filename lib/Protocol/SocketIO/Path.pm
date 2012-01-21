package Protocol::SocketIO::Path;

use strict;
use warnings;

sub new {
    my $class = shift;

    my $self = bless {@_}, $class;

    $self->{transports}
      ||= [qw/websocket flashsocket htmlfile xhr-polling jsonp-polling/];

    return $self;
}

sub parse {
    my $self = shift;
    my ($path) = @_;

    $path =~ s{^/}{};
    $path =~ s{^$}{};

    my ($protocol_version, $transport_type, $session_id) = split '/',
      $path, 3;
    return unless $protocol_version && $protocol_version =~ m/^\d+$/;

    return
      unless ($transport_type && $session_id)
      || (!$transport_type && !$session_id);

    if ($transport_type) {
        return unless grep { $transport_type eq $_ } @{$self->{transports}};
    }

    $self->{protocol_version} = $protocol_version;
    $self->{transport_type}   = $transport_type;
    $self->{session_id}       = $session_id;

    return $self;
}

sub protocol_version {
    my $self = shift;

    return $self->{protocol_version};
}

sub is_handshake {
    my $self = shift;

    return 0
      if defined $self->{transport_type} && defined $self->{session_id};

    return 1;
}

sub session_id {
    my $self = shift;

    return $self->{session_id};
}

sub transport_type {
    my $self = shift;

    return $self->{transport_type};
}

1;
