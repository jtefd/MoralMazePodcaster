#!/usr/bin/env perl

use strict;

use File::Basename qw/basename dirname/;
use File::MimeInfo;
use File::Path qw/mkpath/;
use File::Spec::Functions qw/catfile/;
use File::stat;
use POSIX qw/strftime/;
use XML::RSS;

use vars qw/$VERSION/;

$VERSION = '0.0.1';

use constant FILES_DIR => '/var/www/moralmaze';
use constant WEBROOT => 'http://tefd.co.uk/podcast/moralmaze';

unless (-d FILES_DIR) {
	mkpath FILES_DIR;
}

chdir FILES_DIR;

system('echo no | get-iplayer --get "moral maze" --type radio >/dev/null 2>/dev/null');

my $rss = XML::RSS->new(version => '2.0');

$rss->channel(
    title => 'BBC Radio 4 - Moral Maze',
    description => 'Combative, provocative and engaging live debate examining the moral issues behind one of the week\'s news stories. Chaired by Michael Buerk.',
    link  => 'http://www.bbc.co.uk/programmes/b006qk11',
    language => 'en',
    lastBuildDate  => strftime('%a, %d %b %Y %T %z', gmtime(time)),
);

$rss->image(
	title => 'BBC Radio 4 - Moral Maze',
	description => 'Combative, provocative and engaging live debate examining the moral issues behind one of the week\'s news stories. Chaired by Michael Buerk.',
	link  => 'http://www.bbc.co.uk/programmes/b006qk11',
	url => 'http://www.bbc.co.uk/iplayer/images/progbrand/b006qk11_178_100.jpg' 
);	

opendir DIR, FILES_DIR;

my @files =  sort { -M FILES_DIR . "/$a" <=> -M FILES_DIR . "/$b" } grep { /\.aac$/ } readdir(DIR);

foreach my $episode (@files) {
	my @filetime = gmtime(stat($episode)->mtime);
	
	my $url = WEBROOT . '/' . $episode;
	
	my $date_str = strftime('%a, %d %b %Y', @filetime);
	
	$rss->add_item(
        title => "Moral Maze - $date_str",
        description => "Moral Maze from $date_str",
        link => $url,
        pubDate => strftime('%a, %d %b %Y %T %z', @filetime),
        enclosure => {
        	url => $url,
        	length => -s $episode,
        	type => mimetype($episode)
        },
        permaLink => $url
    );
}

closedir DIR;

open FILE, '>feed.rss';
print FILE $rss->as_string;
close FILE