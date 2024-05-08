# Shebang line
#!/usr/bin/perl

# Importing modules for printing strict and warnings
use strict;
use warnings;

# Setting UTF-8 encoding
use open qw(:std :utf8);

# Changing separator to undef
local $/ = undef;

# Reading standart input
my $text = <STDIN>;

# Defining frequency treshold for keywords (https://stackoverflow.com/questions/361752/how-can-i-pass-command-line-arguments-to-a-perl-program)
my $frequency_threshold = $ARGV[0]; 

# Extract words from the text and store them in an array (https://stackoverflow.com/questions/66495616/perlscript-to-take-certain-words-from-text-file)
my @words = $text =~ /(\w+)/g;

# Changing all words to lowercase
foreach my $word (@words) {
    $word = lc $word;
}

# Importing stopwords data file (https://github.com/stopwords-iso/stopwords-cs/blob/master/stopwords-cs.txt)
my @stopwords;
open my $stopwords_file, '<', 'stopwords-cs.txt' or die "Cannot open stopwords-cs.txt: $!";

@stopwords = split(/\s+/, <$stopwords_file>);
my %stopwords_hash = map { $_ => 1 } @stopwords;

# Filtering out stopwords and numbers from the extracted words
my @filt_words = grep { !$stopwords_hash{$_} && !/\d/ } @words;

# Counting frequency of appearance of each filtered keyword in the text
my %word_counter;
foreach my $word (@filt_words) {
    $word_counter{$word}++;
}

# Sorting the filtered keywords by their frequency of appearance in the text (https://stackoverflow.com/questions/4519979/how-do-i-sort-by-frequency-of-a-value)
my @sorted_words = sort { $word_counter{$b} <=> $word_counter{$a} } keys %word_counter;

# Additional filtering of the keywords by teir appearance more than N times (defined by $frequency_threshold) in the text (this number depends on the size of the text mainly)
my @keywords = grep { $word_counter{$_} > $frequency_threshold } @sorted_words;

# Print the keywords
foreach my $keyword (@keywords) {
    print "$keyword\n";
}