#!/bin/bash
#Variable donde se almacenara la distribucion del sistema
distri=NULL

# Comprueba que el usuario es root
rootCheck(){
  ROOT_UID=0   # El $UID de root es 0.
  if [ "$UID" -ne "$ROOT_UID" ]; then
      clear
      echo -e "\033[31;5;2m     !EL SCRIPT DEBE SER EJECUTADO COMO ROOT¡.\033[0m"
      echo ""
      read -p "Pulsa una tecla para continuar..." tecla
      clear
      break
  fi
}

#Comprueba que distribucion se usa
distriCheck(){
#Almacena la distribucion de linux del sistema
getDistri=`lsb_release -a | grep "Distributor ID" | cut -d: -f2`

if [ $getDistri == 'Ubuntu' ]; then
  distri='Ubuntu'
elif [ $getDistri == 'CentOS' ]; then
  distri='CentOS'
else
  echo "Distribucion no compatible"
  read -p "Pulsa una tecla para continuar..." tecla
  break
fi
}

dependencias(){
#Comprueba e instala 'aptitude' si no esta instalado
if [ ! -f /usr/bin/aptitude ]; then
  if [ $distri == 'Ubuntu' ]; then
    apt-get install aptitude -y
    if [ $? == 0 ]; then
      echo -e "\033[32;1m Se ha instalado 'aptitude' correctamente\033[0m"
    else
      echo -e "\033[31;1m Se ha producido un error instalando 'aptitude'\033[0m"
    fi
    read -p "Pulsa una tecla para continuar..." tecla
  fi
fi

#Comprueba e instala 'vim' si no esta instalado
if [ ! -f /usr/bin/vim ]; then
  if [ $distri == 'Ubuntu' ]; then
    apt-get install vim -y
  elif [ $distri == 'CentOS' ]; then
    yum install vim -y
  fi
  if [ $? == 0 ]; then
    echo -e "\033[32;1m Se ha instalado el paquete 'vim' correctamente\033[0m"
  else
    echo -e "\033[31;1m Se ha producido un error instalando el paquete 'vim'\033[0m"
  fi
  read -p "Pulsa una tecla para continuar..." tecla
fi
}

#Añade los repositorios de webmin al sistema y la clave publica e instala webmin
installWebmin(){
#instala webmin en Ubuntu  
if [ $distri == 'Ubuntu' ]; then
  echo "# Repositiorios para instalar windows" >> /etc/apt/sources.list
  echo "deb http://download.webmin.com/download/repository sarge contrib" >> /etc/apt/sources.list
  echo "deb http://webmin.mirror.somersettechsolutions.co.uk/repository sarge contrib" >> /etc/apt/sources.list
  wget http://www.webmin.com/jcameron-key.asc
  apt-key add jcameron-key.asc
  rm -rf jcameron-key.asc
  aptitude update
  aptitude install webmin -y
  if [ $? == 0 ]; then
    echo -e "\033[32;1m Se ha instalado webmin correctamente\033[0m"
  else
    echo -e "\033[31;1m Se ha producido un error instalando webmin\033[0m"
  fi
  read -p "Pulsa una tecla para continuar..." tecla

#instala webmin en CentOS
elif [ $distri == 'CentOS' ]; then
  touch /etc/yum.repos.d/webmin.repo
  echo "[Webmin]" >> /etc/yum.repos.d/webmin.repo
  echo "name=Webmin Distribution Neutral" >> /etc/yum.repos.d/webmin.repo
  echo "#baseurl=http://download.webmin.com/download/yum" >> /etc/yum.repos.d/webmin.repo
  echo "mirrorlist=http://download.webmin.com/download/yum/mirrorlist" >> /etc/yum.repos.d/webmin.repo
  echo "enabled=1" >> /etc/yum.repos.d/webmin.repo
  wget http://www.webmin.com/jcameron-key.asc
  rpm --import jcameron-key.asc
  rm -rf jcameron-key.asc
  yum update
  rm -rf jcameron-key.asc
  yum install webmin -y
  if [ $? == 0 ]; then
    echo -e "\033[32;1m Se ha instalado webmin correctamente\033[0m"
  else
    echo -e "\033[31;1m Se ha producido un error instalando webmin\033[0m"
  fi
  read -p "Pulsa una tecla para continuar..." tecla
else
  echo "Distribucion no compatible"
  read -p "Pulsa una tecla para continuar..." tecla
fi
}

printServer(){
  clear
  echo ""
  echo " 1. Instalar CUPS"
  echo " 2. Instalar impresora PDF (Ubuntu)"
  echo " 3. Abrir fichero de configuracion"
  echo " 4. Reiniciar servicio"
  echo " 5. Modificar usuario administrador"
  echo " 6. Añadir Impresora al dominio"
  echo " 7. Volver"
  echo ""
  read -p "Que desea hacer: " opcion
	case $opcion in
	1) #instala cups para Ubuntu
	   clear
           if [ $distri == 'Ubuntu' ]; then
             aptitude install cups
             if [ $? == 0 ]; then
               echo -e "\033[32;1m Se ha instalado 'cups' correctamente\033[0m"
             else
               echo -e "\033[31;1m Se ha producido un error instalando 'cups'\033[0m"
             fi
           fi

           #instala cups para CentOS
           clear
           if [ $distri == 'CentOS' ]; then
             yum install cups
             if [ $? == 0 ]; then
               echo -e "\033[32;1m Se ha instalado CUPS correctamente\033[0m"
             else
               echo -e "\033[31;1m Se ha producido un error instalando CUPS\033[0m"
             fi
           fi
           read -p "Pulsa una tecla para continuar..." tecla;;        
	
        2) #instala una impresora pdf para Ubuntu
           clear
           if [ $distri == 'Ubuntu' ]; then
             aptitude install cups-pdf
             if [ $? == 0 ]; then
               echo -e "\033[32;1m Se ha instalado CUPS correctamente\033[0m"
             else
               echo -e "\033[31;1m Se ha producido un error instalando CUPS\033[0m"
             fi
           fi
 
           #instala una impresora pdf para Ubuntu
           #if [ $distri == 'CentOS' ]; then
           #  yum install cups-pdf
           #  if [ $? == 0 ]; then
           #    echo -e "\033[32;1m Se ha instalado CUPS correctamente\033[0m"
           #  else
           #    echo -e "\033[31;1m Se ha producido un error instalando CUPS\033[0m"
           #  fi
           #fi
           #read -p "Pulsa una tecla para continuar..." tecla
           ;;
	
        3) clear; vim /etc/cups/cupsd.conf; read -p "Pulsa una tecla para continuar..." tecla;;
	4) clear; /etc/init.d/cups restart;read -p "Pulsa una tecla para continuar..." tecla;;
	5) clear
           read -p "Introduce nombre de usuario" usuario
	   usermod -aG lpadmin $usuario; read -p "Pulsa una tecla para continuar..." tecla;;
	6) clear
           #añade una impresora al fichero de samba
	   read -p "Introduzca nombre impresora: " impresora
           echo "" >> /etc/samba/smb.conf
           echo "[$impresora]" >> /etc/samba/smb.conf
           echo "printer admin = root" >> /etc/samba/smb.conf
           echo "guest ok = Yes" >> /etc/samba/smb.conf
           echo "printable = Yes" >> /etc/samba/smb.conf
           echo "print ok = Yes" >> /etc/samba/smb.conf
           echo "available = Yes" >> /etc/samba/smb.conf
           if [ $? == 0 ]; then
             echo -e "\033[32;1m Se ha añadido la impresora '$impresora' correctamente \033[0m"
           else
             echo -e "\033[31;1m Error instalando la impresora '$impresora' \033[0m"
           fi
           read -p "Pulsa una tecla para continuar..." tecla;; 
	7) clear;;
	esac
}
	
installLAMP(){
  clear
	echo ""
	echo " 1. Instalar LAMP automaticamente (solo ubuntu)"
        echo " 2. Instalar apache"
	echo " 3. Instalar php5"
	echo " 4. Instalar Mysql"
	echo " 5. Volver"
	echo ""
        read -p "Que desea hacer: " opcion
	case $opcion in
	1) #instalar LAMP automatico (solo ubuntu)
           clear
           if [ $distri == 'Ubuntu' ]; then
             tasksel
           else
             echo "Distribucion no compatible"
           fi
           read -p "Pulsa una tecla para continuar..." tecla;;
        2) #instala apache 
           clear
           if [ $distri == 'Ubuntu' ]; then
             aptitude install apache2 -y
           elif [ $distri == 'CentOS' ]; then
             yum install httpd -y   
           fi
           if [ $? == 0 ]; then
             echo -e "\033[32;1m Se ha instalado 'apache' correctamente\033[0m"
           else
             echo -e "\033[31;1m Se ha producido un error instalando 'apache'\033[0m"
           fi
           read -p "Pulsa una tecla para continuar..." tecla;;
	3) #instala php5
           clear
	   if [ $distri == 'Ubuntu' ]; then
             aptitude install php5 -y
           elif [ $distri == 'CentOS' ]; then
             yum install php php-mysql -y
           fi
           if [ $? == 0 ]; then
             echo -e "\033[32;1m Se ha instalado 'php5' correctamente\033[0m"
           else
             echo -e "\033[31;1m Se ha producido un error instalando 'php5'\033[0m"
           fi
           read -p "Pulsa una tecla para continuar..." tecla;;
        4) #instala mysql
           clear
           if [ $distri == 'Ubuntu' ]; then
             aptitude install mysql-client -y
             aptitude install mysql-server -y
           elif [ $distri == 'CentOS' ]; then
             yum install mysql-server -y
           fi
           if [ $? == 0 ]; then
             echo -e "\033[32;1m Se ha instalado 'mysql' correctamente\033[0m"
           else
             echo -e "\033[31;1m Se ha producido un error instalando 'mysql'\033[0m"
           fi
           read -p "Pulsa una tecla para continuar..." tecla;;
	5) clear;;
        esac
}

installDesktop(){
  clear
	echo "########################################"
	echo " 1. Instalar Unity"
	echo " 2. Desinstalar Unity"
	echo " 3. Instalar Gnome"
	echo " 4. Desinstalar Gnome"
	echo " 5. Instalar KDE"
	echo " 6. Desinstalar KDE"
	echo " 7. Volver"
	echo "##########################################"
	read opcion
	case $opcion in
	1) clear
	   aptitude install unity -y
           if [ $? == 0 ]; then
             echo -e "\033[32;1m Se ha instalado la interfaz grafica 'Unity' correctamente\033[0m"
           else
             echo -e "\033[31;1m Se ha producido un error instalando la interfaz grafica 'Unity'\033[0m"
           fi
           read -p "Pulsa una tecla para continuar..." tecla;;
	2) clear
	   aptitude purge unity
           if [ $? == 0 ]; then
             echo -e "\033[32;1m Se ha desisntalado la interfaz grafica 'Unity' correctamente\033[0m"
           else
             echo -e "\033[31;1m Se ha producido un error desinstalando la interfaz grafica 'Unity'\033[0m"
           fi
           read -p "Pulsa una tecla para continuar..." tecla;;
        3) clear
	   aptitude install ubuntu-gnome-desktop ubuntu-gnome-default-settings
           if [ $? == 0 ]; then
             echo -e "\033[32;1m Se ha instalado la interfaz grafica 'Gnome' correctamente\033[0m"
           else
             echo -e "\033[31;1m Se ha producido un error instalando la interfaz grafica 'Gnome'\033[0m"
           fi
           read -p "Pulsa una tecla para continuar..." tecla;;
	4) clear
	   aptitude purge ubuntu-gnome-desktop ubuntu-gnome-default-settings
           if [ $? == 0 ]; then
             echo -e "\033[32;1m Se ha desisntalado la interfaz grafica 'Gnome' correctamente\033[0m"
           else
             echo -e "\033[31;1m Se ha producido un error desinstalando la interfaz grafica 'Gnome'\033[0m"
           fi
           read -p "Pulsa una tecla para continuar..." tecla;;
        5) clear
	   aptitude install kubuntu-desktop -y
           if [ $? == 0 ]; then
             echo -e "\033[32;1m Se ha instalado la interfaz grafica 'KDE' correctamente\033[0m"
           else
             echo -e "\033[31;1m Se ha producido un error instalando la interfaz grafica 'KDE'\033[0m"
           fi
           read -p "Pulsa una tecla para continuar..." tecla;;
	6) clear
	   aptitude purge kubuntu-desktop 
           if [ $? == 0 ]; then
             echo -e "\033[32;1m Se ha desisntalado la interfaz grafica 'KDE' correctamente\033[0m"
           else
             echo -e "\033[31;1m Se ha producido un error desinstalando la interfaz grafica 'KDE'\033[0m"
           fi
	   read -p "Pulsa una tecla para continuar..." tecla;;
        7) clear;;
	*) clear
           echo "No ha seleccionado ninguna opcion valida";;
	esac
}

backups(){
  clear
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
}

quoteDisk(){
  clear
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
}


while true
do
  rootCheck
  distriCheck
  dependencias
  clear
  echo ""
  echo ""
  echo "  ***************************************************  "
  echo " ***************************************************** "
  echo "*******************************************************"
  echo "***                                                 ***"
  echo "***                 .::adminServer::.               ***"
  echo "***                                                 ***"
  echo "***        1. Instalar webmin                       ***"
  echo "***        2. Instalar CUPS (print server)          ***"
  echo "***        3. Instalar LAMP server                  ***"
  echo "***        4. Intalar entorno grafico               ***"
  echo "***        5. Copias de seguridad                   ***"
  echo "***        6. Cuotas de disco                       ***"
  echo "***       11. Actualizar sistema                    ***"
  echo "***       12. Instalar Swat (solo modo grafico)     ***"
  echo "***       13. Salir                                 ***"                
  echo "***                                                 ***"
  echo "*******************************************************"
  echo " ***************************************************** "
  echo "  ***************************************************  "
  echo ""
  read -p "Introduce que accion deseas realizar: " eleccionMenu

  case $eleccionMenu in
    1) clear; installWebmin;;
    2) clear; printServer;;
    3) clear; installLAMP;;
    4) clear; installDesktop;;
    5) clear; backups;;
    6) clear; quoteDisk;;
    7) clear; ;;
    8) clear; ;;
    9) clear; ;;
   10) clear; ;;
   10) clear; ;;
   11) clear; ;;
   12) clear; ;;
   13) clear; break;;
    *) echo "No ha seleccionado ninguna opcion valida"
       read -p "Pulsa una tecla para continuar..." tecla;;
  esac
  done
