# proc
<h1 align="center">Работа с процессами</h1>
<h3 class="western"><a name="_heading=h.h6i87lkp3f19"></a> <span style="font-family: Roboto, serif;"><span style="font-size: small;">Описание домашнего задания</span></span></h3>
<ol>
<li>Написать свою реализацию ps ax, используя анализ /proc</li>
</ol>
<ul>
<li>Результат ДЗ - рабочий скрипт, который можно запустить</li>
</ul>
<h3 class="western"><a name="_heading=h.df570rpzx1qg"></a><span style="font-family: Roboto, serif;"><span style="font-size: small;">Используемые ОС</span></span></h3>
<p style="line-height: 108%; margin-bottom: 0.28cm;" align="justify"><span style="font-family: Roboto, serif;">Хостовая ОС: Ubuntu 24.04 Desktop. Виртуальные машины для этого задания не требуются.</p>
<h3 class="western"><span style="font-family: Roboto, serif;"><span style="font-size: small;">Выполнение</span></span></h3>
<p>Посмотрим вывод команды <code>ps ax</code>. Часть вывода:</p>
<img width="642" height="270" alt="image" src="https://github.com/user-attachments/assets/4a812cee-e665-40a1-a3ca-aeac9f95c7be" />
<p>&nbsp;</p>
<p>Видим, что выводится 5 столбцов:</p>
<p>PID&nbsp; &nbsp;TTY&nbsp; &nbsp;STAT&nbsp; &nbsp;TIME&nbsp; &nbsp;COMMAND</p>
<p>Для теста запустим на соседнем терминале команду<br /><code>sudo tail -f /var/log/dmesg</code><br />и узнаем PID запущенной команды<br /><code>ps ax | grep "sudo tail -f"</code></p>
<img width="1627" height="337" alt="image" src="https://github.com/user-attachments/assets/61806d1e-3b28-40a5-a447-9e266874d726" />
<p>&nbsp;</p>
<p>Посмотрим содержимое файла&nbsp;<code>/proc/20129/stat</code></p>
<img width="809" height="120" alt="image" src="https://github.com/user-attachments/assets/e8f939e8-96b2-4647-aba1-0c618eeb80c1" />
<p>&nbsp;</p>
<p>Смотрим мануал по структуре файлов proc/pid/stat:&nbsp;<code><a href="https://manpages.ubuntu.com/manpages/questing/ru/man5/proc_pid_stat.5.html">https://manpages.ubuntu.com/manpages/questing/ru/man5/proc_pid_stat.5.html</a></code></p>
<p>Из нужного нам это pid (поле 1), state (поле 3), tty_nr (поле 7), utime (поле 14), stime (поле 15)</p>
<p>Для поля&nbsp;<strong>PID</strong>&nbsp;используем команду&nbsp;<code>cat /proc/20129/stat | awk '{ print $1 }'</code><br />Вывод:</p>
<img width="681" height="84" alt="image" src="https://github.com/user-attachments/assets/f84ddcf2-64b8-4c0e-b476-f59232147d38" />
<p>&nbsp;</p>
<p>Будем записывать это значение в переменную v_PID. Строка для скрипта будет такой:</p>
<div class="snippet-clipboard-content notranslate position-relative overflow-auto">
<pre class="notranslate"><code> v_PID=`cat /proc/20129/stat | awk '{ print $1 }'`</code></pre>
</div>
<p>20129 - конкретный PID (надо будет в цикле пройти по всем PID).</p>
<p><span class="T286Pc" data-processed="true">Команда для вывода всех PID из директории /proc:&nbsp;<code>ls -l /proc | awk '{ print $9 }' | grep -Eo '[0-9]{1,4}'| sort -n | uniq</code><br />Из вывода&nbsp;ls -l&nbsp;отбираем только 9 поле с наименованием и оттуда отбираем только уникальные наименования из цифр. Частичный вывод:</span></p>
<p dir="auto">shirokovpv@SPB300:~/proc$ ls -l /proc | awk '{ print $9 }' | grep -Eo '[0-9]{1,4}'| sort -n | uniq<br />0<br />1<br />2<br />3<br />4<br />5<br />6<br />7<br />8<br />9<br />10<br />13<br />14</p>
<p dir="auto">...</p>
<p dir="auto">5701<br />5711<br />5750<br />5936<br />6297<br />6304<br />6504<br />6715<br />6855<br />6862<br />6902<br />6940<br />6952<br />6955<br />6958<br />6961<br />7031<br />7088<br />7231<br />7310<br />7500<br />7609<br />shirokovpv@SPB300:~/proc$</p>
<p dir="auto">&nbsp;</p>
<p>Поле&nbsp;<strong>TTY</strong>&nbsp;можно найти, используя команду&nbsp;<code>cat /proc/20129/stat | awk '{ print $7 }'</code></p>
<img width="681" height="76" alt="image" src="https://github.com/user-attachments/assets/7ba4a767-022b-4fb2-b7e0-139bf5d67f45" />
<p>&nbsp;</p>
<p>Однако, здесь TTY отображается в виде числового идентификатора, который затем нужно будет преобразовать, например, с помощью функции&nbsp;<code class="o8j0Mc">tty_name()</code>. Это в программах. В нашем случае проще использовать команду&nbsp;<code class="o8j0Mc">ps -p &lt;PID&gt; -o tty</code>&nbsp;для получения имени TTY напрямую. Мы же знаем PID.<span class="" data-wiz-rootname="ohfaMd"><span class="vKEkVd" data-animation-atomic="">&nbsp;Будем использовать команду&nbsp;&nbsp;<code class="o8j0Mc">ps -p &lt;PID&gt; -o tty</code>. Можно протестировать:</span></span></p>
<img width="432" height="183" alt="image" src="https://github.com/user-attachments/assets/96803b7f-54fe-43ce-9645-7dc16c400608" />
<p>&nbsp;</p>
<p>Запишем значение в переменную v_TTY, строка будет такой:</p>
<p><code>v_TTY=`ps -p 20129 -o tty`</code></p>
<p>Первые 3 символа нам не нужны, их можно будет обрезать:</p>
<img width="432" height="185" alt="image" src="https://github.com/user-attachments/assets/81819dc7-4d36-4d5c-beca-111e515cd2b6" />
<p>&nbsp;</p>
<p dir="auto">Для поля&nbsp;<strong>STAT</strong>&nbsp;используем команду&nbsp;<code>cat /proc/20129/stat | awk '{ print $3 }'</code><br />Вывод:</p>
<div class="snippet-clipboard-content notranslate position-relative overflow-auto">&nbsp;</div>
<img width="681" height="76" alt="image" src="https://github.com/user-attachments/assets/dadbb6fb-f547-47c5-adb4-fcf945d94e56" />
<p>&nbsp;</p>
<p dir="auto">Запишем в переменную v_STAT:</p>
<div class="snippet-clipboard-content notranslate position-relative overflow-auto">
<code>v_STAT=`cat /proc/20129/stat | awk '{ print $3 }'`</code>
</div>
<p dir="auto">&nbsp;</p>
<p dir="auto">Для поля&nbsp;<strong>TIME</strong>&nbsp;нужно сложить поля&nbsp;<strong>UTIME</strong>&nbsp;(Количество времени, которые данный процесс провел в режиме пользователя) и&nbsp;<strong>STIME</strong>&nbsp;(Количество времени, которые данный процесс провел в режиме ядра) и поделить их на значение переменной ядра&nbsp;<strong>CLK_TCK</strong>. Переменную <strong>CLK_TCK</strong> можно узнать командой&nbsp;<code>getconf CLK_TCK</code>. Запишем результат в переменную v_TIME.</p>
<pre class="notranslate"><code>v_UTIME=`cat /proc/20129/stat | awk '{ print $14 }'`
v_STIME=`cat /proc/20129/stat | awk '{ print $15 }'`
v_CLKTCK=`getconf CLK_TCK`
v_FULLTIME=$((v_UTIME+v_STIME))
v_CPUTIME=$((v_FULLTIME/v_CLKTCK))
v_TIME=`date -u -d @${v_CPUTIME} +"%T"`</code></pre>
<p dir="auto">&nbsp;</p>
<p dir="auto">Поле&nbsp;<strong>COMMAND</strong>&nbsp;можно узнать командой&nbsp;<code>cat /proc/20129/cmdline | strings -n 1 | tr '\n' ' '</code>&nbsp;Вывод:</p>
<div class="snippet-clipboard-content notranslate position-relative overflow-auto">&nbsp;</div>
<img width="807" height="52" alt="image" src="https://github.com/user-attachments/assets/4c9a1b65-4149-4b7a-860d-a33f0aa8fd69" />
<p>&nbsp;</p>
<p dir="auto">В некоторых случаях поле может быть пустым, тогда возьмем команду из файла /proc/5184/stat (поле 2)</p>
<p dir="auto">Запишем в переменную v_COMMAND</p>
<pre class="notranslate"><code>v_COMMAND=`cat /proc/20129/cmdline | strings -n 1 | tr '\n' ' '`
   if [[ -z $v_COMMAND]]; then v_COMMAND=`cat /proc/20129/stat | awk '{ print $2 }'</code></pre>
<p dir="auto">Итоговый скрипт:</p>
<pre class="notranslate">#!/bin/bash<br />echo "PID TTY STAT TIME COMMAND" # выведем заголовок<br />for ITEM in `ls -l /proc | awk '{ print $9 }' | grep -Eo '[0-9]{1,4}'| sort -n | uniq`<br />do<br />if [ -d /proc/$ITEM/ ]; then # дополнительное условие проверки существования процесса<br /> v_PID=`cat /proc/$ITEM/stat | awk '{ print $1 }'`<br /> v_TTY=`ps -p $ITEM -o tty`<br /> v_STAT=`cat /proc/$ITEM/stat | awk '{ print $3 }'`<br /> v_UTIME=`cat /proc/$ITEM/stat | awk '{ print $14 }'`<br /> v_STIME=`cat /proc/$ITEM/stat | awk '{ print $15 }'`<br /> v_CLKTCK=`getconf CLK_TCK`<br /> v_FULLTIME=$((v_UTIME+v_STIME))<br /> v_CPUTIME=$((v_FULLTIME/v_CLKTCK))<br /> v_TIME=`date -u -d @${v_CPUTIME} +"%T"`<br /><br /> v_COMMAND=`cat /proc/$ITEM/cmdline | strings -n 1 | tr '\n' ' '`<br /> if [[ -z $v_COMMAND ]]; then v_COMMAND=`cat /proc/$ITEM/stat | awk '{ print $2 }'`; fi<br /><br /> echo "$v_PID ${v_TTY:3} $v_STAT $v_TIME $v_COMMAND"<br />fi<br />done</pre>
