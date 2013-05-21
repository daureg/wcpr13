#!/usr/bin/perl

# This script is used to generate word document matrices
# Not for commercial use.

# This script creates one vector for one file.
# You can create a loop within unix that handles
# all files one by one and directs the output
# to a file (remember to use >>).

# Usage:
# cat file.txt | ./calculate_WDM.perl -dictionary dict.lst
# where:
# -- file.txt contains the original text
# -- dict.lst contains the dictionary where each line contains
#    frequency word pairs
#
#    If you have only one word per line without any frequency
#    replace 	($count, $word) = split
#    by         ($word) = split
#    in the code

# Timo Honkela, 20 Feb 2006
# Timo Honkela, 06 Nov 2012
# Timo Honkela, 14 Feb 2013

use Getopt::Long;
GetOptions("dictionary=s" => \$dictionary);   # Parameter passing
                                              # to the program

$index = 1;                       # Initialization of the
                                  # index
if( $dictionary ) {
    open(INDEX, "< $dictionary"); # Open the dictionary file
                                  # INDEX: file handle
    while(<INDEX>) {              # Process each line of the dict.
	($count, $word) = split;  # Find the count and word in each line
	$indexer{ $word } = $index;   # Storing index numbers per word
	$wordifier{ $index } = $word; # Storing words per index
	$index++;                     # Incrementing the index
    }

    close(INDEX);    # Closing dictionary file
    $dictionary_entries = $index-1;  # Storing no of entries found

# Initialization of the word document matrix

    for( $dict_index = 1; $dict_index <= $dictionary_entries; $dict_index++ ) {
	$word_document_row[ $dict_index ] = 0;
    }
}

$variables = $dictionary_entries;
$document_word_sum = 0;
$content = 0;

while (<>) {    # Input from stdin
    s/[\[\]\{\}\^\~\!\"\#\%\&\/\(\)\=\?\,\•\.\-\;\:\_\*\`\|\<\>\$\+]/ /g;
    @line = split;
    foreach $word (@line) {     # process each word in the input line
	if( $indexer{ $word } ) {    # it input word found in the inded
	    $document_word_sum++;
	    $word_document_row[ $indexer{ $word } ] ++;  # add count by one
	}
    }

# printing out the results

    for( $dict_index = 1; $dict_index <= $dictionary_entries; $dict_index++ ) {
	$words = $word_document_row[ $dict_index ];
	print $words, " ";
    }
    print "\n";

    for( $dict_index = 1; $dict_index <= $dictionary_entries; $dict_index++ ) {
	$word_document_row[ $dict_index ] = 0;
    }
}

