package Net::GitHub::V2::Role;

use Moose::Role;

our $VERSION = '0.06';
our $AUTHORITY = 'cpan:FAYLAND';

use JSON::Any;
use WWW::Mechanize::GZip;
use Carp qw/croak/;

# login
has 'login'  => ( is => 'rw', isa => 'Str', default => '' );
has 'token' => ( is => 'rw', isa => 'Str', default => '' );

# api
has 'api_url' => ( is => 'ro', default => 'http://github.com/api/v2/json/');

has 'ua' => (
    isa     => 'WWW::Mechanize',
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        my $m    = WWW::Mechanize::GZip->new(
			agent       => "perl-net-github $VERSION",
            cookie_jar  => {},
            stack_depth => 1,
            timeout     => 60,
        );
        return $m;
    },
);

sub get {
    my $self = shift;
    
    my $resp = $self->ua->get(@_);
    unless ( $resp->is_success ) {
        croak $resp->as_string();
    }
    return $resp->content();
}


has 'json' => (
    is => 'ro',
    isa => 'JSON::Any',
    lazy => 1,
    default => sub {
        return JSON::Any->new;
    }
);


no Moose::Role;

1;
__END__

=head1 NAME

Net::GitHub::Role - Common between Net::GitHub::* libs

=head1 SYNOPSIS

    package Net::GitHub::XXX;
    
    use Moose;
    with 'Net::GitHub::Role';

=head1 DESCRIPTION

=head1 ATTRIBUTES

=over 4

=item login

=item token

=back

=head1 METHODS

=over 4

=item ua

instance of L<WWW::Mechanize>

=item json

instance of L<JSON::Any>

=item get

handled by L<WWW::Mechanize>

=back

=head1 AUTHOR

Fayland Lam, C<< <fayland at gmail.com> >>

=head1 COPYRIGHT & LICENSE

Copyright 2009 Fayland Lam, all rights reserved.

This program is free software; you can redistribute it and/or modify it
under the same terms as Perl itself.