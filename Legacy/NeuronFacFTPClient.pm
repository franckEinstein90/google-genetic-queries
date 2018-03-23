#!/usr/local/bin/perl

package NeuronFacFTPClient
use strict;
use NeuronFacFile;
use Net::FTP;  

sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = {
	Host          => undef,
	Login         => undef,
	PWD           => undef,
	RemotePath    => undef,
	LocalPath     => undef
	};
    warn "Initiating NeuronFacFTPClient";
    $self->{GoogleSearcher} = (@_ ?shift:undef);
    
    bless($self, $class);
    if(@_){
	$self->initPopulation(shift);
    }else{
	warn "-->No path for initial population";
    }
    $self;
}
my $initFile;
my @pwdArray;
my $host;
my $path;
my $login;
my $pwd;
my $GS;
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
    $pop = new Population($GS,$popPath);

    $pop->makeNewGeneration();

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












