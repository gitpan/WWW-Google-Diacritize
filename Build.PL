use strict;use warnings;
use Module::Build;

my $builder = Module::Build->new(
    sign              => 1,
    add_to_cleanup    => [ 'WWW-Google-Diacritize-*' ],
    module_name       => 'WWW::Google::Diacritize',
    license           => 'perl',
    dist_author       => q{Mohammad S Anwar <mohammad.anwar@yahoo.com>},
    dist_version_from => 'lib/WWW/Google/Diacritize.pm',
    build_requires    => {
        'Test::More'     => 0,
        'Readonly'       => '1.03',
        'JSON'           => '2.15',
        'URI::Escape'    => '3.29',
        'HTTP::Request'  => '1.40',
        'LWP::UserAgent' => '2.33',
    },
);

$builder->create_build_script();