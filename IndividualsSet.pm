#!/usr/local/bin/perl

package IndividualsSet;
use question;
use NeuronFacFile;
use strict;


##################################################
## the object constructor                       ##
##################################################
sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = {
        Individuals     => undef,
        PopFile         => undef,
    };
    warn "Creating Associated IndividualsSet";
    bless($self, $class);
	if(@_){$self->initSet(shift);}
	else{warn "No path was provided for initial question population";}
    $self;
}
sub isIn( ){
	 my $self = shift;
	 my $elt = shift;
	return exists ${$self->{Individuals}}{$elt->getQuery( )};
}
sub insertNewElement( ){
	my $self = shift;
	my $geneticCode = shift;
	my $newIndividual = new question($geneticCode);
	${$self->{Individuals}}{$newIndividual->getQuery( )} = $newIndividual;
}
sub initSet(){
    my $self = shift;
    my $path;
    if(@_){$path = shift}
    warn "Loading:\n-->$path\n";
    $self->{PopFile} = new NeuronFacFile($path);
	my %popArray;
	$self->{Individuals} = \%popArray;
	my @PopFile = split(/\n/, $self->{PopFile}->getContent());
	foreach (@PopFile){
		$self->insertNewElement($_);
	}
}
sub getCurrentPopSize(){
    my $self = shift;
    return scalar(keys %{$self->{Individuals}})
}
sub getIndividual(){
    my $self = shift;
    my $IndIndex;
    if(@_){$IndIndex = shift;}
    else{die "No argument at IndividualsSet::getIndividual()"}
    my $questionKey = (keys %{$self->{Individuals}})[$IndIndex];
	
	return ${$self->{Individuals}}{$questionKey};
}
sub toString {
    my $self=shift;
    my @StrOutput;
    foreach  (keys %{$self->{Individuals}}){
        push(@StrOutput, ${$self->{Individuals}}{$_}->toString());
    }
    return join("\n", @StrOutput);
}

1;