# VR2020_Pushover
Alarm LEDs bei Verbindungswegfall beim TDT VR2020-D/LD

Um bei dem VR2020 eine etwas „feinere“ Art der ALARM-LED
zu realisieren, wird folgendes Script unter /etc/hotplug.d/iface/
angelegt (z.B. 99-alarm) und mit chmod +x /etc/hotplug.d/iface/99-alarm
ausführbar gemacht:

ACHTUNG AUCH HIER GILT:

DIE INSTALLATION ERFOLGT AUF EIGENE GEFAHR –
KEINE GARANTIE, GEWÄHRLEISUNG ODER SUPPORT SEITENS DES HERSTELLERS!


Somit werden die Alarmstates vorne über die LEDs angezeigt.


Um diese bei Bedarf manuell wieder zurücksetzen zu können,
wird im Ordner /usr/sbin noch das folgende Script alarmstate erstellt und mit
chmod +x alarmstate ausführbar gemacht:

Damit kann der Status jederzeit mit alarmstate reset wieder auf 0 zurückgesetzt werden.
Mit alarmstate status wird der momentane Alarmstatus der Interfaces angezeigt.
