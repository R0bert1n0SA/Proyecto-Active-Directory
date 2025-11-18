#!/bin/bash

# =====================================================
# MODIFICADOR DE LDAP - SCRIPT DE PRODUCCIÓN
# Gestión de operaciones CRUD en LDAP (add, replace, delete)
# =====================================================

# Validación de parámetros de entrada obligatorios
if [ $# -ne 3 ]; then
    echo "Uso: $0 <grupo|ou|user> <nombre de area|nombre de usuario |nombre ou>  <add|replace|delete> "
    echo "Debe ingresar tipo de objeto,,nombre y operación  según corresponda"    
    exit 1
fi

# Declaración de variables para atributos LDAP
attribute=""
valor=""

# Captura de datos según el tipo de operación
if [[ $3 -eq "add"  ||  $3 -eq "replace" ]]; then
    echo "Ingrese atributo:"
    read -p atributo
    echo "Ingrese valor:"
    read -p valor
else
    echo "Ingrese atributo:"
    read -p atributo
fi

# Normalización del atributo (eliminación de espacios)
attribute="${atributo%:}"

# Normalización de la operación a minúsculas
opcion=$(echo "$1" | tr '[:upper:]' '[:lower:]')

# Configuración de operaciones LDIF según el tipo de modificación
case $opcion in
    add)
        # Configuración para operación ADD: agregar nuevo atributo
        OP_ADD1="add:$atributo"
        OP_ADD2="$atributo:$valor"
        OP_REPLACE1=" "
        OP_REPLACE2=" "
        OP_DELETE=" "
        ;;
    replace)
        # Configuración para operación REPLACE: modificar atributo existente
        OP_ADD1=" "
        OP_ADD2=" "
        OP_REPLACE1="replace:$attribute"
        OP_REPLACE2="$attribute:$valor"
        OP_DELETE=" "
        ;;
    delete)
        # Configuración para operación DELETE: eliminar atributo
        OP_ADD1=" "
        OP_ADD2=" "
        OP_REPLACE1=" "
        OP_REPLACE2=" "
        OP_DELETE="delete:$attribute"
        ;;
     *) 
        echo "Operación no válida. Use: add, replace o delete"       
        exit 20
        ;;
esac

# Generación del archivo LDIF mediante sustitución de plantilla
sed \
    -e "s|{Identificador}|$2|g" \
    -e "s|{OP_ADD1}|$OP_ADD1|g" \
    -e "s|{OP_ADD2}|$OP_ADD2|g" \
    -e "s|{OP_REPLACE1}|$OP_REPLACE1|g" \
    -e "s|{OP_REPLACE2}|$OP_REPLACE2|g" \
    -e "s|{OP_DELETE}|$OP_DELETE|g" \
    ../Modificador/$1Plantilla.ldif > ../Modificador/mod$1.ldif

# Confirmación de finalización del proceso
echo "Fin del proceso, exitoso "
