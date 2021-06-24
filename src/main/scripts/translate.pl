use File::Find;

($ME = $0) =~ s#.*/##; 

%keys;

# Use English bundle and merge with "other bundle" to create a new starting point for
# that language.  Any keys found in the "other" are kept otherwise the English version
# is used to start the translations.

$english = "/home/dbm/dev/openhospital-gui/bundle/language_en.properties";
$other = "/home/dbm/dev/openhospital-gui/bundle/language_zh_CN.properties";
$newOther = "/home/dbm/dev/openhospital-gui/bundle/XXX.properties";

open(OTHER, "< $other")
    || die "cannot open $other";
while (<OTHER>) {
    next if /^#/o;
    chop;
    if (/^(.+?)\s+=(.*)/) {
        $s = $1;
        $end = $2;
        $s =~ s/\s+$//; # trim trailing spaces
        $end =~ s/^\s+|\s+$//g;  # trim leading and trailing spaces
        ####print ">>$s....$end<<\n";
        $keys{$s} = $end;
    }
}
close(OTHER);

open(NEWOTHER, "> $newOther")
    || die "cannot open $newOther";
open(ENGLISH, "< $english")
    || die "cannot open $english";
while (<ENGLISH>) {
    chop;
    if (/^(.+?\s+)=.*/) {
        $s = $1;
        $strailing = $s;
        $s =~ s/\s+$//; # trim trailing spaces
        ###print "**$s**\n";
        if (exists($keys{$s})) {
            print NEWOTHER "$strailing= $keys{$s}\n";
        }
        else {
            ## remove suffix
            $pos = rindex($s, ".");
            $newS = substr($s, 0, $pos);
            print ">>> $newS\n";
            if (exists($keys{$newS}) && $newS != "angal.medicalstockward.rectify") {
                print NEWOTHER "$strailing= $keys{$newS}\n";
            }
            else {
                print NEWOTHER "$_\n";
            }
        }
    }
    else {
        print NEWOTHER "$_\n";
    }
}
close(ENGLISH);
close(NEWOTHER);
