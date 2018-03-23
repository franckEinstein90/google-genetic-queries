#!/usr/local/bin/perl

package IndividualsSet;
use PopIndividual;
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
    warn "\n\n\n----------IndividualsSet-------\n\n";
    bless($self, $class);
    if(@_){
	$self->initPopulation(shift);
    }else{
	warn "-->No path for initial population";
    }
    $self;
}

sub getCurrentPopSize(){
    my $self = shift;
    return scalar(@{$self->{Individuals}})
}

sub initPopulation(){
    my $self = shift;
    my $path;
    if(@_){$path = shift}
    warn "Loading:\n-->$path\n";
    $self->{PopFile} = new NeuronFacFile($path);
    my @popArray;
    my @PopFile = split(/\n/, $self->{PopFile}->getContent());
    my $line;
    foreach $line (@PopFile){
#	if($line =~ /w+/){
	    my $popMember = new PopIndividual($line);
	    push(@popArray, $popMember);
	#}
    }
    $self->{Individuals} = \@popArray;
}

sub getIndividual(){
    my $self = shift;
    my $IndIndex;
    if(@_){$IndIndex = shift;}
    else{die "No argument at IndividualsSet::getIndividual()"}
    return @{$self->{Individuals}}[$IndIndex];
}

sub removeIndividual(){
    my $self = shift;
    my $IndIndex=(@_?shift:undef);
    if($IndIndex){
	
    }
}
sub addIndividual(){
    my $self=shift;
    my $Ind;
    if(@_){$Ind = shift;}else{die "No Individual at IndividualSet::addIndividual"}
    push  @{$self->{Individuals}}, $Ind;
}

sub toString {
    my $self=shift;
    my $options = "";
    if(@_){
	$options = shift;
    }
    warn "$options";
    my $HTML = 0;
    if($options =~ /.*[i][n]\s+[H][T][M][L].*/){
	warn "Printing HTML";
	$HTML = 1;
    } 
    my @StrOutput;
    if($HTML){push (@StrOutput,  "</h3><P>");}
    my $popMember;
    foreach $popMember (@{$self->{Individuals}}){
	push(@StrOutput, $popMember->toString($options));
	if($HTML){push (@StrOutput,  "<BR>");}
    }
    return join("\n", @StrOutput);
}


1;
