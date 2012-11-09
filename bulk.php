<?php

/**
 * Quick script to generate a bulk import file
 *
 * Set $CFG->noemailever = true;
 *
 * in your config.php to avoid spamming with emails
 */
$num_rows = 10000;
global $word_file;
$word_file = '/etc/dictionaries-common/words';
$output_file = 'bulk.txt';

// write header row
$header = "firstname,lastname,username,email,profile_field_check,profile_field_text,profile_field_area,profile_field_num\n";
file_put_contents($output_file, $header);

for($i = 1; $i <= $num_rows; $i++) {
    $row = '';
    $row .= "First{$i},Last{$i},username{$i},email{$i}@example.com,";
    $row .= rand(0, 1) . ',' . random_words() . ',' . random_words(rand(50,1500)) . ',' . round(rand(1,1000) / 100, 2) . "\n";
    file_put_contents($output_file, $row, FILE_APPEND);
}

/**
 * Returns a number of random words
 *
 * @param integer $number Number of words to return (default 1)
 */
function random_words($number = 1) {
    global $word_file;
    static $words;
    $words = file($word_file);

    if ($number == 1) {
        return trim($words[array_rand($words)]);
    } else {
        $chosen_words = array();
        $chosen_word_keys = array_rand($words, $number);
        foreach ($chosen_word_keys as $key) {
            $chosen_words[] = trim($words[$key]);
        }
        return implode(' ', $chosen_words);
    }
}
