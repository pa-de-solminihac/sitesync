<?php
// be quiet, dont mess everything
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 0);
ini_set('memory_limit', -1);
ini_set('max_execution_time', 0);
ini_set('log_errors', 0);
ini_set('error_log', '/dev/null');

// usage
if (empty($argv[1]) || empty($argv[2])) {
    file_put_contents('php://stderr', '
Usage: ' . $argv[0] . ' <search_pattern> <replace> [<file>]

Options:
    -i, --in-place
        edit file in place

    --regex
        treat <search_pattern> as a regex

    --only-into-serialized
        replace only into serialized data (do not replace into raw data)

');
    die();
}

// extract options
$options = array();
foreach ($argv as $key => $arg) {
    if (strpos($arg, '-') === 0) {
        $options[$arg] = 1;
        unset($argv[$key]);
    }
}
$argv = array_values($argv);
// option: -i, --in-place
if (!empty($options['-i']) || !empty($options['--in-place'])) {
    $tempnam = tempnam(dirname($filename), $filename . '-');
    $write_handle = fopen($tempnam, 'w');
}
// option: --regex
$use_regex = 0;
if (!empty($options['--regex'])) {
    $use_regex = 1;
}
// option: --only-into-serialized
$only_into_serialized = 0;
if (!empty($options['--only-into-serialized'])) {
    $only_into_serialized = 1;
}

// extract command line parameters
$search  = $argv[1];
if (!$use_regex) {
    $search = preg_quote($search);
}
$search = str_replace('/', '\/', $search);
$replace = $argv[2];
$content_from_stdin = 0;
$filename = '';
if (empty($argv[3])) {
    $content_from_stdin = 1;
} else {
    $filename = $argv[3];
}

// run
$buffer = '';
if ($content_from_stdin) {
    $handle = fopen('php://stdin', 'r');
} else {
    $handle = fopen($filename, 'r');
}
while(!feof($handle)) {
    $buffer = fgets($handle);
    $buffer = resilient_replace($search, $replace, $buffer, $only_into_serialized);
    if (!empty($options['-i'])) {
        fwrite($write_handle, $buffer);
    } else {
        echo $buffer;
    }
}
fclose($handle);
if (!empty($options['-i'])) {
    fclose($write_handle);
    rename($tempnam, $filename);
}

// function definition
function resilient_replace($search, $replace, $subject, $only_into_serialized = false) {
    $str = $subject;
    $replace_escaped = str_replace("'", "\\'", $replace);

    $delta = strlen($replace) - strlen(stripslashes($search));
    $str = preg_replace(
        '/s:(\d+):(\\\?)"(.*?)\\2";/e',
        "'s:' 
        . (intval('\\1', 10) + preg_match_all('/" . $search . "/', '\\3', \$dummy) * (" . $delta . ")) 
        . ':\\2\"' 
        . preg_replace('/" . $search . "/', '" . $replace_escaped . "', str_replace('\\\"', '\"', '\\3')) . '\\2\";'",
        $str);
    if (!$only_into_serialized) {
        // file_put_contents('php://stderr', 'replace into raw' . PHP_EOL);
        $str = preg_replace('/' . $search . '/', $replace, $str);
    }
    return $str;
}