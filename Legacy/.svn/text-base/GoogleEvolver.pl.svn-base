#!/usr/local/bin/perl
use strict;
use PopIndividual;
use Population;
use EvaluatingFunction;
use GoogleSearcher;
use Net::FTP;  

sub getRandIntegerSmallerThan($Max){return int(rand(shift));}
sub createWord(){
    my $varSize = &getRandIntegerSmallerThan(5) + 5;
    my $var ="";
    while($varSize--) {
	$var = $var.chr(97 + &getRandIntegerSmallerThan(25));
    }
    return $var;
}
sub createQ(){
    my $prob = 1;
    my $res =  &createWord();
    while (rand()>0.8){
     	$res = $res." ";
     	$res = $res.&createWord();
    }
    return $res;
}
sub makeNewRandomPopIndividual(){
    my $popMember;
    if(@_){$popMember = shift;}else{ $popMember = new PopIndividual(&createQ());}
    $popMember->{HitCount} = &getHC($popMember->{Query});
   	while($popMember->{HitCount} == 0){
        $popMember =  new PopIndividual(&createQ());
     	$popMember->{HitCount} = &getHC($popMember->{Query});
	}
    return $popMember;
}

my $initFile;
my @pwdArray;
my $host;
my $path;
my $login;
my $pwd;
my $GS;
my $FF;
my $pop;
my $HTMLView = "Population.html" ;
my $Datafile = "Population.txt";
my $popPath;

if(scalar(@ARGV)==0){
    warn "I need an initialisation file";
}
else {
    $initFile = new NeuronFacFile(shift @ARGV);
    @pwdArray =  split /\n/,$initFile->getContent();
    $popPath = shift @pwdArray;
    $host = shift @pwdArray;
    $path = shift @pwdArray;
    $login = shift @pwdArray;
    $pwd = shift @pwdArray;
    $GS = new GoogleSearcher(@pwdArray);
	$FF = new EvaluatingFunction("http://www.site.uottawa.ca/~fbinard/EA/GA/GoogleEvolver/index.html");
    $pop = new Population($GS,$FF,$popPath);
    $pop->makeNewGeneration(500);

    open OUT1, ">$HTMLView";
    print OUT1 $pop->toString("ShowFitnessFormula in HTML");
    close(OUT1);

    open OUT2, ">$Datafile";
    print OUT2 $pop->toString("Data");
    close(OUT2);

    SaveOutput($HTMLView, $Datafile);
}



sub SaveOutput(){
    my @fileList;
    while(@_){push @fileList, shift}

    my $ftp = Net::FTP->new($host, Timeout => 60) 
	or die "Cannot contact $host: $!";  
    $ftp->login($login, $pwd) 
	or die "Can't login ($host):" . $ftp->message;  
    $ftp->cwd($path) or 
	die "Can't change directory ($host):" . $ftp->message; 
    $ftp->ascii();
  
    my $file;
    foreach $file (@fileList){
	warn "\n\nTrying to save $file";
	warn "-->On host: $host";
	warn "-->On path: $path";
	$ftp->put($file);	
	warn "-->Save suceeded";
    }
    $ftp->quit or 
	die "Couldn't close the connection cleanly: $!";  
}












