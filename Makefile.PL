use ExtUtils::MakeMaker;

mkdir "./lib";
mkdir "./lib/Complexity";
mkdir "./t/";
system("cp src/lib/Complexity/* ./lib/Complexity");
system("cp  src/t/* ./t/");
system("cp  src/apps/* ./bin/");


WriteMakefile(
	NAME		=> 'PhyComplexity',
	AUTHOR   => q{Robert Bakaric <rbakaric@exaltum.eu>},
	LICENSE  => 'GNU GENERAL PUBLIC LICENSE Version 3',
	ABSTRACT => 'Simple Sequence Complexity Calculator',
	VERSION	=> '0.01',

	dist		=> { 'COMPRESS' => 'gzip' },
	PREREQ_PM => {
        "Getopt::Long" => 0,
        "File::Slurp" => 0,
    },
    META_ADD => {
        provides => {
            'Complexity::Physical' => {
               file => 'Physical.pm',
               version => '0.01',
            },
        },
    },
);



