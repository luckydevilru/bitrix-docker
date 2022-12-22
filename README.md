# bitrix-docker
PHP Apache nginx PHPStorm xDebug localhost for bitrix bitrix24 development

## Инструкция (для windows)
Выполнить в консоли:
`git clone https://github.com/luckydevilru/windock.git`

`cd windock`

Скопировать из src в www содержимое папки

потом:
`docker-compose up -d --build`


в hosts прописать 

127.0.0.1 bx.doc

в папке windock/www создать дочернюю bx.doc (или localhost)

залить в bx.doc сайт или тестовый скрипт для битрикс из папки windock/src
