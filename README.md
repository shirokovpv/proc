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
<p><span class="T286Pc" data-processed="true">Команда для вывода всех PID из директории /proc:&nbsp;<code>ls -l /proc | awk '{ print $9 }' | grep -Eo '[0-9]{1,4}'| sort -n | uniq</code><br />Из вывода&nbsp;ls -l&nbsp;отбираем только 9 поле с наименованием и оттуда отбираем только уникальные наименования из цифр.</span></p>
<p>Поле&nbsp;<strong>TTY</strong>&nbsp;можно найти, используя команду&nbsp;<code>cat /proc/20129/stat | awk '{ print $7 }'</code></p>
<img width="681" height="84" alt="image" <p>&nbsp;</p>src="https://github.com/user-attachments/assets/c76d22de-7c1f-490a-ac0b-d21645e1a0bb" />
<p>&nbsp;</p>
<p>Однако, здесь TTY отображается в виде числового идентификатора, который затем нужно будет преобразовать, например, с помощью функции&nbsp;<code class="o8j0Mc">tty_name()</code>. Это в программах. В нашем случае проще использовать команду&nbsp;<code class="o8j0Mc">ps -p &lt;PID&gt; -o tty</code>&nbsp;для получения имени TTY напрямую.<span class="" data-wiz-rootname="ohfaMd"><span class="vKEkVd" data-animation-atomic="">&nbsp;Будем использовать команду&nbsp;&nbsp;<code class="o8j0Mc">ps -p &lt;PID&gt; -o tty</code>. Можно протестировать:</span></span></p>
<img width="432" height="183" alt="image" src="https://github.com/user-attachments/assets/96803b7f-54fe-43ce-9645-7dc16c400608" />
<p>&nbsp;</p>
<p>Запишем значение в переменную v_TTY, строка будет такой:</p>
<p><code>v_TTY=`ps -p 20129 -o tty`</code></p>
<p>Первые 3 символа нам не нужны, их можно будет обрезать:</p>
<img width="432" height="185" alt="image" src="https://github.com/user-attachments/assets/81819dc7-4d36-4d5c-beca-111e515cd2b6" />
<p>&nbsp;</p>
<p>Опять же, тут конкретный PID, надо использовать цикл.</p>
<p dir="auto">Для поля&nbsp;<strong>STAT</strong>&nbsp;используем команду&nbsp;<code>cat /proc/20129/stat | awk '{ print $3 }'</code><br />Вывод:</p>
<div class="snippet-clipboard-content notranslate position-relative overflow-auto">&nbsp;</div>
<img width="681" height="76" alt="image" src="https://github.com/user-attachments/assets/dadbb6fb-f547-47c5-adb4-fcf945d94e56" />
<p>&nbsp;</p>


