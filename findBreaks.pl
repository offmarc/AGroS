#!/usr/bin/perl -w


###############
##   Title   ##
###############################################################################

my $header = <<'EOHEADER';
------------------------------------------------------------------------------
		                findBreaks.pl	      
------------------------------------------------------------------------------					      

 A script to find gaps (missing residues) in PDB structures.
									      
		     Authors: (C) Marc Offman				      
			       Date: 05.03.2012 			      
			       Version: 1				      
									      
									      
			  Thank you for using findBreaks.pl!			      
	    Any questions should be adressed to offman@rostlab.org	      
									      
------------------------------------------------------------------------------

EOHEADER

open(PDB,"$ARGV[0]");
$oldRes = -9999999;
while(<PDB>){
	chomp($_);
	if(/^ATOM/){
		#print "$_\n";
		$res = substr($_,22,4);
		$res=~s/\s+//g;
		#print "|$res|\n";
		if($oldRes != $res){
			if($oldRes != -9999999 && abs($res-$oldRes) > 1 && $res > $oldRes){
				print "$oldRes\:$res\n";
			}
			$oldRes = $res;
		}
	}
	elsif(/^TER/){
	
	}
}
close PDB;
#exit;

