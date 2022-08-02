<?php
$fp = @fsockopen ("localhost", 80, $errno, $errstr, 10);
if (!$fp) {
echo "$errstr ($errno)
\n";
}else
{
echo "fsockopen Is Working Perfectly.";
}
fclose ($fp);

?>