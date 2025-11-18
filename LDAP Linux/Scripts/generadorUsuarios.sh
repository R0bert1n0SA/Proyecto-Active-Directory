#!/bin/bash

# =============================================
# GENERADOR DE USUARIOS LDAP - LUTHOR CORP
# Script para crear usuarios LDAP de forma masiva
# con integración Samba y atributos extendidos
# =============================================

# Verificación de parámetros de entrada
if [[ $# -ne 2 ]]; then
    echo "Uso: $0 <area> <cantidad_usuarios>"
    echo "Debe ingresar el área a la que pertenecen y la cantidad de usuarios"
    exit 1
fi

# Configuración de rutas base
base="/home/administrador-ldap"
archivos=$(find $base -maxdepth 1 -name "usuarios-*.ldif" -type f)

# Rango de UID disponibles para nuevos usuarios
inicio=3000
final=3999

# Determinar el último UID utilizado
if [[ -n "$archivos" ]]; then
    # Extraer UIDs existentes y encontrar el máximo
    array_uid=($(grep -h "uidNumber: " $archivos | awk '{print $2}' | sort -n))
else
    # Si no hay archivos, comenzar desde 2999
    array_uid=(2999)
fi

# Calcular el último UID utilizado
ultimo=$((${array_uid[-1]} * 1))


# Verificar si hay espacio suficiente para los nuevos usuarios
if (( ultimo + $2 < final )); then
    # Configuración de archivos de plantilla y destino
    Plantilla="$base/Plantillas/userPlantilla.ldif"
    
    # Obtener GIDNumber del grupo especificado
    gid=$(ldapsearch -x -b "ou=Groups,dc=luthor,dc=corp" "cn=$1" gidNumber | grep 'gidNumber:' | awk '{print $2}')
    
    # Obtener SambaSID base del dominio
    sambaSid_base=$(ldapsearch -LLL -x -b "ou=Groups,dc=luthor,dc=corp" sambaSID | grep 'sambaSID:' | head -n1 | awk '{print $2}')
    
    # Generar usuarios según la cantidad especificada
    for ((i=0; i<$2; i++)); do
        # Generar identificadores únicos para el usuario
        idenU="User$1$i"
        nombreC="N$i A$i"
        apellido="A$i"
        numeroId=$((ultimo + i))
        home="/home/user$i"
        shell="/bin/bash"
        uPass="User$i"
        mail="$idenU@luthor.corp.com"
        gidN=$gid
        
        # Generar timestamps para Samba
        sambaLDS=$(date +%s)
        
        # Construir SambaSID 
        sambaSid="${sambaSid_base}-${numeroId}"
        
        # Generar hash NTLM para la contraseña de Samba
        sambantp=$(echo -n "$uPass" | openssl md4 -binary | xxd -p | tr -d '\n')
        
        # Aplicar sustitución de variables en la plantilla y agregar al archivo LDIF
        sed -e "s|{id-user}|$idenU|g" \
            -e "s|{nombre-completo}|$nombreC|g" \
            -e "s|{apellido}|$apellido|g" \
            -e "s|{numero-id}|$numeroId|g" \
            -e "s|{home}|$home|g" \
            -e "s|{shell}|$shell|g" \
            -e "s|{password}|$uPass/g" \
            -e "s|{mail}|$mail|g" \
            -e "s|{grupo-id}|$gidN|g" \
            -e "s|{samba3}|$sambaLDS|g" \
            -e "s|{samba2}|$sambantp|g" \
            -e "s|{samba1}|$sambaSid|g" "$Plantilla" >>  ./usuarios-$1.ldif
        
        # Agregar línea en blanco entre entradas LDAP
        echo "" >> ./usuarios-$1.ldif
    done
    
    echo "Proceso completado: $2 usuarios generados "
else
    echo "Error: No hay más espacios disponibles. Todas las IDs de usuario han sido utilizadas."
fi

echo "Fin del proceso de generación de usuarios"
