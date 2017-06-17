Rem Borra el backups de los fuentes
DEL BACKUPS\*.*
DEL *.BAK
DEL FUNCIONS\*.BAK
DEL INFORSYS\*.BAK

Rem Copia los fuentes al Backups
COPY . BACKUPS

Rem Borra el Backups de las funcions
DEL FUNCIONS\BACKUPS\*.*

Rem Copia las funcions al Backups
COPY FUNCIONS\*.* FUNCIONS\BACKUPS

Rem Borra el Backups de los informes
DEL INFORSYS\BACKUPS\*.*

Rem Copia los informes a Backups
COPY INFORSYS\*.* INFORSYS\BACKUPS

Rem Visualiza los fuentes
DIR

Rem Visualiza las funcions
DIR FUNCIONS


