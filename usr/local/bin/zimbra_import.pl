#!/usr/bin/perl -w

# This script will import the following into the destination email folder for the zimbra email account
#  - .eml rfc822 messages
#  - .msg outlook messages
#  - .vcf contacts

use POSIX 'strftime';
use File::Basename;
use Getopt::Long qw(GetOptions);

my $usage = <<END;
Usage: $0 source-dir dest-dir email type[eml|msg|vcf]
	Options:
    --log-date-format strftime compatible format e.g. '%Y-%m-%d %H:%M:%S'
    --search find iname paramater e.g. "*.eml" or "" for all files
END

if (@ARGV < 3) {
    print $usage;
    exit 1
}

my $date_format = '%Y-%m-%d %H:%M:%S';
my $zimbra_home = '/opt/zimbra';
my $search = '*.eml';

GetOptions(
    'log-date-format=s' => \$date_format,
    'zimbra-home=s' => \$zimbra_home,
    'search=s' => \$search,
);

$zimbra_home =~ s/\/$//g;

if (!-e "$zimbra_home/bin/zmmailbox") {
	print "zimbra-home: could not find $zimbra_home/bin/zmmailbox\n";
	exit(1);
}

my $source_dir = $ARGV[0];
my $dest_dir = $ARGV[1];
my $email = $ARGV[2];
my $type = $ARGV[3];

my $path = '';

foreach $file (split (/\n/,  `find "$source_dir" -type f -iname "$search"`)) {
  chomp($file);
  $pass = 1;

  # skip directories
  next unless -f $file;

  # TODO: create folders if they don't exist
  $path = dirname($file);
  $path =~ s{$source_dir/}{}g;
  $path = "$dest_dir/$path";
  if ($path =~ /^\.$/) {
    next;
  }

  #TODO: put the eml import into a function, msg import and vcf import and switch $type here

  #print "$file";
  #print "$dest_dir";

  #print "dest: $dest_dir/$path \n";

  # echo getFolder Archives/Testing | $zimbra_home/bin/zmmailbox -z -m charl@gexsa.ltd 2>&1 | grep -i 'unknown folder' | wc -l
  #print "echo getFolder $path | $zimbra_home/bin/zmmailbox -z -m $email 2>&1 | grep -i 'unknown folder' | wc -l" . "\n";
  $result = `echo getFolder $path | $zimbra_home/bin/zmmailbox -z -m $email 2>&1 | grep -i 'unknown folder'`;

  if ((chomp($result) + 0) > 0) {
    #print "echo createFolder $path | $zimbra_home/bin/zmmailbox -z -m $email' | wc -l" . "\n";
    $result = `echo createFolder $path | $zimbra_home/bin/zmmailbox -z -m $email`;
		if ($? != 0) {
			$pass = 0;
			my $date = strftime $date_format, localtime;
      print $date . ',ERROR,createFolder,' . $result . "\n";
		}

    next;
  }

  #print "echo addMessage $path '$file'\n";
  $result = `echo addMessage "'$path'" "'$file'" | $zimbra_home/bin/zmmailbox -z -m "$email"`;
  if ($? != 0) {
    $pass = 0;
		my $date = strftime $date_format, localtime;
		print $date ',ERROR,addMessage,' . $result . "\n";
  }

  if ($pass != 0) {
		my $date = strftime $date_format, localtime;
  	print $date . ',' . $file . ',OK' . "\n";
  } else {
		my $date = strftime $date_format, localtime;
  	print $date . ',' . $file . ',FAIL' . "\n";
  }
}

