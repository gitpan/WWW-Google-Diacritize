#!perl

use strict; use warnings;
use WWW::Google::Diacritize;
use Test::More tests => 8;

my $api_key = 'AIzaSyAe7Flr-9rBq-9Aqi84P9QYM8NsR4wSi1M';
my $diacritize = WWW::Google::Diacritize->new($api_key);

eval { $diacritize->set_diacritical_marks(); };
like($@, qr/ERROR: Missing input parameters./);

eval { $diacritize->set_diacritical_marks(lang => 'ar'); };
like($@, qr/ERROR: Input param has to be a ref to HASH./);

eval { $diacritize->set_diacritical_marks({lagn => 'ar'}); };
like($@, qr/ERROR: Missing key 'lang' in the param list./);

eval { $diacritize->set_diacritical_marks({
        lang   => 'ar',
        mssage => 'مثال لتشكيل'}); };
like($@, qr/ERROR: Missing key 'message' in the param list./);

eval { $diacritize->set_diacritical_marks({
        lang    => 'en',
        message => 'مثال لتشكيل'}); };
like($@, qr/ERROR: Invalid value for key 'lang': \[en\]./);

eval { $diacritize->set_diacritical_marks({
        last_letter => 'google',
        lang        => 'ar',
        message     => 'مثال لتشكيل'}); };
like($@, qr/ERROR: Invalid value for key 'last_letter': \[google\]./);

eval { $diacritize->set_diacritical_marks({
        prettyprint => 'google',
        lang        => 'ar',
        message     => 'مثال لتشكيل'}); };
like($@, qr/ERROR: Invalid value for key 'prettyprint': \[google\]./);

eval { $diacritize->set_diacritical_marks({
        txt     => 'abc',
        lang    => 'ar',
        message => 'مثال لتشكيل'}); };
like($@, qr/ERROR: Invalid number of keys found in the input hash./);