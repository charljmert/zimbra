#!/usr/bin/perl -w

my $inboxEmail = $ARGV[0];
my $vCardFile = $ARGV[1];

foreach $file ( <STDIN> ) {
  chomp($file);
  print "$file\n";

  $vCardFile = $file;

	$result = `cat "$vCardFile" | grep -iP '^EMAIL:'`;
	$result =~ s/EMAIL://g;
	my $email = $result;
  chomp($email);

	$result = `cat "$vCardFile" | grep -iP '^N:'`;
	$result =~ s/^N://g;
	print $result . "\n";
	my @parts = split(/;/, $result);
	my $firstName = $parts[1];
	my $lastName = $parts[0];
  chomp($firstName);
  chomp($lastName);

	print 'adding email[' . $email .'], firstName[' . $firstName . '], lastName[' . $lastName . "]\n";

	$result = `/opt/zimbra/bin/zmmailbox -z -m $inboxEmail cct email "$email" firstName "$firstName" lastName "$lastName"`;

}
