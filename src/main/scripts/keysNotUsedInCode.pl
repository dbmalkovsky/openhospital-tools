use File::Find;
use File::Next;

($ME = $0) =~ s#.*/##; 


########################################################################
# 
########################################################################
$dirGUI  = "/home/dbm/dev/openhospital-gui";
$dirCore = "/home/dbm/dev/openhospital-core";

$propsList = "/home/dbm/dev/openhospital-tools/src/main/logs/propertiesKeysNotUsed.txt";

open(PROPS, "<$propsList")
        || die "open of $propsList failed";

#foreach $file (@$arrRefTxtFiles) {
#    open(INFILE, "< $file")
#        || die "open of $file failed";
#    foreach $line (<INFILE>) {
#	while ($line =~ /MessageBundle\.getMessage\("([a-zA-Z0-9\.]*)"\)/o) {
#	    $end = $+[1];
#	    ###print "Found $file $1\n";
#    	    $line = substr($line, $end + 1);
#	    ###print "Line: $line\n";
#	}
#    }
#    close(INFILE);
#}

foreach $propLine (<PROPS>) {

    chomp($propLine);
    print "\n\n$propLine\n";
    
    my $iterator = File::Next::files( "$dirGUI" );

    while ( defined ( my $file = $iterator->() ) ) {
	next if $file =~ /\.git\//o;
	next if $file =~ /\.idea\//o;
	next if $file =~ /\.github\//o;
	next if $file =~ /\/target\//o;
	next if $file =~ /\/lib\//o;
	next if $file =~ /\.ide-settings\//o;
	next if $file =~ /png$/o;
	next if $file =~ /jpg$/o;
	next if $file =~ /JPG$/o;
	#print $file, "\n";

	open(INFILE, "<$file")
	    || die "open of $file failed";

	foreach $line (<INFILE>) {
	    # print $line;
	    if ($line =~ m/$propLine\b/ ) {
		print "$file\n";
	    }
	}
	close(INFILE);
    }
}

close(PROPS);

exit;



