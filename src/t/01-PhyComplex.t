use Test::More;
use lib '../lib';
use Complexity::Physical;

plan tests => 2;

my $output1 = 3;
my $output2 = 7;



my $array1 = [['-','A','B','C','H','-','I','I','-'],
              ['-','A','C','C','S','-','-','I','-'],
              ['-','-','C','C','A','-','O','I','-']];

my $array2 = [['A','A','C','C','A','-','I','I','-'],
              ['A','A','C','C','A','-','I','I','-'],
              ['A','A','C','C','A','-','I','I','-']];



my $PS = Complexity::Physical->new();

my $ps1 = int($PS->PhyComplexCompute(queryid => 0, aligned => $array1 ));
my $ps2 = $PS->PhyComplexCompute(queryid => 0, aligned => $array2 );

ok( $output1 == $ps1, "Min");
ok( $output2 == $ps2, "Max");

done_testing;
