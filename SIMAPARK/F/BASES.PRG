# Servidor: localhost
# Base de Datos: parqueadero
# Tabla: 'entradas'
# 
CREATE TABLE `entradas` (
`id` int(11) NOT NULL auto_increment,
`placa` varchar(10) NOT NULL default '',
`entrada` datetime NOT NULL default '0000-00-00 00:00:00',
`salida` datetime NOT NULL default '0000-00-00 00:00:00',
`precio` float NOT NULL default '0',
PRIMARY KEY (`id`),
KEY `placa` (`placa`),
KEY `entrada` (`entrada`),
KEY `salida` (`salida`)
) TYPE=MyISAM; 

# Servidor: localhost
# Base de Datos: parqueadero
# Tabla: 'precios'
# 
CREATE TABLE `precios` (
`tipo` char(4) NOT NULL default '',
`precio` float NOT NULL default '0',
PRIMARY KEY (`tipo`)
) TYPE=MyISAM; 

