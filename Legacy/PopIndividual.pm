#!/usr/local/bin/perl5

package PopIndividual;
use strict;
##################################################
## the object constructor                       ##
##################################################
sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = {
	Query           => undef,
	WordNum		=> undef,
	WordAvgLength	=> undef,
	LetterDiversityFactor    => undef,
	Pattern         => undef,
	HitCount	=> undef,
	Fitness		=> undef
	};
    if(@_){
	my $line = shift;
	if($line =~ /(.*?)\s+WN(.*)/){
	    $self->{Query} = $1;
	    $line = $2;
	    if($line =~ /.*HC:\s+(\d+).*/){
		$self->{HitCount} = $1;
	    }
	}else{
	    $self->{Query} = $line;
	}
    }
    if(@_){$self->{HitCount} = shift;}
    bless($self, $class);
    $self->analyzeQuery();
    $self;
}

sub analyzeQuery(){
    my $self = shift;
    my @W1=split /\s+/, $self->{Query};
    $self->{WordNum} = scalar(@W1);
    $self->{WordAvgLength} = 0;
    my $w;
    foreach $w (@W1){
	$self->{WordAvgLength} = $self->{WordAvgLength} + (length($w));
    }
    $self->{WordAvgLength} = $self->{WordAvgLength}/$self->{WordNum};
    $self->PatternAnalyse();
}

sub PatternAnalyse(){
#see http://pajhome.org.uk/crypt/wordpat.html
    my $self = shift;
    my $counter = 0;
    my $pattern = $self->{Query};
    $pattern =~ s/\s+//g;
    while($pattern =~ /.*?(\D).*/){
	my $letter = $1;
	$counter ++;
	$pattern =~ s/$letter/$counter/g
    }
    $self->{Pattern} = $pattern;
    $self->{LetterDiversityFactor} = $counter;
}

sub getRandomAllele(){
    my $self = shift;


}

sub isAllele{
    my $self = shift;


}
sub cross() {
    my $self = shift;
    my $other = shift;

    my $ChildQuery = $self->{Query};
    while(rand()>0.3){
	my $index = int(rand(length($other->{Query})));
	if($index < length($ChildQuery)){
	    my $beg = substr($ChildQuery, 0, $index-1) ;
	    my $ende = substr($ChildQuery, $index);
	    $ChildQuery=$beg.substr($other->{Query}, $index-1,1).$ende;
	}
    }
    #mutation
    while(rand()>0.9){
	my $index = int(rand(length($ChildQuery)-1));
	my $beg = substr($ChildQuery, 0, $index-1) ;
	my $ende = substr($ChildQuery, $index);
	$ChildQuery=$beg." ".$ende;
    }
    return new PopIndividual($ChildQuery);
}

sub toString {
    my $self=shift;
    my $options = "";
    if(@_){$options = shift;}
    my $HTML = 0;
    if($options =~ /.*[i][n]\s+[H][T][M][L].*/){$HTML = 1;}
    
    my @array;

    my $res = "";
    if($self->{Query}){
	if($HTML){
	    $res .= '<font size=+2 color=red><A HREF="';
	    $res .= 'http://www.google.com/search?hl=xx-hacker&q=';
	    $res .= join('+', split(/\s+/, $self->{Query}));
	    $res .= '&btnG=Google+s3a%7C2ch" target="_blank">';
	}
	$res .=  $self->{Query}."  ";
	if($HTML){$res .= "</A></font><BR>";}
	$res =$res."WN: $self->{WordNum}  ";
	$res =$res."AVG: $self->{WordAvgLength}  ";
	$res =$res."HC: $self->{HitCount}  ";
	$res = $res."Patt: $self->{Pattern}  ";
	$res = $res."DF: $self->{LetterDiversityFactor}  ";
	if($HTML){$res .= "<BR>";}
	if($options =~ /.*ShowFitness.*/){
	    if($self->{Fitness}){
		if($HTML){$res .= '<font size=+2 color=red>';}
		$res = $res." --->".$self->{Fitness};
		if($HTML){$res .= "</font>";}
	    }
	}
    }
    return $res;
}

1;

