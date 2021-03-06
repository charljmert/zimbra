#!/usr/bin/perl -w

# This script will convert all msg files to eml

use POSIX 'strftime';
use File::Basename;
use Getopt::Long qw(GetOptions);

my $usage = <<END;
Usage: $0 source-dir
    Options:
    --dest-dir optional destination directory to copy eml files to
    --msgconvert-bin full path to the msgconvert script e.g. /usr/sbin/msgconvert
    --log-date-format strftime compatible format e.g. '%Y-%m-%d %H:%M:%S'
    --search find iname paramater e.g. "*.eml" or "" for all files
END

if (@ARGV < 1) {
    print $usage;
    exit 1
}

my $date_format = '%Y-%m-%d %H:%M:%S';
my $search = '*.msg';
my $msgconvert_bin = '/usr/local/bin/msgconvert';
my $dest_dir = '';

GetOptions(
    'log-date-format=s' => \$date_format,
    'msgconvert-bin=s' => \$date_format,
    'search=s' => \$search,
    'dest-dir=s' => \$dest_dir,
);

if (!-e "$msgconvert_bin") {
	print "msgconvert: could not find msgconvert: $msgconvert_bin\n";
	exit(1);
}

my $source_dir = $ARGV[0];

my $path = '';

foreach $file (split (/\n/,  `find "$source_dir" -type f -iname "$search"`)) {
  chomp($file);
  $pass = 1;

  # skip directories
  next unless -f $file;

  $path = dirname($file);
  $path =~ s{$source_dir/}{}g;
  if ($path =~ /^\.$/) {
    next;
  }

  #print $path . "\n";

  #print "$msgconvert_bin '$file'\n";
  $result = `$msgconvert_bin '$file'`;
  if ($? != 0) {
    $pass = 0;
	my $date = strftime $date_format, localtime;
	print $date ",ERROR,$msgconvert_bin '$file'," . $result . "\n";
  }

  my $file_eml = basename($file);
  $file_eml =~ s/\.msg/.eml/g;

  #print "mv '$file_eml' '$path'\n";
  $result = `mv '$file_eml' '$path'`;
  if ($? != 0) {
    $pass = 0;
	my $date = strftime $date_format, localtime;
	print $date ",ERROR,mv '$file_eml' '$path'," . $result . "\n";
  }

  if ($pass != 0) {
	my $date = strftime $date_format, localtime;
  	print $date . ',' . $file . ',OK' . "\n";
  } else {
	my $date = strftime $date_format, localtime;
  	print $date . ',' . $file . ',FAIL' . "\n";
  }

}
