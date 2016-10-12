#!/bin/bash
while true
do
clear
	echo "################## RECUERDA SER USUARIO ROOT ################"
	echo " 1. Instalar webmin"
	echo " 2. Instalar DNS server"
	echo " 3. Instalar SAMBA server "
	echo " 4. Instalar CUPS (print server)"
	echo " 5. Añadir grupo UNIX"
	echo " 6. Instalar Putty con ssh (solo modo grafico)"
	echo " 7. Instalar componentes controlador de dominio"
	echo " 8. Instalar/desinstalar modos graficos"
	echo " 9. Copias de seguridad"
	echo " 10. Crear cuotas de discos"
	echo " 11. Actualizar sistema"
	echo " 12. Instalar Swat (solo modo grafico) "
	echo " 13. Salir "	
	echo " ##################################################"
	read opcion


	case $opcion in 

	1) clear
		while true
		do
		echo "################## MODO MANUAL ################"
		echo " 1. Modificar el archivo "sources"             "
		echo " 2. Descargar GPG key                          "
		echo " 3. Instalar GPG key                           "
		echo " 4. Actualizar sistema                         "
		echo " 5. Instalar Webmin                            "
		echo "################ MODO AUTOMÁTICO ##############"
		echo " 6. Instalar TODO automáticamente              "
		echo " 7. Volver                                     "
		echo "###############################################"
		read opcion

		case $opcion in
		
		1) clear
			echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
			echo "deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" >> /etc/apt/sources.list
			if [ $? = 0 ] ; then
				echo OK
			else
				echo "ha habido un fallo, inténtelo de nuevo"
			fi
		;;	
		
		2) clear
			
			wget http://www.webmin.com/jcameron-key.asc
			echo "Hecho. Pulse algna tecla para continuar"
			if [ $? = 0 ] ; then
				echo OK
			else
				echo "ha habido un fallo, inténtelo de nuevo"
			fi
		;;		
		
		3) clear
			
			sudo apt-key add jcameron-key.asc
			echo "Hecho. Pulse alguna tecla para continuar"
			if [ $? = 0 ] ; then
				echo OK
			else
				echo "ha habido un fallo, inténtelo de nuevo"
			fi
		;;

		4) clear
			
			sudo apt-get update
			echo "Hecho. Pulse alguna tecla para continuar"
			if [ $? = 0 ] ; then
				echo OK
			else
				echo "ha habido un fallo, inténtelo de nuevo"
			fi
		;;
		
		5) clear
			
			apt-get install webmin
			if [ $? = 0 ] ; then
				echo OK
			else
				echo "ha habido un fallo, inténtelo de nuevo"
			fi

		;;
		6) clear
			echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
			echo "deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" >> /etc/apt/sources.list
			if [ $? = 0 ] ; then
				echo Correcto, pulse para continuar
				read opcion
			else
				echo Fallo en la escritura de archivos
			
		
			fi
			wget http://www.webmin.com/jcameron-key.asc
			if [ $? = 0 ] ; then
				echo Correcto, pulse para continuar
				read opcion
			else
				echo Fallo en la descarga del paquete
				
		
			fi
			sudo apt-key add jcameron-key.asc
			if [ $? = 0 ] ; then
				echo Correcto, pulse para continuar
				read opcion
			else
				echo Fallo en del paquete

			fi
			sudo apt-get update
			if [ $? = 0 ] ; then
				echo Correcto, pulse para continuar
				read opcion
			else
				echo Fallo en la actualización del sistema
			fi
			
			sudo apt-get install webmin
			if [ $? = 0 ] ; then
				echo Correcto, pulse para continuar
				read opcion
			else
				echo Fallo en la Instalación de webmin
			fi
			;;
		
		7) clear
			break 
		;;

		*) clear
			echo Opcion incorrecta, introduzca otra nueva 
		;;
		esac
		done


	;;

2) clear

	while true
	do
	echo "############################################"
	echo " 1. Instalar DNS                            "
	echo " 2. Crear DNS automático (Por finalizar)    "
	echo " 3. Crear zona maestra"
	echo " 4. Crear dirección de registros            "
	echo " 5. Añadir Alias                            "
	echo " 6. Comprobar si atiende peticiones         "
	echo " 7. Registro PTR  (Inversa Servidor)        "
	echo " 8. Ip's Inversa Equipos                    "
	echo " 9. Creación recurso MX (correo)            "
	echo " 10. Añadir registros CNAME a servidor      "
	echo " 11. Archivo de registros .hosts            "
	echo " 12. Archivo de registros .rev              "
	echo " 13. Cambiar configuración red (estática)   "
	echo " 14. Abrir archivo configuración DNS"
	echo " 15. Volver                                 "
	echo " ###########################################"
	read opcion
	case $opcion in
	1) clear
	apt-get install bind9 
	if [ $? = 0 ] ; then
	echo OK
	else
	echo "Ha habido un fallo, inténtelo de nuevo"
	fi
	;;
	2) clear
	echo Introduce Nombre Servidor
	read servidor
	echo Introduce IP servidor
	read ip
	echo Introduce Servidor Maestro
	read maestro
	echo Introduce Correo Servidor
	read correo
	echo Introduce IP equipo a añadir
	read ip1
	echo Introduce Nombre equipo a añadir
	read equipo
	echo "Introduce alias para el equipo"
	read alias1
	echo Introduce nombre correo servidor
	read direccion
	echo 


	echo '$ttl' "38400
$servidor.	IN	SOA	$maestro. $correo. (
			1360142966
			10800
			3600
			604800
			38400 )
$servidor.	IN	NS	$maestro.
" >> /var/lib/bind/$servidor.hosts
	echo "zone "$servidor" {
        type master;
        file "/var/lib/bind/$servidor.hosts";
        };" >> /etc/bind/named.conf.local

	if [ $? = 0 ] ; then
		echo 1. OK
	else
		echo "Ha habido un fallo, inténtelo de nuevo"
	fi


	echo "$equipo.$servidor.	IN	A	$ip" >> /var/lib/bind/$servidor.hosts
	if [ $? = 0 ] ; then
		echo 2. OK
	else
		echo "Ha habido un fallo, inténtelo de nuevo"
	fi

	dig $servidor > basura.txt
	if [ $? = 0 ] ; then 
		echo "El DNS está activo y recibe peticiones
			3. OK"
	else
		echo "El DNS NO funciona"
	fi
	rm basura.txt

	ipreves1=`echo $ip|cut -f1 -d "." `
	ipreves2=`echo $ip|cut -f2 -d "." `
	ipreves3=`echo $ip|cut -f3 -d "." `
	ipreves4=`echo $ip|cut -f4 -d "." `
	echo '$ttl' "38400
$ipreves4.$ipreves3.$ipreves2.$ipreves1.in-addr.arpa.	IN	SOA	$maestro. $correo. (
			1360143397
			10800
			3600
			604800
			38400 )
$ipreves4.$ipreves3.$ipreves2.$ipreves1.in-addr.arpa.	IN	NS	$mestro." >> /var/lib/bind/$ip.rev
	
	echo "zone "$ipreves4.$ipreves3.$ipreves2.$ipreves1.in-addr.arpa" {
        type master;
        file "/var/lib/bind/$ip.rev";
        };" >> /etc/bind/named.conf.local
	if [ $? = 0 ] ; then
	echo 4. OK
	fi
	ipreves1=`echo $ip1|cut -f1 -d "." `
	ipreves2=`echo $ip1|cut -f2 -d "." `
	ipreves3=`echo $ip1|cut -f3 -d "." `
	ipreves4=`echo $ip1|cut -f4 -d "." `
	echo "$ipreves4.$ipreves3.$ipreves2.$ipreves1.in-addr.arpa.	IN	PTR	$maquina.$servidor." >> /var/lib/bind/$ip.rev
	if [ $? = 0 ] ; then
	echo 5. OK
	else
	echo "Ha habido un fallo, inténtelo de nuevo"
	fi

	echo "$direccion	IN	MX	$pri	$direccion" >> /var/lib/bind/$servidor.hosts	
	if [ $? = 0 ] ; then
	echo OK
	else
	echo "Ha habido un fallo, inténtelo de nuevo"
	fi
	;;
	3) clear
	echo Introduza nombre servidor
	read servidor
	echo Introduzca nombre servidor maestro
	read maestro
	echo Introduzca correo electrónico
	read correo
	echo '$ttl' "38400
$servidor.	IN	SOA	$maestro. $correo. (
			1360142966
			10800
			3600
			604800
			38400 )
$servidor.	IN	NS	$maestro.
" >> /var/lib/bind/$servidor.hosts
	echo "zone "$servidor" {
        type master;
        file "/var/lib/bind/$servidor.hosts";
        };" >> /etc/bind/named.conf.local

	if [ $? = 0 ] ; then
	echo 1. OK
	else
	echo "Ha habido un fallo, inténtelo de nuevo"
	fi

	;;
	4) clear
	echo Introduce nombre servidor
	read servidor
	echo Introduce nombre de equipo
	read equipo
	echo Introduce IP
	read ip
	echo "$equipo.$servidor.	IN	A	$ip" >> /var/lib/bind/$servidor.hosts
	if [ $? = 0 ] ; then
	echo OK
	else
	echo "Ha habido un fallo, inténtelo de nuevo"
	fi
	;;
	5) clear
	echo Introduce nombre servidor
	read servidor
	echo "Introduce su alias"
	read alias1
	echo "$alias1.$servidor.	IN	CNAME	servidor.$servidor." >> /var/lib/bind/$servidor.hosts
	if [ $? = 0 ] ; then
	echo OK
	else
	echo "Ha habido un fallo, inténtelo de nuevo"
	fi
	;;
	6) clear
	echo Introduce nombre dns
	read dns
	dig $dns > basura.txt
	if [ $? = 0 ] ; then 
		echo "El DNS está activo y recibe peticiones"
	else
		echo "El DNS NO funciona"
	fi
	rm basura.txt
	;;
	7) clear
	echo Introduce IP servidor
	read ip
	echo Introduce Servidor Maestro
	read maestro
	echo Introduce Correo Servidor
	read correo
	ipreves1=`echo $ip|cut -f1 -d "." `
	ipreves2=`echo $ip|cut -f2 -d "." `
	ipreves3=`echo $ip|cut -f3 -d "." `
	ipreves4=`echo $ip|cut -f4 -d "." `
	echo '$ttl' "38400
$ipreves4.$ipreves3.$ipreves2.$ipreves1.in-addr.arpa.	IN	SOA	$maestro. $correo. (
			1360143397
			10800
			3600
			604800
			38400 )
$ipreves4.$ipreves3.$ipreves2.$ipreves1.in-addr.arpa.	IN	NS	$mestro." >> /var/lib/bind/$ip.rev
	
	echo "zone "$ipreves4.$ipreves3.$ipreves2.$ipreves1.in-addr.arpa" {
        type master;
        file "/var/lib/bind/$ip.rev";
        };" >> /etc/bind/named.conf.local
	if [ $? = 0 ] ; then
	echo OK
	else
	echo "Ha habido un fallo, inténtelo de nuevo"
	fi
	;;
	8) clear
	echo Introduce Nombre servidor
	read servidor
	echo Introduce IP servidor
	read ip1
	echo Introduce IP máquina
	read ip
	echo Introduce nombre máquina
	read maquina
	ipreves1=`echo $ip|cut -f1 -d "." `
	ipreves2=`echo $ip|cut -f2 -d "." `
	ipreves3=`echo $ip|cut -f3 -d "." `
	ipreves4=`echo $ip|cut -f4 -d "." `
	echo "$ipreves4.$ipreves3.$ipreves2.$ipreves1.in-addr.arpa.	IN	PTR	$maquina.$servidor." >> /var/lib/bind/$ip1.rev
	if [ $? = 0 ] ; then
	echo OK
	else
	echo "ha habido un fallo, inténtelo de nuevo"
	fi
	;;
	9) clear
	echo Introducir nombre servidor DNS
	read dns
	echo Introducir Nombre para el servidor de correo
	read nombre
	echo Introducir Dirección del servidor de correo
	read direccion
	echo Introduzca prioridad
	read pri
	echo "$nombre	IN	MX	$pri	$direccion" >> /var/lib/bind/$dns.hosts	
	if [ $? = 0 ] ; then
	echo OK
	else
	echo "ha habido un fallo, inténtelo de nuevo"
	fi
	;;
	10) clear
	echo Introduzca nombre servidor
	read servidor
	
	echo "www		IN	CNAME	servidor
ftp		IN	CNAME	servidor
mail		IN	CNAME	servidor" >> /var/lib/bind/$servidor.hosts	
	;;
	11) clear
	echo Introduce nombre DNS
	read dns1
	nano /var/lib/bind/$dns1.hosts
	;;
	12) clear
	echo Introduce IP DNS
	read dns1
	nano /var/lib/bind/$dns1.rev
	;;
	13) clear
ifdown eth0
		echo Introduce IP
		read ip
		echo Introduce Mascara
		read mascara
		echo Introduce dirección router
		read gateway
		echo Introduce dirección de red
		read network
		echo Introduce broadcast
		read broad
		echo Introduce DNS1
		read dns1
		echo Introduce DNS2
		read dns2

		echo "auto lo
iface lo inet loopback
auto eth0

iface eth0 inet static
address $ip
netmask $mascara
network $network
broadcast $broad
gateway $gateway" > /etc/network/interfaces

echo "nameserver $dns1
nameserver $dns2" > /etc/resolv.conf
ifup eth0
read opcion
		if [ $? = 0 ] ; then
			echo Red cambiada correctamente. Reiniciando...
			/etc/init.d/networking restart
		else
			echo Fallo al configurar la red.
		fi
	;;
	14)clear
	nano /etc/bind/named.conf.options
	;;
	15) clear
		break
	;;
	*) clear
	echo Opcion incorrecta, introduce otra
	;;
	esac
	done		

;;

3) clear
	while true
	do
	echo "###############################################################"
	echo "1. Instalar Samba"
	echo "2. Crear Carpeta UNIX"
	echo "3. Modificar Archivo Configuración"
	echo "4. Compartir carpeta en el dominio"
	echo "5. Reiniciar Servicio"
	echo "6. Agregar usuario al dominio"
	echo "7. Agregar Equipo al dominio"
	echo "8. Ver archivo configuración"
	echo "9. Testparm"
	echo "10. Volver"
	echo "###################################################"
	read opcion
	case $opcion in
	1) clear
		apt-get install samba
		if [ $? = 0 ] ; then
		echo OK
		else
		echo "ha habido un fallo, inténtelo de nuevo"
		fi
	;;
	
	2) clear
	echo Introduzca de carpeta a crear
	read nombre	
	mkdir $nombre
	if [ $? = 0 ] ; then
		echo Carpeta Creada
		else
		echo "Ha habido un problema, inténtelo de nuevo"
		fi
	chmod 777 $nombre
	;;
	3) clear
	echo "Introduzca nombre de servidor"
	read servidor
	echo "Introduzca nombre equipo server"
	read nombre
	echo Introduzca ip dominio
	read ip
	hoy=`date +%Y/%m/%d`
	hora=`date +%l:%m:%S`
	echo "# Samba config file created by Quini
# from UNKNOWN ($ip)
# Date: $hoy $hora

[global]

workgroup = $servidor
server string = controlador de dominio de j.roiz
netbios name = $nombre
map to guest = Bad User
obey pam restrictions = Yes
pam password change = Yes
passwd program = /usr/bin/passwd %u
passwd chat = *Enger\snew\s*\spassword:* %n\n *Retype\snew\s*\spasword:* %n\n *àsswprd\supdated\ssuccessfully* .
username map = /etc/samba/smbusers
unix password sync = Yes
syslog = 0
log file = /var/log/samba/log.%m
max log size = 1000
time server = Yes
domain logons = Yes
preferred master = Yes
domain master = Yes
wins support = Yes
panic action = /usr/share/samba/panic-action %d
idmap config * : range =
idmap config * : backend = tdb
logon path = \\%N\%U\profile
logon drive = H:
logon home = \\%N/%U
dns proxy = yes

[profile]
path = /home/profile
read only = No
create mask = 0700
directory mask = 0700
nt acl support = No
profile acls = Yes
case sensitive = No
preserve case = No
short preserve case = No
csc policy = disable

[homes]

comment = Home Directories
read only = No
browseable = No

[netlogon]

comment = Network Logon Service
path = /var/lib/samba/netlogon
read only = yes
write list = root
browseable = no" > /etc/samba/smb.conf

	;;
	4) clear
	echo Introduzca nombre carpeta a añadir
	read nombre
	echo "[$nombre]
path = ./$nombre
public = yes
writable = yes" >> /etc/samba/smb.conf 
	;;
	5) clear
	/etc/init.d/smbd restart > basura.txt
		if [ $? = 0 ] ; then
		echo OK
		else
		echo Fallo
		fi
	rm basura.txt
		
	;;
	6) clear
	echo Introduzca nombre de usuario a añadir
	read nombre
	id $nombre
	if [ $? = 0 ] ; then
		smbpasswd -a $nombre
		if [ $? = 0 ] ; then
			echo OK.
		else
			echo Fallo.
		fi
	else
		adduser $nombre
		smbpasswd -a $nombre
		if [ $? = 0 ] ; then
			echo OK.
		else
			echo Fallo.
		fi
	fi
	;;
	7) clear
	echo Introduzca nombre dominio
	read dominio
	echo Introduzca nombre del equipo a validar
	read equipo
	grep $dominio /etc/group > basura.txt
	if [ $? = 0 ] ; then
		adduser --force-badname $equipo'$'
		adduser $equipo'$' $dominio
		read respuesta
		smbpasswd -a -m $equipo $dominio
		read respuesta
		if [ $? = 0 ] ; then
			echo Correcto, procediendo a reiniciar Samba...
			/etc/init.d/smbd restart > basura.txt
			if [ $? = 0 ] ; then
				echo OK.
			else
				echo Fallo al reiniciar.	
			fi
		else
			echo Fallo. Échale un ojo a la configuración.
		fi
		rm basura.txt
	else
		groupadd $dominio
		adduser --force-badname $equipo'$'
		adduser $equipo'$' $dominio
		smbpasswd -a -m $equipo $dominio
		if [ $? = 0 ] ; then
			echo Correcto, procediendo a reiniciar Samba...
			/etc/init.d/smbd restart > basura.txt
			if [ $? = 0 ] ; then
				echo OK.
			else
				echo Fallo al riniciar.
			fi
		else
			echo Fallo. Échale un ojo a la configuración.
		fi
	fi

	;;
	8) clear
	vi /etc/samba/smb.conf

	;;
	9) clear

		testparm
	;;		
	10) clear
		break
	;;
	*)
		echo Opcion incorrecta, introduce otra
	;;
	esac
	done		
;;

4) clear
	while true
	do
	echo "#######################################################"
	echo " 1. Instalar CUPS"
	echo " 2. Instalar impresora PDF"
	echo " 3. Abrir para editar archivo configuracion"
	echo " 4. Reiniciar CUPS"
	echo " 5. Modificar usuario administrador"
	echo " 6. Añadir Impresora al dominio"
	echo " 7. Volver"
	echo "#######################################################"
	read opcion
	
	case $opcion in
	1) clear
		apt-get install cups
	;;
	2) clear
		apt-get install cups-pdf
	;;
	3) clear
		sudo nano /etc/cups/cupsd.conf
	;;
	4) clear
		sudo /etc/init.d/cups restart
	;;
	5) clear
		echo introduce nombre de usuario
		read usuario
		sudo usermod -aG lpadmin $usuario
	;;
	6)
	echo Introduzca nombre impresora
	read impresora
	echo "[$impresora]
printer admin = root
guest ok = Yes
printable = Yes
print ok = Yes
available = Yes" >> /etc/samba/smb.conf
	;;
	7) clear
		break
	;;
	esac
	done
;;

5) clear
	while true
	do
	echo "######################################"
	echo " 1. Añadir usuario UNIX"
	echo " 2. Añadir grupo UNIX"
	echo " 3. Añadir usuario a grupo UNIX"		
	echo " 4. Volver"
	echo "######################################"
	read opcion
	case $opcion in
	1) clear
		echo Introduce Nombre usuario
		read usuario
		adduser $usuario
	;;
	2) clear
		echo Introduce nombre grupo
		read grupo
		sudo addgroup $grupo
	;;
	3) clear
		echo Introduce nombre de usuario
		read usuario
		echo Introduce nombre de grupo
		read grupo
		sudo usermod -a -G $grupo $usuario
	;;
	4) clear
		break
	;;
	esac
	done

;;
6) clear
	while true
	do
	echo "###################################"
	echo " 1. Instalar Putty(posible incompleto)"
	echo " 2. Abrir Putty"
	echo " 3. Volver "
	echo "###################################"
	read opcion
	
	case $opcion in
	1) clear
		sudo apt-get install putty
	;;
	2) clear
		sudo putty
	;;
	3) clear
		break
	;;
	esac
	done
	
;;
7) clear
	while true
	do 
	echo "###################################"
	echo " 1. Instalar apache"
	echo " 2. Crear/modificar pagina web"
	echo " 3. Instalar librerías apache"
	echo " 4. Instalar documentación apache"
	echo " 5. Instalar php5"
	echo " 6. Instalar samba"
	echo " 7. Instalar vsftpd(ftp)"
	echo " 8. Instalar Mysql-server"
	echo " 9. Instalar Mysql-client"
	echo " 10. Volver"
	echo "###################################"
	read opcion
	case $opcion in
	1) clear
		sudo apt-get install apache2
	;;
	2) clear
		echo Introduce nombre pagina web y terminación
		read nombre
		nano /var/www/$nombre
	;;
	3) clear
		apt-get install libapache2-mod-php5
		if [ $? = 0 ] ; then
			echo Librerías apache instaladas
		else
			echo Fallo al instalar librerías apache
		fi
	;;
	4) clear
		apt-get install apache2-doc
		if [ $? = 0 ] ; then
			echo Documentación apache instalada correctamente.
		else
			echo Fallo al instalar la documentación apache.
		fi
	;;
	5)
		clear
		apt-get install php5
		if [ $? = 0 ] ; then 
			echo PHP5 Instalado correctamente.
		else
			echo Fallo al instalar PHP5.
		fi
	;;
	6)	clear
		apt-get install samba
		if [ $? = 0 ] ; then
			echo Samba instalado correctamente.
		else
			echo Fallo al instalar Samba.
		fi
	;;
	7) clear
		apt-get install vsftpd
		if [ $? = 0 ] ; then
			echo Servicio FTP instalado correctamente.
		else	
			echo Fallo al instalar el servicio FTP.
		fi
	;;
	8) clear
		apt-get install mysql-server
		if [ $? = 0 ] ; then
			echo Mysql-server instalado correctamente.
		else
			echo Fallo al instalar Mysql-server
		fi
	;;
	9) clear
		apt-get install mysql-client
		if [ $? = 0 ] ; then
			echo Mysql-client instalado correctamente.
		else
			echo Fallo al instalar Mysql-client.
		fi
	;;
								
	10) clear
		break
	;;
	esac
	done
;;
8) clear
	while true
	do
	echo "########################################"
	echo " 1. Instalar Unity"
	echo " 2. Desinstalar Unity"
	echo " 3. Instalar Gnome"
	echo " 4. Desinstalar Gnome"
	echo " 5. Instalar KDE"
	echo " 6. Desinstalar KDE"
	echo " 7. Instalar Enligthenment"
	echo " 8. Desinstalar Enligthenment"
	echo " 9. Instalar LXDE"
	echo "10. Desinstalar LXDE"
	echo "11. Volver"
	echo "##########################################"
	read opcion
	case $opcion in
	1) clear
	apt-get install unity

	;;
	2) clear
	apt-get autoremove unity
	;;
	3) clear
	apt-get install ubuntu-gnome-desktop ubuntu-gnome-default-settings
	;;
	4) clear
	apt-get autoremove ubuntu-gnome-desktop ubuntu-gnome-default-settings
	;;
	5) clear
	apt-get install kubuntu-desktop
	;;
	6) clear
	apt-get autoremove kubuntu-desktop
	;;
	7) clear
	apt-add-repository ppa:hannes-janetzek/enlightenment-svn
	apt-get update
	apt-get install el7
	;;
	8) clear
	apt-get autoremove el7
	;;
	9) clear
	apt-get install lxde

	;;
	10) clear
	apt-get autoremove lxde

	;;
	11) clear
	break
	;;
	esac
	done
;;
9) clear
	while true
	do
	echo "##########################################################################"
	echo "1. Instalar duplicity"
	echo "2. Realizar una copia de seguridad ahora"
	echo "3. Realizar una copia de seguridad incremental"
	echo "4. Programar una copia de seguridad"
	echo "5. Restaurar desde copia seguridad"
	echo "6. Volver"
	echo "##########################################################################"
	read opcion
	case $opcion in
	1) clear
	apt-get install duplicity
	;;
	2) clear
	echo "Introduzca ruta a hacer copia (directorio/directorio)"
	read ruta1
	echo Introduzca ruta destino copia
	read ruta2
	duplicity full $ruta1 file://$ruta2	

	;;
	3) clear
	echo Introduzca ruta a hacer copia: escritorio/datos..: escritorio/datos..
	read ruta1
	echo Introduzca ruta destino copia
	read ruta2
	duplicity incremental $ruta1 file://$ruta2
	;;
	4) clear
	echo Por ejemplo: duplicity incremental /ruta1 file:///ruta2
	read respuesta
	crontab -e
	;;

	5) clear
	echo Introduce ruta del backup
	read ruta1
	echo "Introduce destino ruta a recuperar (file/file)"
	read ruta2
	duplicity restore  file://$ruta1 $ruta2
	
	;;
	6) clear
	break
	;;
	esac
	done
;;
10) clear
	while true
	do
	echo "##############################################################################"
	echo " 1. Instalar Quota"
	echo " 2. Activar cuotas de disco"
	echo " 3. Desactivar cuotas de disco"
	echo " 4. Modificar, asigjar o eliminar cuota a usuario"
	echo " 5. Modificar, asignar o eliminar cuota a grupo"
	echo " 6. Modificar, asignar o eliminar periodo de gracia a todos los usuarios/grupos"
	echo " 7. Modificar, asignar o eliminar periodo de gracia a usuario"
	echo " 8. Modificar, asignar o eliminar periodo de gracia a grupo"
	echo " 9. Mostrar cuotas de usuarios. Si se han sobrepasado aparece asterisco"
	echo "10. Mostrar cuotas de grupo. Si se han sobrepasado aparece asterisco"
	echo "11. Mostrar las cuotas de todos los usuarios  y grupos del sistema"
	echo "12. Volver"
	echo "##############################################################################"
	read opcion
	case $opcion in
	1) clear
	apt-get install quota
	;;
	2) clear
quotaon -a
	;;
	3) clear
	quotaoff -a
	;;
	4) clear
	echo Introduzca nombre usuario
	read usuario
	edquota -u $usuario
	;;
	5) clear
	echo Introduzca nombre grupo
	read grupo
	edquota -g $grupo
	;;
	6) clear
	edquota -t
	;;
	7) clear
	echo Introduzca nombre usuario
	read usuario
	edquota -u $usuario -T
	;;
	8) clear
	echo Introduzca nombre grupo
	read grupo
	edquota -g $grupo -T
	;;
	9) clear
	echo Introduzca nombre usuario
	read usuario
	quota $usuario
	;;
	10) clear
	echo Introduzca nombre grupo
	read grupo
	quota $grupo
	;;
	11) clear
	repquota -a
	;;
	12) clear
	 break
	;;
	esac
	done
;;
11) clear
	apt-get update
;;
12) clear
	apt-get install swat

;;		
13) clear
	break
;;

*) clear
	echo Error, opcion errónea
;;
esac
done
