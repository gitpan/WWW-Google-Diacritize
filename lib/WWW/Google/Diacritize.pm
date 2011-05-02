package WWW::Google::Diacritize;

use strict; use warnings;

use Carp;
use Readonly;
use Data::Dumper;
use URI::Escape qw/uri_escape/;
use LWP::UserAgent;
use HTTP::Request::Common;

=head1 NAME

WWW::Google::Diacritize - Interface to Google Diacritize API.

=head1 VERSION

Version 0.01

=cut

our $VERSION = '0.01';
Readonly my $API_VERSION => 'v1';
Readonly my $LANGUAGES   => ['ar'];
Readonly my $BASE_URL    => "https://www.googleapis.com/language/diacritize/$API_VERSION";
Readonly my $DEFAULT_PRETTYPRINT => 'false';
Readonly my $DEFAULT_LAST_LETTER => 'true';

=head1 DESCRIPTION

This module is  intended for anyone who wants to write applications that can interact with the
Google Diacritize API. With this, you can add diacritical marks to text in your webpages /app.
The process of diacritizing is also called "Tashkeel".
Just to clarify, Arabic is not my first language. However I can read it as it's written in the
our holy book "Quran". I don't claim to understand the intricacies of the languge.

NOTE: The  version  v1  of the Google Diacritize API is in Labs, and its features might change
unexpectedly until it graduates.

=head1 CONSTRUCTOR

The constructor expects your application API, which you can get it for FREE from Google.

    use strict; use warnings;
    use WWW::Google::Diacritize;

    my $api_key = 'Your_API_Key';
    my $diacritize = WWW::Google::Diacritize->new($api_key);

=cut

sub new
{
    my $class   = shift;
    my $api_key = shift;
    croak("ERROR: API Key is missing.\n")
        unless defined $api_key;

    my $self = { api_key => $api_key,
                 browser => LWP::UserAgent->new()
               };
    bless $self, $class;
    return $self;
}
=head1 METHODS

=head2 set_diacritical_marks()

Sets the diacritical marks to the given text  in the given language. Arabic  is currently ONLY
the supported language. Returns data in JSON format.

    +-------------+-----------------------------------------------+------------+---------+
    | Key         | Description                                   | Values     | Default |
    +-------------+-----------------------------------------------+------------+---------+
    | lang        | Set the language.                             | ar         | N/A     |
    | message     | Text string to return with diacritical marks. |            | N/A     |
    | last_letter | Diacritize last letter.                       | true/false | true    |
    | prettyprint | Returns result in human readable format.      | true/false | false   |
    +-------------+-----------------------------------------------+------------+---------+

=cut

sub set_diacritical_marks
{
    my $self  = shift;
    my $param = shift;
    _validate_param($param);

    $param->{prettyprint} = $DEFAULT_PRETTYPRINT
        unless exists($param->{prettyprint});
    $param->{last_letter} = $DEFAULT_LAST_LETTER
        unless exists($param->{last_letter});
    my $url = sprintf("%s?key=%s", $BASE_URL, $self->{api_key});
    $url .= sprintf("&lang=%s", $param->{lang});
    $url .= sprintf("&message=%s", $param->{message});
    $url .= sprintf("&prettyprint=%s", $param->{prettyprint})
        if exists($param->{prettyprint});
    $url .= sprintf("&last_letter=%s", $param->{last_letter})
        if exists($param->{last_letter});
    my $request  = HTTP::Request->new(GET => $url);
    my $response = $self->{browser}->request($request);
    croak("ERROR: Could not connect to $url [".$response->status_line."].\n")
        unless $response->is_success;

    return $response->content;
}

sub _validate_param
{
    my $param = shift;
    croak("ERROR: Missing input parameters.\n")
        unless defined $param;
    croak("ERROR: Input param has to be a ref to HASH.\n")
        if (ref($param) ne 'HASH');
    croak("ERROR: Missing key 'lang' in the param list.")
        unless exists($param->{'lang'});
    croak("ERROR: Missing key 'message' in the param list.")
        unless exists($param->{'message'});
    croak("ERROR: Invalid value for key 'lang': [".$param->{'lang'}."].\n")
        unless (grep/$param->{'lang'}/i, @$LANGUAGES);
    my $count = 2;
    croak("ERROR: Invalid value for key 'last_letter': [".$param->{last_letter}."].\n")
        if (defined($param->{last_letter}) && ($param->{last_letter} !~ /\btrue\b|\bfalse\b/i));
    croak("ERROR: Invalid value for key 'prettyprint': [".$param->{prettyprint}."].\n")
        if (defined($param->{prettyprint}) && ($param->{prettyprint} !~ /\btrue\b|\bfalse\b/i));
    $count++ if defined($param->{last_letter});
    $count++ if defined($param->{prettyprint});
    croak("ERROR: Invalid number of keys found in the input hash.\n")
        unless (scalar(keys %{$param}) == $count);
}

=head1 AUTHOR

Mohammad S Anwar, C<< <mohammad.anwar at yahoo.com> >>

=head1 BUGS

Please report any bugs or feature requests to C<bug-www-google-diacritize at rt.cpan.org>,  or
through the web interface at L<http://rt.cpan.org/NoAuth/ReportBug.html?Queue=WWW-Google-Diacritize>.
I will be notified and then you'll automatically be notified of progress on your bug as I make
changes.

=head1 SUPPORT

You can find documentation for this module with the perldoc command.

    perldoc WWW::Google::Diacritize

You can also look for information at:

=over 4

=item * RT: CPAN's request tracker

L<http://rt.cpan.org/NoAuth/Bugs.html?Dist=WWW-Google-Diacritize>

=item * AnnoCPAN: Annotated CPAN documentation

L<http://annocpan.org/dist/WWW-Google-Diacritize>

=item * CPAN Ratings

L<http://cpanratings.perl.org/d/WWW-Google-Diacritize>

=item * Search CPAN

L<http://search.cpan.org/dist/WWW-Google-Diacritize/>

=back

=head1 LICENSE AND COPYRIGHT

Copyright 2011 Mohammad S Anwar.

This  program  is  free  software; you can redistribute it and/or modify it under the terms of
either:  the  GNU  General Public License as published by the Free Software Foundation; or the
Artistic License.

See http://dev.perl.org/licenses/ for more information.

By  using  the  Google Diacritize API, you agree to  the  Google Buzz API Terms of Service and
agree to abide by the Google Diacritize Developer Policies.

http://code.google.com/apis/diacritize/terms.html
http://code.google.com/apis/diacritize/policies.html

=head1 DISCLAIMER

This  program  is  distributed  in  the hope that it will be useful, but WITHOUT ANY WARRANTY;
without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.

=cut

1; # End of WWW::Google::Diacritize