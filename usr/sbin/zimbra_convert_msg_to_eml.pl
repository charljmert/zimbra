#!/usr/bin/perl -w

use File::Basename;

#my $inbox = $ARGV[0];
#my $email = $ARGV[1];
#my $path = '';

foreach $file ( <STDIN> ) {
  chomp($file);

  # skip directories
  next unless -f $file;

  # TODO: create folders if they don't exist
  $filename = basename($file);
  $path = dirname($file);
  if ($path =~ /^\.$/) {
    next;
  }

  #print "$file";
  #print "$path";
  #exit;

  print "msgconvert '$file'\n";
  $result = `msgconvert '$file'`;
  print $result;

  #print "mv '$filename.eml' '$path'\n";
  $result = `mv '$filename.eml' '$path'`;
}
