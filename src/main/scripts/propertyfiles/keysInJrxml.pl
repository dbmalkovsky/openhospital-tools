use File::Find;

($ME = $0) =~ s#.*/##;

%keys;


########################################################################
# Go through each GUI java file looking for resource strings
########################################################################
$dir = "/home/dbm/dev/openhospital-gui/rpt";

$arrRefTxtFiles = doReadDirGetFilesByExtension($dir, 'jrxml');

foreach $file (@$arrRefTxtFiles) {
    #####print "File:  $file\n";
    $root = substr($file, 0, -5);
    $props = $root . "properties";
    open(INFILE, "< $file")
        || die "open of $file failed";
    foreach $line (<INFILE>) {
        ####print "!!!!!! $line";
        if ($line =~ /R\{([a-zA-Z0-9\.]*)\}/o) {
            $end = $+[1];
            ####print "Found $file $1\n";
            $key = $1;
            open(PROPFILE, "< $props")
                || die "open of $file failed";
            $found = 0;
            foreach $propLine (<PROPFILE>) {
                ####print "xxxxxx $propLine";
                if ($propLine =~ /^$key /) {
                    $found = 1;
                    last;
                }
                if ($propLine =~ /^$key=/) {
                    $found = 1;
                    last;
                }
            }
            if ($found == 1) {
                ####print "Found $key\n";
            }
            else {
                print "ERROR: KEY NOT FOUND $key in $file\n";
            }
            close(PROPFILE);
        }
    }
    close(INFILE);
}
exit;

# -----------------------------------------------------------------------------
# Read directory recursively and return only the files matching the regex
# for the file extension. Example: Get all the .pl or .pm files:
#     my $arrRefTxtFiles = doReadDirGetFilesByExtension ($dir, 'pl|pm')
# -----------------------------------------------------------------------------
sub doReadDirGetFilesByExtension {
    my $dir = shift;
    my $ext = shift;

    my @arr_files = ();
    # File::find accepts ONLY single function call, without params, hence:
    find(wrapper_wanted_call(\&filter_file_with_ext, $ext, \@arr_files), $dir);

    return \@arr_files;
}

# -----------------------------------------------------------------------------
# Return only the file with the passed extensions
# -----------------------------------------------------------------------------
sub filter_file_with_ext {
    my $ext = shift;
    my $arr_ref_files = shift;

    my $F = $File::Find::name;

    # Fill into the array behind the array reference any file matching
    # the ext regex.
    push @$arr_ref_files, $F if (-f $F and $F =~ /^.*\.$ext$/);
}

# -----------------------------------------------------------------------------
# The wrapper around the wanted function
# -----------------------------------------------------------------------------
sub wrapper_wanted_call {
    my ($function, $param1, $param2) = @_;

    sub {
        $function->($param1, $param2);
    }
}
