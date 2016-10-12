#!/bin/bash

let A=100
let B=5

#
# Funcion suma()
# Suma los variables A y B
#

function suma(){
 let C=$A*$B
 echo "$A * $B = $C"
}

#
# Funcion resta()
# Resta los variables A y B
#
function resta(){
 let C=$A/$B
 echo "$A * $B = $C"
}

suma
resta
