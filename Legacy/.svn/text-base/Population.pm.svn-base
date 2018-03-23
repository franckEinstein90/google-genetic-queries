#!/usr/local/bin/perl

package Population;
use PopIndividual;
use NeuronFacFile;
use IndividualsSet;
use GoogleSearcher;
use strict;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = {
		Population     	=> undef,
		MaxPopSize     	=> undef,
		ObjectiveFunction   => undef,
		TotalFitness   	=> undef,
		AverageFitness 	=> undef,
		GenerationNum  	=> undef,
		GoogleSearcher 	=> undef
	};
    	warn "\nCreating Population";
    	if(scalar(@_) > 2)
	{($self->{GoogleSearcher}, $self->{ObjectiveFunction})=(shift,shift)}
    	bless($self, $class);
    	if(@_){$self->initPopulation(shift)}else{warn "-->No path for initial population"}
    	$self;
}
sub getCurrentPopSize(){
    my $self = shift;
    return $self->{Population}->getCurrentPopSize();
}
sub initPopulation(){
    my $self = shift;
    my $path;
    if(@_){
	$path = shift;
    }
    $self->{Population} = new IndividualsSet($path);
}



sub calcFitness(){
	my $self = shift;
    	my $ind = shift;
   	my $H_W = $ind->{HitCount};
	my $N_W = $ind->{WordNum};
	my $AV_W = $ind->{WordAvgLength};
	my $LD_W = $ind->{LetterDiversityFactor};
	$ind->{Fitness} = eval $self->{ObjectiveFunction}->{FitFormula};
	return $ind->{Fitness};
	return -1;
}

sub EvalPopulation(){
    my $self = shift;
    my $options = @_ ? shift : "";
    if($options =~ /.*Announce.*/)
    {warn "\nEvaluating population using formula:\n-->".$self->{ObjectiveFunction}->toString()."\n"}
  	my $popMember;
	$self->{TotalFitness} = 0;
	foreach $popMember (@{$self->{Population}->{Individuals}}){
		$self->{TotalFitness} += $self->calcFitness($popMember);
		$self->{AverageFitness} = $self->{TotalFitness}/$self->getCurrentPopSize(); 
		if($options =~ /.*Announce.*/){
	    		warn "Population was evaluated:\n";
	    		warn "-->Total Fitness is: ".$self->{TotalFitness};
	    		warn "-->Average Fitness is: ".$self->{AverageFitness};
	    		warn "-->There are: ".$self->getCurrentPopSize()." chromosomes in the population";
		}
    }
}

sub fitnessPropSelectIndividual(){
    my $self = shift;
    my $inverse = 0;
    if(@_){
	my $options = shift;
	if($options =~ /inverse/){
	    $inverse = 1;
	}
    }
    my $total=100;
    my $dice = 0;

    my $index = int(rand($self->getCurrentPopSize())-1);
    while($dice < $total){
    	$index = ($index + 1)  % $self->getCurrentPopSize();
	my $Individual = $self->{Population}->getIndividual($index); 
	#warn "\n\n".$index." ".$dice;#.$Individual->toString();
    	my $needle = $Individual->{Fitness}/$self->{AverageFitness};
	if($inverse){$needle = 1.0/$needle}
	$dice = $dice + $needle;
    }
    return $index;
}


sub  kill1Individual{
    my $self = shift;
    
    my $i=0;
    my @newPop;
    my $indexKill = $self->fitnessPropSelectIndividual("inverse");
    warn "\nKilling:".(@{$self->{Population}}[$indexKill])->toString();
    while ($i++ < $indexKill){push (@newPop, @{$self->{Population}}[$i])}
    my $popSize = $self->getCurrentPopSize();
    $i = $i+1;
    while($i++ < $popSize){push (@newPop, @{$self->{Population}}[$i])}
    $self->{Population} = \@newPop;
}


sub doCrossover(){
    my $self = shift;
    my $options = "";
    my $Daddy = shift;
    my $Mommy = shift;
    if(@_){$options = shift;}
    my $child = $Daddy->cross($Mommy);
    if($options =~ /.*Announce birth.*/){warn $child->toString();}
    return $child;
}
sub Create1NewIndividual(){
	my $self = shift;
	my $RecLoop;
	my $options = "";
	if($self->{GoogleSearcher}==undef){warn "no GoogleSearcher"; return new PopIndividual("No GoogleSearcher");}
	$self->EvalPopulation();
	if(@_){if(($RecLoop = shift)< 1){return}}else{$RecLoop = 10}
	if(@_){$options = shift;}
	my $Daddy = $self->{Population}->getIndividual($self->fitnessPropSelectIndividual());
	my $Mommy = $self->{Population}->getIndividual($self->fitnessPropSelectIndividual());
	if($options =~ /.*Announce.*/){
	    warn "Crossing:\n";
	    warn "\nDaddy:".$Daddy->toString()."\n";
	    warn "Mommy:".$Mommy->toString()."\n\n";
	}
	my $child = $self->doCrossover($Daddy, $Mommy, $options);
	eval {$self->{GoogleSearcher}->getPopIndividualHC($child);};
	if($@){warn $@}
	else{
	    if($child->{HitCount}){
		warn $child->toString();
		$self->{Population}->addIndividual($child);
		return $child;
	    }
	    else{
		warn "STILLBORN";
		$self->Create1NewIndividual($RecLoop-1, $options);
	    }
	}
    }


sub CreateNNewIndividuals(){
	my $self = shift;
	my $num = shift;
	while($num--){
	    $self->Create1NewIndividual(10,"Announce");    
	}
}


sub makeNewGeneration(){
    my $self = shift;
    my $maxPopSize = shift;

    $self->EvalPopulation("Announce");
    warn "\n-----\n";
    warn "Making next generation (".$self->{GenerationNum}.") of population\n";
    warn "Current population size is:".$self->getCurrentPopSize();
    my $continue = 1;
    while($continue){
	$self->CreateNNewIndividuals(10);
	$continue = 0;
    }
   # while($self->getCurrentPopSize() > $maxPopSize){
	#$self->kill1Individual();
    #}
    warn "Current population size is: ".$self->getCurrentPopSize();
    warn "\n\n";
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
    
    my @array;
    if($HTML){
	push (@array,  "<html><body><h3>");
    }
    if($options =~ /.*Show.*Fitness.*Formula.*/){
	if($self->{FitFormula}){
	    push (@array,  "Objective Function:".$self->{FitFormula}) ;
	}
	else{
	    push (@array,  "No fitness function") ;
	}
    }
    if($HTML){push (@array,  "<\/h3><P>");}
    push (@array, $self->{Population}->toString($options));
    if($HTML){push (@array,  "<\/P>");}
    if($HTML){push (@array,  "</body></html>");}
    return join("\n", @array);
}            
1;
