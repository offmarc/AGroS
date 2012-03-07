#!/usr/bin/perl -w


###############
##   Title   ##
###############################################################################

my $header = <<'EOHEADER';
------------------------------------------------------------------------------
		                  clshwtr.pl		      
------------------------------------------------------------------------------					      
 A script to remove potential clashing water. Used in the AGroS pipeline.
 									      
		     Authors: (C) Marc Offman				      
			       Date: 05.03.2012 			      
			       Version: 1				      
									      
									      
			  Thank you for using clshwtr.pl!			      
	    Any questions should be adressed to offman@rostlab.org	      
									      
------------------------------------------------------------------------------

EOHEADER

if(not defined $ARGV[0] || not defined $ARGV[1]){
	print STDERR "./clshwtr.pl <PDB> <CUTOFF>\n";
	exit;
}
elsif(! -e "$ARGV[0]"){
	print STDERR "File $ARGV[0] not found!\n";
	exit;
}
$cutoff = $ARGV[1];
open(PDB,$ARGV[0]);
while(<PDB>){
	chomp($_);
	if($_=~m/^ATOM/ || $_=~m/^HETATM/){
		$resName = substr($_,17,3);
		$resName =~ s/\s+//g;
		$atomName = substr($_,12,4);
		$atomName =~ s/\s+//g;
		$xCoord = substr($_,30,8);
		$xCoord =~ s/\s+//g;
		$yCoord = substr($_,38,8);
		$yCoord =~ s/\s+//g;
		$zCoord = substr($_,46,8);
		$zCoord =~ s/\s+//g;
		$resNR = substr($_,22,4);
		$coords{$xCoord}{$yCoord} = $zCoord;
		if($resName eq "HOH"){
			$lines{$resNR} = $_;
			$water{$resNR} = "$xCoord\_$yCoord\_$zCoord";
		}
	}
}
close PDB;

foreach $key (sort sorty keys %water){
	@tmp = split/\_/,$water{$key};
	$xCart = $tmp[0];
	$yCart = $tmp[1];
	$zCart = $tmp[2];
	#print "$key $xCart $yCart $zCart\n";
	foreach $key1 (sort sorty keys %coords){
		#print "$key1\n";
		if(abs($xCart - $key1) < $cutoff){
			foreach $key2 (sort keys %{$coords{$key1}}){
				$dist = sqrt(($xCart - $key1)**2 + ($yCart - $key2)**2 + ($zCart - $coords{$key1}{$key2})**2);
				if($dist <= $cutoff && !($xCart == $key1 && $yCart == $key2 && $zCart == $coords{$key1}{$key2})){
					#print "$key  $dist remove\n";
					delete $coords{$key1}{$key2};
					delete $lines{$key};
				}
			}
		}
	}
}

foreach $key (sort sorty keys %lines){
	print "$lines{$key}\n";
}
print "TER\n";
sub sorty{$a<=>$b}
