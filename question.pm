package question;
use strict;

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = {
        TimesSubmitted => undef,
		AvgTimeToAnswer	=> undef,
		Query           => undef,
		Answer			=> undef,
		TimesCorrectlyAnswered => undef,
		Species =>undef
        };
	$self->{TimesSubmitted} = 0;
    $self->{AvgTimeToAnswer} = 0;
	$self->{TimesCorrectlyAnswered} = 0;
	
	if(@_){
        my $line = shift;
        if($line =~ m/(.*?),(.*)/){
            $self->{Query} = $1;
			$line = $2;
            if($line =~ m/\s*(.*)\s*/){
                $self->{Answer} = $1;
            }
        }
    }
    bless($self, $class);
    $self;
}

sub getQuery {
   my $self=shift;
   return $self->{Query};
}
sub getAnswer {
   my $self=shift;
   return $self->{Answer};
}

sub toString {
    my $self=shift;
	if($self->{Query}){
		my $ratio = "(".$self->{TimesCorrectlyAnswered}."/".$self->{TimesSubmitted}.") - ";
		my $avgTime = $self->{AvgTimeToAnswer}." - ";
		return  "$ratio$avgTime" . $self->{Query} . " , " . $self->{Answer};
		}
}



1;