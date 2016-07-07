#!/usr/bin/perl 
#  PhyComplex.pl
#  
#  Copyright 2015 Robert Bakaric <rbakaric@exaltum.eu>
#  
#  This program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 2 of the License, or
#  (at your option) any later version.
#  
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#  
#  You should have received a copy of the GNU General Public License
#  along with this program; if not, write to the Free Software
#  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston,
#  MA 02110-1301, USA.
#  
#  


use strict;

use Getopt::Long;
use Complexity::Physical;
use IPC::Cmd qw[can_run run];



my $PS = Complexity::Physical->new();


my ($help,$in,$query,$verbos);
GetOptions ("i=s" => \$in,  # input 
            "h" => \$help,
            "v" => \$verbos,
            "q=i" => \$query
            );


my $full_path = can_run('muscle') or warn "\n\n \"muscle\" is not installed or named correctly! \n\n\tif not installed please install it and export its location\n\tif not named correctly rename is to: \"muscle\"\n\n";

exit if(!$full_path);
       
if($help || !$in){

print <<EOF;

  _____  _            _____                      _           
 |  __ \\| |          / ____|                    | |          
 | |__) | |__  _   _| |     ___  _ __ ___  _ __ | | _____  __
 |  ___/| '_ \\| | | | |    / _ \\| '_ ` _ \\| '_ \\| |/ _ \\ \\/ /
 | |    | | | | |_| | |___| (_) | | | | | | |_) | |  __/>  < 
 |_|    |_| |_|\\__, |\\_____\\___/|_| |_| |_| .__/|_|\\___/_/\\_\\
                __/ |                     | |                
               |___/                      |_|                
                                                            v0.01
EOF


  print "Usage:\n\n";
  print "\t-i\tinput fasta file\n";
  print "\t-h\tprints this\n";
  print "\t-q\tquery sequence id [def: 0] \n";
  print "\t-v\tverbos\n\n";

  exit(0);
}


$query = 0 unless $query > 0;


open(IN, "<", $in) || die "$!";
my %names;
my $x = 0;
while(<IN>){
  chomp;
  if(/>(.*)/){
    $names{$1} = $x;
    $x++;
  }
}


# -----         Compute MA array          ----- #

my $ma = qx(muscle  -in $in 2>/dev/null ); # 2>/dev/null
my @array = split("\n", $ma);
my %hash;
$x = 0;;
my @a =();

foreach my $line (@array){
   if ($line =~ />(.*)/){
      $hash{$names{$1}} = $1;
      $x = $names{$1};
      next;
   }else{
      my @tmp = split("", $line);
      push(@{$a[$x]},@tmp);
   }
}


# -----            Compute PS             ----- #

my $ps = $PS->PhyComplexCompute(queryid => $query, aligned => \@a);


# -----        Printing results           ----- #


if($verbos){
   print ">$hash{$query}\t$ps\n";
   for (0..@a-1){
      print "$hash{$_}\t". join("",@{$a[$_]})."\n";
   }
}else{
   print "$hash{$query}\t$ps\n";
}




  








