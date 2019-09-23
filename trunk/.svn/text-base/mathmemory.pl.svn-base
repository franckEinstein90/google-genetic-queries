#!/usr/local/bin/perl


#2 sick days
#monady 
#tuesday 
#wednes
#get the exact dates*

 use strict;
 use Population;
 use strict;
 use warnings;
 use Switch;
 use Time::HiRes qw( usleep gettimeofday tv_interval);


my $QuestionPopulation = new Population( "qestions.dat" );  
my $currentLevel = 0;
my $numQuestions = 30;

my $desiredAvgTimeToProgress = 3;

sub flip {
	return int(rand(2));
	}
	
sub checkCorrectness{
	my $answer = shift;
	my $UserAnswer = shift;
	$UserAnswer =~ s/\s*//g;
	$answer =~ s/\s*//g;
	my $CorrectlyAnswered =  $UserAnswer eq $answer;
	return $CorrectlyAnswered
}
sub generateBetween0and9 {
	my $range = 10;
	return int(rand($range));
	}
sub generateBetween10and19 {
	return "1".&generateBetween0and9;
	}
sub generateBetween0and19 {
	return return int(rand(20));
	}
	
sub level0{
	my $leftHandSide = &generateBetween0and9( );
	my $rightHandSide = &generateBetween0and19( );
	my $choiceVar = int(rand(4));
	return  new question ("$leftHandSide x $rightHandSide,".($leftHandSide * $rightHandSide));
	#case 1 {return  ($leftHandSide . " + " .  $rightHandSide) , ($leftHandSide +  $rightHandSide)}
	#case 2 {return  ($leftHandSide . " - " .  $rightHandSide) , ($leftHandSide -  $rightHandSide)}
	#case 3 {return &generateOtherRandom}
}
sub makeNewQuestion{
	my $currentLevel = shift;
	switch ($currentLevel) {
		case 0 { return &level0; }
		case 1 { return &level1; }
		case 2 { return &level2; }
		case 3 { return &level3; }
		case 4 { return &level4; }
		#case 5 { return &level5; }
		else {
			print "\nYou beat the game :-)";
			exit 0;
			}
	}
}
sub questionChooser{
	my $currentLevel = shift;
	if(flip( )) { 
		my $idx = $QuestionPopulation->chooseRandomIndividual( );
		return $QuestionPopulation->{Population}->getIndividual($idx); 
	}
	return makeNewQuestion($currentLevel);
}

sub commandMachine{
	my $command = shift;
	switch ($command) {
		case "list questions" { 
			print "\n\n************************\n";
			print $QuestionPopulation->toString(); 
			print "\n************************\n\n\n";
			}
		else{
			print "Unknown Command\n";
			}
		}
	}


sub addInd( ){
	my $individual = shift;
	my $dna = $individual->getQuery( ) . "," .  $individual->getAnswer( );
	$QuestionPopulation->insertNewIndividual( $dna );
}	
sub processUserAnswer(){
	
	my $individual = shift;
	my $correctlyAnswered = shift;
	my $timeDelay = shift;
	my $isIn = $QuestionPopulation->{Population}->isIn($individual);
	
	$individual->{TimesSubmitted}++;
	if ($correctlyAnswered){
		$individual->{TimesCorrectlyAnswered}++;
		if ($individual->{TimesSubmitted} == 1) {$individual->{AvgTimeToAnswer} = $timeDelay;}
		else {
			my $factor = $individual->{AvgTimeToAnswer}  * ($individual->{TimesSubmitted} - 1);
			$individual->{AvgTimeToAnswer} = ($factor + $timeDelay) / $individual->{TimesSubmitted};
		}
		if ((!$isIn) and ($timeDelay > $desiredAvgTimeToProgress)){&addInd($individual);}  
	}
	elsif (!$isIn){&addInd($individual);}
	1;
}
while (1){
	my $averageTime = 0;
	my $ctr;
	my $timeDelay = 0;
	my @times;
	for($ctr = 0; $ctr < $numQuestions; $ctr++){
		#system("clearScreen.bat");
		my $currentAvg = 0;
		if ((scalar @times) > 0) {
			my $acc = 0;
			foreach (@times) { $acc += $_;}
			$currentAvg = $acc / (scalar @times);
		}
		print "\n**** Question: ". $ctr . " Level: ".$currentLevel."  Avg Time: ". $currentAvg ." *****\n";
		print "Delay for last question was: " . $timeDelay . "\n";
		my $t0 = [gettimeofday];	
		my $Individual = questionChooser( $currentLevel );
		
		print $Individual->{AvgTimeToAnswer} . " - ";
		print $Individual->{TimesSubmitted} . " - ";
		print $Individual->{TimesCorrectlyAnswered} ."\n";
		print $Individual->getQuery( )."\n";
	
		
		my $UserAnswer = <>;
		chomp $UserAnswer;
		if($UserAnswer =~ m/^\s*com\s+(.*)\s*$/){
			my $command = $1;
			print "Executing command: [".$command."]\n";
			commandMachine($command);
			}
		
		$timeDelay = tv_interval $t0, [gettimeofday];
		unshift (@times,$timeDelay);		
		my $CorrectlyAnswered = checkCorrectness( $Individual->getAnswer( ), $UserAnswer);
		&processUserAnswer($Individual, $CorrectlyAnswered, $timeDelay);
		
		if ($CorrectlyAnswered){
			$averageTime += $timeDelay;
			print "Correct: " . $timeDelay . "\n";
			if ($ctr == $numQuestions - 1){
				$averageTime /= $numQuestions;	
				print "Average Time = " . $averageTime . "\n";
				if ($averageTime < $desiredAvgTimeToProgress) {$currentLevel++;}
				elsif ($averageTime > 7.0 && $currentLevel > 0){$currentLevel--;}
				}
		}
		else {
			print "Incorrect\n";
			print "The correct answer was ".$Individual->getAnswer( );
			if ($currentLevel > 0){$currentLevel--;}
			last;
		}
	}
}