Rem Borra el backups de los fuentes
DEL BACKUPS\*.*
DEL *.BAK
DEL FUNCIONS\*.BAK


Rem Copia los fuentes al Backups
COPY . BACKUPS

Rem Borra el Backups de las funcions
DEL FUNCIONS\BACKUPS\*.*

Rem Copia las funcions al Backups
COPY FUNCIONS\*.* FUNCIONS\BACKUPS

Rem Visualiza los fuentes
DIR

Rem Visualiza las funcions
DIR FUNCIONS


