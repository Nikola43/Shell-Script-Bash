#!/bin/bash

mailAdmin='pauloxti@gmail.com'

while read line
do

#Guardamos cada campo en una variable
nombre=`echo "$line" | cut -f1 -d~`
email=`echo "$line" | cut -f2 -d~`
telefono=`echo "$line" | cut -f3 -d~`
mensaje=`echo "$line" | cut -f4 -d~`

mensajeMandado="Hola admin, una persona quiere contactar con usted.\nNombre: $nombre\nE-mail: $email\nTelefono: $telefono\nMensaje: $mensaje"

echo -e $mensajeMandado | mail -s "Formulario Joomla" $mailAdmin

if [ $? = 0 ] ; then
echo -e "\033[32;1mEl correo se envió con éxito.\033[0m"
else
echo -e "\033[31;1mEl correo no se envió con éxito, inténtelo de nuevo.\033[0m"
fi
done < peticiones.txt
echo -n > peticiones.txt
