use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'MoralMazePodcaster',
    VERSION_FROM      => 'scripts/podmaze.pl', # finds $VERSION
    PREREQ_PM         => { 'File::Basename', 'File::MimeInfo', 'File::Path', 'File::Spec::Functions', 'File::stat', 'POSIX', 'XML::RSS' }, # e.g., Module::Name => 1.1
    ($] >= 5.005 ?     ## Add these new keywords supported since 5.005
      (ABSTRACT       => 'Create Moral Maze podcast - BBC Radio 4', 
       AUTHOR         => 'James Telford <james@tefd.co.uk>') : ()),
       EXE_FILES         => [ 'scripts/podmaze.pl' ],
);