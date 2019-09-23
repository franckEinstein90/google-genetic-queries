package Population;

use IndividualsSet;
use strict;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = {
                Population      => undef,
                MaxPopSize      => undef,
                ObjectiveFunction   => undef,
                TotalFitness    => undef,
                AverageFitness  => undef,
                GenerationNum   => undef
        };
        warn "\nCreating Population";
        bless($self, $class);
        if(@_){$self->initPopulation(shift)}
		else  {warn "-->No path for initial population"}
		$self;
}

sub isIn( ){
	 my $self = shift;
	 $self->{Population}->isIn(shift);
}
sub insertNewIndividual( ){
	 my $self = shift;
	 my $dna = shift;
	 $self->{Population}->insertNewElement($dna);
}
sub initPopulation(){
    my $self = shift;
    if(@_){
        my $path = shift; 
		$self->{Population} = new IndividualsSet($path);
    }
}

sub getCurrentPopSize(){
    my $self = shift;
    return $self->{Population}->getCurrentPopSize();
}
sub chooseRandomIndividual{
	my $self = shift;
	my $index = int(rand($self->getCurrentPopSize())-1);
	return $index;
}
sub toString {
    my $self=shift;
    my @array;
    push (@array, $self->{Population}->toString());
	return join("\n", @array);
}            

1;