#!/usr/local/bin/perl5
#modified January 25 2005
# -Added functionality to construtor

package NeuronFacFile;
use strict;
use LWP::UserAgent;
use LWP::Simple;
use File::Find;


##################################################
## the object constructor                       ##
##################################################
sub new {
    my $proto = shift;
    my $class = ref($proto) || $proto;
    my $self  = {
	FileId          => undef,
	ReadingPath     => undef,
	WritingPath     => undef,
	CreationDate    => undef,
	LastUpdateDate  => undef,
	Size            => undef,
	FileType        => undef,
	UserEditable    => undef,
	WebSiteId       => undef,
	Content         => undef,
	ErrString       => undef
	};
    if(@_){
	$self->{ReadingPath} = shift;
    }
    bless($self, $class);
    return $self;
}

sub readTableRow{
    my $self = shift;
    my $ref  = shift;
    for (keys %$ref) {$self->{$_} = $ref->{$_}}
}

sub isLocal{
    my $self = shift;
    my $File  = $self->{ReadingPath};
    if (($File)&&(-f $File)){1;}else {0;}
}

sub fileName{
    my $self = shift;
    my $FileName = $self->{ReadingPath};
    if ($FileName){
	$FileName =~ s/^.*\/(.*?)\..*$/$1/;
	$FileName =~ s/_/ /g;
    }
    return $FileName;
}

sub getLocalContent{
    my $self = shift;
    my $File  = $self->{ReadingPath};
    open(INPUT,"<$File");
    undef $/;
    my $content = <INPUT>;
    close INPUT;
    $/ = "\n";     #Restore for normal behaviour later in script
    return $content;
}

sub getContent(){
    my $self = shift;
    my $path = $self->{ReadingPath};
    my $content;
    if($self->isLocal()){$content=$self->getLocalContent();} else{$content = get($path);}

    $self->{ErrString} =
	"\n<BR> Exception at NeuronFacFile:getContent(), unable 2 get "
	.$self->{ReadingPath}
    unless ($content);
    $self->{Content} = $content unless ($content);
    return $content;
}


sub toString{
    my $self = shift;
    my $delimiter = ',';
    if (@_) {$delimiter = shift;}
    my $outString =<<TOTHERE;
    FileId          =>$self->{FileId}
    $delimiter
	ReadingPath     => $self->{ReadingPath}
    $delimiter
	WritingPath     => $self->{WritingPath}
    $delimiter
	CreationDate    => $self->{CreationDate}
    $delimiter
	LastUpdateDate  => $self->{LastUpdateDate}
    $delimiter
	Size            => $self->{Size}
    $delimiter
	FileType        => $self->{FileType}
    $delimiter
	UserEditable    => $self->{UserEditable}
    $delimiter
	WebSiteId       => $self->{WebSiteId}

TOTHERE
    }
1;

