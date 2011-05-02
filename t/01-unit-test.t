#!perl

use strict; use warnings;
use WWW::Google::Diacritize;
use Test::More tests => 1;

eval { my $diacritize = WWW::Google::Diacritize->new(); };
like($@, qr/ERROR: API Key is missing./);