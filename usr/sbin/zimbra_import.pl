#!/usr/bin/perl -w

use File::Basename;

my $inbox = $ARGV[0];
my $email = $ARGV[1];
my $path = '';

foreach $file ( <STDIN> ) {
  chomp($file);

  # skip directories
  next unless -f $file;

  # TODO: create folders if they don't exist
  $path = dirname($file);
  if ($path =~ /^\.$/) {
    next;
  }
  #print "$file";
  #print "$inbox";

  print "$inbox/$path \n";

  # echo getFolder Archives/Testing | /opt/zimbra/bin/zmmailbox -z -m charl@gexsa.ltd 2>&1 | grep -i 'unknown folder' | wc -l
  #print "echo getFolder $inbox/$path | /opt/zimbra/bin/zmmailbox -z -m $email 2>&1 | grep -i 'unknown folder' | wc -l" . "\n";
  $result = `echo getFolder $inbox/$path | /opt/zimbra/bin/zmmailbox -z -m $email 2>&1 | grep -i 'unknown folder'`;

  if ((chomp($result) + 0) > 0) {
    #print "echo createFolder $inbox/$path | /opt/zimbra/bin/zmmailbox -z -m $email' | wc -l" . "\n";
    $result = `echo createFolder $inbox/$path | /opt/zimbra/bin/zmmailbox -z -m $email`;

    next;
  }

  print "echo addMessage $inbox/$path '$file'\n";
  $result = `echo addMessage "'$inbox/$path'" "'$file'" | /opt/zimbra/bin/zmmailbox -z -m "$email"`;

  print $result;
}
