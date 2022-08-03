<?
ini_set('error_reporting', E_ALL);
ini_set('display_errors', 1);
ini_set('display_startup_errors', 1);

echo rand();
 
if ( mail("prokh-sergey@ya.ru", "Загаловок", "Текст письма \n 1-ая строчка \n 2-ая строчка \n 3-ая строчка") ){
  echo 'mail sent';
}else{
  echo 'wt hell';
}
?>