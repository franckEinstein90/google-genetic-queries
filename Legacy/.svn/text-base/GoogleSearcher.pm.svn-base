#!/usr/local/bin/perl

package GoogleSearcher;
use PopIndividual;
use strict;
use SOAP::Lite;

##################################################
## the object constructor                       ##
##################################################
sub new {

    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = {
	KeysArray     => undef,	
	KeysUse       => undef,
	MaxTry        => undef,
	google_s      => undef

    };
    warn "Initialising GoogleSearcher:\n";
    my @Keys;
    my @KeysUse;
    
    while(@_){
	my $key = shift;
	warn  "-->Adding key $key";
	push  @Keys, $key;
	push  @KeysUse, 0;
    }
    
    $self->{KeysArray} = \@Keys;
    $self->{KeysUse}   = \@KeysUse;
    $self->{google_s}  = SOAP::Lite->service("http://api.google.com/GoogleSearch.wsdl");
    bless($self, $class);$self;
}


sub chooseKeyIndex(){
    my $self = shift;
    my $index = 0;
    while(@{$self->{KeysUse}}[$index]>=1000){
	if ($index >= scalar(@{$self->{KeysUse}})-1){return -1;}
	$index++;
    }
    $index;
}

sub getPopIndividualHC(){
    my $self = shift;
    my $ind;
    if(@_){$ind=shift;}else{return "No individual";}
    my $continue = 1;
    my $errorNum = 0;
    
    while($continue){
	my $index = $self->chooseKeyIndex();
	if($index >= 0){
	    my $gk = @{$self->{KeysArray}}[$index];
	    (@{$self->{KeysUse}}[$index])++;
	    my $result;
	    eval {
		$result = $self->{google_s}->doGoogleSearch(
							    $gk, 
							    $ind->{Query}, 
							    0, 
							    10, 
							    "false", 
							    "", 
							    "false",
							    "", 
							    "latin1",
							    "latin1");};
	    if($@){
		warn $@;
		print "\n";
		$errorNum += 1;
		if($errorNum >= 5){$continue = 0;}
	    }	
	    $ind->{HitCount} = $result->{estimatedTotalResultsCount};
	    return $result;
	}
    }
    return "Unable to query google";
}

1;
