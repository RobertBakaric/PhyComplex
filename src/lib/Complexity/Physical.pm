#  Physical.pm
#  
#  Copyright 2016 Robert Bakaric <rbakaric@exaltum.eu>
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


package Complexity::Physical;

use vars qw($VERSION);

$VERSION = '0.01';

use strict;
use Carp;


=head1 NAME

Complexity::Physical - Simple sequence complexity calculator 

=head1 SYNOPSIS

    use Complexity::Physical;

    my $PSobject = Complexity::Physical->new();

    @array = [['-','A','B','C','H','-','I','I','-'],
	      ['-','A','C','C','S','-','-','I','-'],
	      ['-','-','C','C','A','-','O','I','-']];

    $query = 0;
    
    # -----        Compute Physical Complexity        ----- #
    my $ps = $PSobject->PhyComplexCompute(queryid => $query, aligned => \@array);

    # -----               Print result                ----- #
    print "Physicyl complexity of sequence 0 is: $ps\n"; ## Expected result:  3


=head1 DESCRIPTION

The program utilizes a mathematical measure called physical complexity [1] to compute
the amount of information about a particular environment stored in a given sequence.  
The measure should not be confused with the Kolmogorov complexity since physical 
complexity only  deals  either with  the  intrinsic  regularity  or  irregularity  
of a sequence in this case. 



=head2 new

    my $PSobject = Complexity::Physical->new();

    
Creates a new Complexity::Physical object.
   

=head2 PhyComplexCompute

    my $ps = $PSobject->PhyComplexCompute(queryid => $query, aligned => \@array);

Where \@array is an array reference to a 2D matrix consisting of the aligned strings.
Alignment is required or be global

Example:  @array 

	[['-','A','B','C','H','-','I','I','-'],
	 ['-','A','C','C','S','-','-','I','-'],
	 ['-','-','C','C','A','-','O','I','-']]

queryid refers to the index position of the alignment in @array. For example 0 
refers to   ['-','A','B','C','H','-','I','I','-'] setting it to be the string
for which the complexity is to be calculated.

Function returns the complexity value for a given query sequence.

=head2 _ComputePosEntropy
    
    $H_cond = $self->_ComputePosEntropy(characters => \%hash, alphabet => $postot ) ;

    This is a private function that computes the conditional entropy for a given 
    location in a query sequence. Function requires list of all characters occupying 
    a given location and their occurrence counts. Moreover, the information about the 
    number of characters present at a given site needs to be provided through alphabet 
    option (key).
    
=head2 _Log

    $log = $self->_Log($p,$arg{alphabet})

    Private function designed for computing a log_y(x). First argument is the value
    and the second is the base.


=head1 AUTHOR

Robert Bakaric <rbakaric@exaltum.eu>

=head1 LICENSE

  
#  Copyright 2016 Robert Bakaric <rbakaric@exaltum.eu>
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

=head1 ACKNOWLEDGEMENT


      1. Adami, C. and Cerf, N.J. (2000) Physical complexity of symbolic sequences, Physica D 137 62-69.
 
=cut






#################################################
#               CONSTRUCTOR
#################################################
#################################################
sub new {
#################################################

my ($class)=@_;

my $self = {};

bless ($self,$class);

}


#################################################
#               FUNCTIONS
#################################################
#################################################
sub PhyComplexCompute {  
#################################################

my ($self,%arg) = @_;

my $H_cond=0;
my $H_max=0;


for (my $i=0; $i<= $#{$arg{aligned}->[$arg{queryid}]}; $i++){
   next if $arg{aligned}->[$arg{queryid}]->[$i] eq "-";
   $H_max++;
   my $postot=0;
   my %hash = ();

   for (my $j=0; $j<= $#{$arg{aligned}}; $j++){
      next if $arg{aligned}[$j][$i] eq "-";
      $hash{$arg{aligned}[$j][$i]}++;
      $postot++;
   }
   $H_cond += $self->_ComputePosEntropy(characters => \%hash, alphabet => $postot ) if $postot > 1 ;
}

return ($H_max + $H_cond);
}

#################################################
sub _ComputePosEntropy {  
#################################################

my ($self,%arg) = @_;

my $PosEntropy = 0;
foreach my $c (keys %{$arg{characters}}){
   next if $c eq "-";
   my $p = $arg{characters}->{$c} / $arg{alphabet};
   $PosEntropy += ($p * ($self->_Log($p,$arg{alphabet})));	
}
   
return $PosEntropy;
}




#################################################
sub _Log {  
#################################################

my ($self,@arg)= @_;
return log($arg[0])/log($arg[1]);

}


1;

