use File::Find;

($ME = $0) =~ s#.*/##; 

%keys;


########################################################################
# Go through each GUI java file looking for resource strings
########################################################################
$dir = "/home/dbm/dev/openhospital-gui/src/main/java/org/isf";

$arrRefTxtFiles = doReadDirGetFilesByExtension($dir, 'java');

foreach $file (@$arrRefTxtFiles) {
    open(INFILE, "< $file")
        || die "open of $file failed";
    foreach $line (<INFILE>) {
        while ($line =~ /MessageBundle\.(get|format)Message\("([a-zA-Z0-9\.]*)"\)/o) {
            $end = $+[1];
            ####print "Found $file $1\n";
            $line = substr($line, $end + 1);
            $keys{$2} = 1;
             ####print "Line: $line\n";
        }
    }
    close(INFILE);

    open(INFILE, "< $file")
        || die "open of $file failed";
    foreach $line (<INFILE>) {
        while ($line =~ /MessageBundle\.getMnemonic\("([a-zA-Z0-9\.]*)"\)/o) {
            $end = $+[1];
            ####print "Found $file $1\n";
            $line = substr($line, $end + 1);
            $keys{$1} = 1;
            ####print "Line: $line\n";
        }
    }
    close(INFILE);

    open(INFILE, "< $file")
        || die "open of $file failed";
    foreach $line (<INFILE>) {
        while ($line =~ /"(angal[a-zA-Z0-9\.]*)"/o) {
            $end = $+[1];
            ####print "Found $file $1\n";
            $line = substr($line, $end + 1);
            $keys{$1} = 1;
            ####print "Line: $line\n";
        }
    }
    close(INFILE);

    #### Special case
    if ($file =~ /ReportLauncher.java$/) {
        open(INFILE, "< $file")
            || die "open of $file failed";
        foreach $line (<INFILE>) {
            #   {"angal.stat.registeredpatient", 	"OH001_RegisteredPatients", 	"twodates"},
            while ($line =~ /.*{"(angal[a-zA-Z0-9\.]*)",.*/o) {
                ####print "..... $1\n";
                $end = $+[1];
                $line = substr($line, $end + 1);
                $keys{$2} = 1;
            }
        }
        close(INFILE);
    }
    #### Special case
    if ($file =~ /PrivilegeTree.java$/) {
        open(INFILE, "< $file")
            || die "open of $file failed";
        foreach $line (<INFILE>) {
            # new UserMenuItem("main", "angal.menu.menuitemmainmenu", "angal.menu.menuitemmainmenu", "",
            while ($line =~ /.*"(angal[a-zA-Z0-9\.]*)",*/o) {
                #print "..... $1\n";
                $end = $+[1];
                $line = substr($line, $end + 1);
                $keys{$1} = 1;
            }
        }
        close(INFILE);
    }
}

########################################################################
# Go through each GUI jrxml file looking for resource strings
#
# NOTE: Found out that jrxml files have their own <filename_jrxml>*.properties in the same folder
#
########################################################################
#$dir = "/home/dbm/dev/openhospital-gui/rpt";
#
#$arrRefTxtFiles = doReadDirGetFilesByExtension($dir, 'jrxml');
#
#foreach $file (@$arrRefTxtFiles) {
#    open(INFILE, "< $file")
#        || die "open of $file failed";
#    foreach $line (<INFILE>) {
#	# class="java.lang.String"><![CDATA[$P{REPORT_RESOURCE_BUNDLE}.getString( "angal.report.patientbillextendedtxt.patn" ) + $F{BLL_ID_PAT}
#	# class="java.lang.String"><![CDATA[$P{REPORT_RESOURCE_BUNDLE}.getString( "angal.report.billsreportuserallindate.total" )]]
#	# class="java.lang.String"><![CDATA[$P{REPORT_RESOURCE_BUNDLE}.getString( "angal.report.patientbillextendedtxt.patn" )
#	while ($line =~ /{REPORT_RESOURCE_BUNDLE}.getString\(\s*"([a-zA-Z0-9\.]*)"\s*\)/o) {
#	    $end = $+[1];
#	    ###0print "Found $file $1\n";
#   	    $line = substr($line, $end + 1);
#	    $keys{$1} = 1;
#	    ###print "Line: $line\n";
#	}
#    }
#    close(INFILE);
#}

########################################################################
# Go through each CORE java file looking for resource strings
########################################################################
$dir = "/home/dbm/dev/openhospital-core/src/main/java/org/isf";

$arrRefTxtFiles = doReadDirGetFilesByExtension($dir, 'java');

foreach $file (@$arrRefTxtFiles) {
    open(INFILE, "< $file")
        || die "open of $file failed";
    foreach $line (<INFILE>) {
        while ($line =~ /MessageBundle\.(get|format)Message\("([a-zA-Z0-9\.]*)"\)/o) {
            $end = $+[1];
            ###print "Found $file $1\n";
            $line = substr($line, $end + 1);
            $keys{$2} = 1;
            ###print "Line: $line\n";
        }
    }
    close(INFILE);

    open(INFILE, "< $file")
        || die "open of $file failed";
    foreach $line (<INFILE>) {
        while ($line =~ /"(angal[a-zA-Z0-9\.]*)"/o) {
            $end = $+[1];
            ####print "Found $file $1\n";
            $line = substr($line, $end + 1);
            $keys{$1} = 1;
            ####print "Line: $line\n";
        }
    }
    close(INFILE);
}

########################################################################
# Go through each CORE sql file looking for resource strings
########################################################################
$dir = "/home/dbm/dev/openhospital-core/mysql/db";

$arrRefTxtFiles = doReadDirGetFilesByExtension($dir, 'sql');

foreach $file (@$arrRefTxtFiles) {
    open(INFILE, "< $file")
        || die "open of $file failed";
    foreach $line (<INFILE>) {
        # MNI_BTN_LABEL='angal.menu.btn.help', MNI_LABEL='angal.menu.help' WHERE MNI_ID_A='help';
        # INSERT INTO `agetype` VALUES ('d0',0,0,'angal.agetype.newborn',NULL,NULL,NULL,NULL,1);
        while ($line =~ /'(angal\.[a-zA-Z0-9\.]*)'/o) {
            $end = $+[1];
            ####print "Found $file $1\n";
            $line = substr($line, $end + 1);
            $keys{$1} = 1;
            ###print "Line: $line\n";
        }
    }
    close(INFILE);
}

########################################################################
# Now go through all property files and see if we can find anything
# that is not in the table; these are suspect        
########################################################################
print "Keys not Used\n";
print "===============\n\n";

@PROPS = (
    "/home/dbm/dev/openhospital-gui/bundle/language_en.properties"
    );

foreach $file (@PROPS) {
    open(PROP, "< $file")
        || die "cannot open $file";
    while (<PROP>) {
        if (/^# Key\/values used in sql files/) {
            last;
        }
        next if /^#/o;
        chop;
        if (/^(.+?)\s+=.*/) {
            $s = $1;
            $s =~ s/\s+$//; # trim trailing spaces
	        ### print ">>$s<<\n";
            if ($keys{$s} ne 1) {
                print "$s\n";
            }
            $keys{$s} = 99;
        }
    }
    close(PROP);
}

print "\n\nStrings not found in language_en.properties\n";
print "===========================================\n\n";

foreach $key (keys %keys)
{
    if ($keys{$key} eq 1) {
	print "$key\n";
    }
}

# -----------------------------------------------------------------------------
# Read directory recursively and return only the files matching the regex
# for the file extension. Example: Get all the .pl or .pm files:
#     my $arrRefTxtFiles = doReadDirGetFilesByExtension ($dir, 'pl|pm')
# -----------------------------------------------------------------------------
sub doReadDirGetFilesByExtension {
     my $dir  = shift;
     my $ext  = shift;

     my @arr_files = ();
     # File::find accepts ONLY single function call, without params, hence:
     find(wrapper_wanted_call(\&filter_file_with_ext, $ext, \@arr_files), $dir);

     return \@arr_files;
}

# -----------------------------------------------------------------------------
# Return only the file with the passed extensions
# -----------------------------------------------------------------------------
sub filter_file_with_ext {
    my $ext     = shift;
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
