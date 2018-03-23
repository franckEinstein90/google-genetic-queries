package EvaluatingFunction;
use NeuronFacFile;
use strict;

sub new {
    	my $proto = shift;
    	my $class = ref($proto) || $proto;
    	my $self  = {
		WebLocation	=> undef,
		FitFormula     => undef
	};
	if(@_){$self->{WebLocation} = shift;}
    	bless($self, $class);
	$self->getFitFormula();
    	$self;
}

sub getFitFormula(){
    	my $self = shift;
    	my $HomePageFormula = new NeuronFacFile();
    	$HomePageFormula->{ReadingPath} = $self->{WebLocation};
	
    	if($HomePageFormula->getContent() =~ /.*<P>.*?formula.*?Eval_w.*?\:.*?\$(.*?)\$/){
	my $fitFormula = "$1;";
	$fitFormula =~ s/(\W)\_(\w)/$1\$$2/g;
	$self->{FitFormula}= $fitFormula;
	#'(($H_W == 0)?0:(1.0/$H_W)) * (($AV_W * 20) + ($LD_W*30) + ($N_W*5));'#$#'
    }
}

sub toString(){
	my $self=shift;
	return $self->{FitFormula}; 	
}
1;
