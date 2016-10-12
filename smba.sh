#! /bin/bash
# Nombre del script: smba
# Programador: Paulo Gustavo Soares Teixeira <pauloxti@gmail.com>
# Fecha: 09/06/2013
# Explicación del programa:

# El programa consta de 9 funciones:
#  1. dir() --------> Permite crear o borrar directorios compartidos mendiante samba, creando el directorio tanto como escribiendo en /etc/samba/smb.conf
#  2. sysUsers()----> Permite crear y borrar usuarios del sistema
#  3. smbUsers()----> Permite crear y borrar usuarios de SAMBA
#  4. permissions()-> Permite gestionar permisos y gestionar el propietario o el grupo al que pertenece un directorio o fichero
#  5. rootcheck() --> Comprueba que el usuario que ejecuta el programa es root, si no es root no deja iniciar el programa.
#  6. groups() -----> Permite crear o borrar grupos facilmente, ademas de añadir o eliminar un usuario de un grupo indicado
#  7. sysInfo() ----> Permite ver informacion del sistema asi como los usuarios, los grupos, los directorios que se estan compartiendo etc.
#  8. commmaands() -> Muestra en pantalla una breve explicacion sobre el uso de los comandos mas frecuentes
#  9. password() ---> Nos permite cambiar la contraseña de los usuarios del sistema y de SAMBA.
# 10. smbLog() -----> Muestra un log de las actividades en los directorios compartidos

dir()
{ clear
  echo ""
  echo "1. Crear una carpeta."
  echo "2. Borrar una carpeta."
  echo "3. Salir."
  echo ""
  read -p "Selecciona que accion desea realizar: " eleccionDir
  case $eleccionDir in
      # Crear directorio comparido
      1) clear
         read -p "Escriba el nombre de la carpeta que desea crear: " cdir
         mkdir /DATOS/$cdir; chmod 770 /DATOS/$cdir; chmod g+s /DATOS/$cdir
         chown canp:grupocanp /DATOS/$cdir
         read -p "Escribe una descripcion para el recurso: " comment
         echo "" >> /etc/samba/smb.conf
         echo "[$cdir]" >> /etc/samba/smb.conf
         echo "	comment = $comment" >> /etc/samba/smb.conf
         echo "	path = /DATOS/$cdir" >> /etc/samba/smb.conf
         echo "        create mask = 770" >> /etc/samba/smb.conf
         echo "        directory mask = 770" >> /etc/samba/smb.conf
         echo "        force create mode = 770" >> /etc/samba/smb.conf
         echo "        force directory mode = 770" >> /etc/samba/smb.conf
         echo "	read only = No" >> /etc/samba/smb.conf
         read -p "Desea auditar este recurso?(s/n): " eleccionr
         case $eleccionr in
             's') clear
                  echo "        vfs objects = full_audit" >> /etc/samba/smb.conf
                  echo "        full_audit:prefix = %u|%I|%m|%S" >> /etc/samba/smb.conf
                  echo "        full_audit:success = mkdir rename unlink rmdir pwrite pread connect disconnect" >> /etc/samba/smb.conf
                  echo "        full_audit:failure = none" >> /etc/samba/smb.conf
                  echo "        full_audit:facility = local7" >> /etc/samba/smb.conf
                  echo "        full_audit:priority = NOTICE" >> /etc/samba/smb.conf;;
             'n') clear;;
               *) clear
                echo "No ha seleccionado ninguna opcion valida"
                read -p "Pulsa una tecla para continuar..." tecla;;
         esac
         if [ $? = 0 ] ; then
             echo -e "\033[32;1mLa carpeta $cdir se ha creado correctamente.\033[0m"
         else
             echo -e "\033[31;1mLa carpeta $cdir no se ha creado correctamente.\033[0m"
         fi
       service smbd restart
       read -p "Pulsa una tecla para continuar..." tecla;;
    # Borrar directorio compartido
    2) clear
       read -p "Escriba el nombre de la carpeta que desea eliminar: " bdir
       rm -rf /DATOS/$bdir
       sed '/^\['$bdir'\]$/,/^\[.*\]$/ { /^\['$bdir'\]$/ {d}; /^\[.*\]$/ !{d} }' /etc/samba/smb.conf > /etc/samba/smb.temp
       rm -rf /etc/samba/smb.conf; mv /etc/samba/smb.temp /etc/samba/smb.conf; rm -rf /etc/samba/smb.temp
       if [ $? = 0 ] ; then
         echo -e "\033[32;1mLa carpeta $bdir se ha borrado correctamente.\033[0m"
       else
         echo -e "\033[31;1mLa carpeta $bdir no se ha borrado correctamente.\033[0m"
       fi
       service smbd restart
       read -p "Pulsa una tecla para continuar..." tecla;;
    3) clear;; 
    *) clear
       echo "No ha seleccionado ninguna opcion valida"
       read -p "Pulsa una tecla para continuar..." tecla;;
  esac
}

sysUsers()
{ clear
  echo ""
  echo "1. Crear un usuario en el sistema."
  echo "2. Borrar un usuario en el sistema."
  echo "3. Salir"
  echo ""
  read -p "Selecciona que accion desea realizar: " eleccionUser
  case $eleccionUser in
      # Crear usuario en el sistema
      1) clear
         read -p "Escriba el nombre de usuario que desea crear: " cUser
         useradd $cUser
         passwd  $cUser
         if [ $? = 0 ] ; then
             echo -e "\033[32;1mEl usuario $cUser se ha creado correctamente.\033[0m"
         else
             echo -e "\033[31;1mEl usuario $cUser no se ha creado correctamente.\033[0m"
         fi
         read -p "Pulsa una tecla para continuar..." tecla;;
      # Borrar usuario en el sistema
      2) clear
         read -p "Escriba el nombre de usuario que desea eliminar: " bUser
         deluser $bUser
         if [ $? = 0 ] ; then
             echo -e "\033[32;1mEl usuario $bUser se ha borrado correctamente.\033[0m"
         else
             echo -e "\033[31;1mEl usuario $bUser no se ha borrado correctamente.\033[0m"
         fi
         read -p "Pulsa una tecla para continuar..." tecla;;
      3) clear;;
      *) clear
         echo "No ha seleccionado ninguna opcion valida"
         read -p "Pulsa una tecla para continuar..." tecla;;
  esac
}

smbUsers()
{ 
  clear
  echo ""
  echo "1. Crear un usuario en SAMBA"
  echo "2. Borrar un usuario en SAMBA"
  echo "3. Salir"
  echo ""
  read -p "Selecciona que accion desea realizar: " eleccionSMB
  case $eleccionSMB in
      # Crear usuario en SAMBA
      1) clear
         read -p "Escriba el nombre de usuario que desea crear: " cUser
         smbpasswd -a $cUser
         if [ $? = 0 ] ; then
             echo -e "\033[32;1mEl usuario $cUser se ha creado correctamente.\033[0m"
         else
             echo -e "\033[31;1mEl usuario $cUser no se ha creado correctamente.\033[0m"
         fi
         read -p "Pulsa una tecla para continuar..." tecla;;
      # Borrar usuario en SAMBA
      2) clear
         read -p "Escriba el nombre de usuario que desea eliminar: " bUser
         smbpasswd -x $bUser
         if [ $? = 0 ] ; then
             echo -e "\033[32;1mEl usuario $bUser se ha borrado correctamente.\033[0m"
         else
             echo -e "\033[31;1mEl usuario $bUser no se ha borrado correctamente.\033[0m"
         fi
         read -p "Pulsa una tecla para continuar..." tecla;;
      3) clear;;
      *) clear
         echo "No ha seleccionado ninguna opcion valida"
         read -p "Pulsa una tecla para continuar..." tecla;;
  esac
}

permissions()
{
  clear
  echo ""
  echo "1. Cambiar permisos."
  echo "2. Cambiar propietario."
  echo "3. Cambiar grupo."
  echo "4. Salir."
  read -p "Selecciona la accion que desea realizar: " choice
  case $choice in
      # Cambiar permisos de un objeto del sistema
      1) clear;
         read -p "Escriba el nombre de la carpeta o fichero que desea gestionar: " dir
         echo "La carpeta $dir tiene los siguientes permisos: "
         ls -lhd $dir | cut -f1 -d" "
         echo ""
         echo "Este es el valor de permisos que puede aplicarse:"
         echo "0 = Ningún permiso (Lectura = 0 + Escritura = 0 + Ejecución = 0)"
         echo "1 = Permiso de Ejecución (Lectura = 0 + Escritura = 0 + Ejecución = 1)"
         echo "2 = Permiso de Escritura (Lectura = 0 + Escritura = 2 + Ejecución = 0)"
         echo "3 = Permiso de Escritura y Ejecución (Lectura = 0, Escritura = 2, Ejecución = 1)"
         echo "4 = Permiso de Lectura (Lectura = 4 + Escritura = 0 + Ejecución = 0)"
         echo "5 = Permiso de Lectura y Ejecución (Lectura = 4 + Escritura = 0 + Ejecución = 1)"
         echo "6 = Permiso de Lectura y Escritura (Lectura = 4 + Escritura = 2 + Ejecución = 0)"
         echo "7 = Permiso de Lectura, Escritura y Ejecución (Lectura = 4 + Escritura = 2 + Ejecución = 1)"
         echo ""
         echo "Un ejemplo:"
         echo "Ejecutamos: chmod 644 carpeta1" 
         echo "Propietario = 6 (Puede Leer y Escribir)"
         echo "Grupo = 4 (solo puede Leer)"
         echo "Otros = 4 (solo puede Leer)"
         echo ""
         read -p "Escriba que permisos quiere asignar con el formato XXX: " recurso
         chmod $recurso /DATOS/$dir
         if [ $? = 0 ] ; then
             echo -e "\033[32;1mEl recurso $dir se ha modificado correctamente.\033[0m"
             echo "Estos son los nuevos permisos para $dir"; ls -lhd $dir | cut -f1 -d" "
         else
             echo -e "\033[31;1mEl grupo $cG no se ha modificado correctamente.\033[0m"
         fi
         read -p "Pulsa una tecla para continuar..." tecla;;
      # Cambiar propietario de un objeto
      2) clear
         read -p "Escriba el nombre de la carpeta o fichero que desea gestionar: " dir
         read -p "Escriba el nuevo propietario que quiere asignar: " prop
         chown $prop /DATOS/$dir
         if [ $? = 0 ] ; then
             echo -e "\033[32;1mEl recurso $dir se ha modificado correctamente.\033[0m"
             echo "El nuevo propietario es $prop" 
         else
             echo -e "\033[31;1mEl grupo $cG no se ha modificado correctamente.\033[0m"
         fi
         read -p "Pulsa una tecla para continuar..." tecla;;
      # Cambiar grupo de un objeto
      3) clear
         read -p "Escriba el nombre de la carpeta o fichero que desea gestionar: " dir
         read -p "Escriba el nuevo grupo al que quiere asignar: " grupo
         chgrp $grupo /DATOS/$dir 
         if [ $? = 0 ] ; then
             echo -e "\033[32;1mEl recurso $dir se ha modificado correctamente.\033[0m"
             echo "El nuevo grupo es $grupo"
         else
             echo -e "\033[31;1mEl grupo $cG no se ha modificado correctamente.\033[0m"
         fi
         read -p "Pulsa una tecla para continuar..." tecla;;              
      4) clear;;
      *) clear
         echo "No ha seleccionado ninguna opcion valida"
         read -p "Pulsa una tecla para continuar..." tecla;;
  esac
}

# Comprueba que el usuario es root, en caso negativo expulsa al usuario del terminal.
rootcheck()
{
  ROOT_UID=0   # El $UID de root es 0.
  if [ "$UID" -ne "$ROOT_UID" ]; then
      echo -e "\033[31;5;2m     !EL SCRIPT DEBE SER EJECUTADO COMO ROOT¡.\033[0m"
      exit
  fi
}

groups()
{
  clear
  echo ""
  echo "1. Crear grupos."
  echo "2. Borrar grupos."
  echo "3. Añadir/eliminar usuarios de un grupo."
  echo "4. Salir."
  echo ""
  read -p "Seleccione que desea hacer: " eleccion
  case $eleccion in
      # Crear grupo del sistema
      1) clear
         read -p "Escriba el nombre del grupo que desea crear: " cG
         addgroup $cG
         if [ $? = 0 ] ; then
             echo -e "\033[32;1mEl grupo $cG se ha creado correctamente.\033[0m"
         else
             echo -e "\033[31;1mEl grupo $cG no se ha creado correctamente.\033[0m"
         fi
         read -p "Pulsa una tecla para continuar..." tecla;;
      # Borrar grupo del sistema
      2) clear
         read -p "Escriba el nombre del grupo que desea eliminar: " bG
         delgroup $bG
         if [ $? = 0 ] ; then
            echo -e "\033[32;1mEl grupo $bG se ha borrado correctamente.\033[0m"
         else
            echo -e "\033[31;1mEl grupo $bG no se ha borrado correctamente.\033[0m"
         fi
         read -p "Pulsa una tecla para continuar..." tecla;;
      # Añadir o eliminar un usuario de un grupo
      3) clear
         read -p "Introduzca el usuario que desea gestionar: " user
         echo "El usuario $user pertenece al grupo o grupos: "; id $user | cut -f3 -d " "
         echo ""
         echo "1. Añadirlo a un grupo."
         echo "2. Eliminarlo de un grupo."
         echo "3. Salir"
         echo ""
         read -p "Seleccione lo que desea hacer: " choice
         case $choice in
             # Añadir usuario a un grupo
             1) clear
                read -p "Escriba el grupo al que lo desea añadir: " group
                adduser $user $group; read -p "Pulsa una tecla para continuar..." tecla
                if [ $? = 0 ] ; then
             	    echo -e "\033[32;1mEl usuario $user se ha añadido al grupo $group correctamente.\033[0m"
                else
                    echo -e "\033[31;1mEl usuario $user no se ha añadido al grupo $grupo correctamente.\033[0m"
                fi;;
             # Eliminar usuario de un grupo
             2) clear
                read -p "Escriba el grupo del que desea sacar el usuario: " group
                deluser $user $group; read -p "Pulsa una tecla para continuar..." tecla
                if [ $? = 0 ] ; then
                    echo -e "\033[32;1mEl usuario $user se ha eliminado del grupo $grupo  correctamente.\033[0m"
                else
                    echo -e "\033[31;1mEl usuario $user no se ha eliminado del grupo $grupo correctamente.\033[0m"
                fi;;
       	 esac;;
      3) clear;;
  esac
} 

sysInfo()
{
  clear
  echo ""
  echo "1. Ver Carpetas compartidas."
  echo "2. Ver Usuarios del sistema."
  echo "3. Ver Usuarios de SAMBA."
  echo "4. Ver Grupos del sistema."
  echo "5. Ver el / los grupos de cada usuario."
  echo "6. Ver que usuarios pertenecen a un grupo."
  echo "7. Ver estado de una fichero o directorio."
  echo "8. Salir."
  echo ""
  read -p "Selecciona que accion desea realizar: " accion
  case $accion in
      1) clear;sed '/#Carpetas compartidas/,$ !{ d }' /etc/samba/smb.conf; read -p "Pulsa una tecla para continuar..." tecla;;
      2) clear; cat /etc/passwd | cut -d":" -f1;read -p "Pulsa una tecla para continuar..." tecla;;
      3) clear; pdbedit -L;read -p "Pulsa una tecla para continuar..." tecla;;
      4) clear; cat /etc/group | cut -d":" -f1;read -p "Pulsa una tecla para continuar..." tecla;;
      5) clear
         read -p "Introduzca el usuario que quiere ver: " user
         echo "El usuario $user pertenece al grupo o grupos: "
         id $user | cut -f3 -d " "
         read -p "Pulsa una tecla para continuar..." tecla;;
      6) clear
         read -p "Introduce el nombre del grupo: " group
         echo "Al grupo $group pertenecen los usuarios:"
         cat /etc/group | grep $group | cut -f4 -d :
         echo ""
         read -p "Pulsa una tecla para continuar..." tecla;;
      7) clear; 
         read -p "Introduce el fichero o directorio que desea ver: " file
         echo "Permisos|Propietario|Grupo|Tamaño|Fecha|Nombre del recurso"
         echo ""
         ls -lhd /DATOS/$file
         read -p "Pulsa una tecla para continuar..." tecla;;
      8) clear;;
      *) clear;
         echo "No ha seleccionado ninguna opcion valida"
         read -p "Pulsa una tecla para continuar..." tecla;;
  esac
}

commands()
{
  clear
  echo "mkdir NOMBRE-CARPETA               --> Crea una carpeta"
  echo "rmdir NOMBRE-CARPETA               --> Borra una carpeta"
  echo "adduser NOMBRE-USUARIO             --> Crea un usuario"
  echo "deluser NOMBRE-USUARIO             --> Borra un usuario"
  echo "addgroup NOMBRE-GRUPO              --> Crear un grupo"
  echo "delgroup NOMBRE-GRUPO              --> Borra un grupo"
  echo "chmod PERMISO                      --> Modifica permisos"
  echo "chgrp NOMBRE-FICHERO NOMBRE-GRUPO  --> Cambia de grupo un fichero o directorio"
  echo "chown NOMBRE-PROPIETARIO           --> Cambia de propietario un fichero o directorio"
  echo ""
  echo "Para mas informacion ejecute en el terminal: man comando, por ejemplo: man adduser"
  echo "nos mostrara por pantalla una explicacion mucho mas completa sobre el uso de estos comandos" 
  read -p "Pulsa una tecla para continuar..." tecla
}

password()
{
  Mkey="-ArdBoard12"
  clear
  echo ""
  echo "Introduzca la clave maestra: "; read -s key
  if [ $key == $Mkey ]; then
      echo "Contraseña correcta!"
      read -p "Introduce el usuario: " user
      passwd $user
      smbpasswd $user
      service smbd restart
      if [ $? = 0 ] ; then
          echo -e "\033[32;1mEl cambio de contraseña para el usuario $user se ha realizado correctamente.\033[0m"
      else
          echo -e "\033[31;1mEl cambio de contraseña para el usuario $user no se ha realizado correctamente.\033[0m"
      fi
      read -p "Pulsa una tecla para continuar..." tecla
  else 
      echo "No ha escrito correctamente la contraseña."
      read -p "Pulsa una tecla para continuar..." tecla
  fi
}

smbLog()
{ # Muestra la auditoria de samba
  Mkey="-ArdBoard12"
  echo "Introduzca la clave maestra: "; read -s key
  if [ $key == $Mkey ]; then
  cat /var/log/smbd_audit.log | colorlog.pl | more
  read -p "Pulsa una tecla para continuar..." tecla
  fi
}

while true
do
  clear
  echo ""
  rootcheck
  echo ""
  echo "  ***************************************************  "
  echo " ***************************************************** "
  echo "*******************************************************"
  echo "***                                                 ***"
  echo "***                 .::AdminSMBv1.0::.              ***"
  echo "***                                                 ***"
  echo "***    1. Crear/borrar una carpeta para compartir.  ***"
  echo "***    2. Crear/borrar un usuario del sistema.      ***"
  echo "***    3. Crear/borrar un usuario de SAMBA.         ***"
  echo "***    4. Gestion de grupos.                        ***"
  echo "***    5. Gestion de permisos y propietarios.       ***"
  echo "***    6. Lista de comandos.                        ***"
  echo "***    7. Informacion del sistema.                  ***"
  echo "***    8. Restablecer contraseña.                   ***"
  echo "***    9. Ver log de actividades.                   ***"
  echo "**    10. Reiniciar servidor SAMBA (No el equipo)   ***"
  echo "***   11. Salir.                                    ***"
  echo "***                                                 ***"
  echo "*******************************************************"
  echo " ***************************************************** "
  echo "  ***************************************************  "
  echo ""
  read -p "Introduce que accion deseas realizar: " eleccionMenu

  case $eleccionMenu in
    1) clear; dir;; 
    2) clear; sysUsers;;
    3) clear; smbUsers;; 
    4) clear; groups;;
    5) clear; permissions;;
    6) clear; commands;;
    7) clear; sysInfo;;
    8) clear; password;;
    9) clear; smbLog;;
   10) clear; service smbd restart; read -p "Pulsa una tecla para continuar..." tecla;;
   11) clear; break;;  
    *) echo "No ha seleccionado ninguna opcion valida"
       read -p "Pulsa una tecla para continuar..." tecla;;
  esac
done
