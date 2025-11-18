#!/bin/bash

# =====================================================
# GENERADOR DE GRUPOS LDAP - SCRIPT DE PRODUCCIÓN
# Creación de grupos LDAP con GID único y SambaSID
# =====================================================

# Validación de parámetro de nombre de grupo
if [ $# -ne 1 ]; then
    echo "Error: No ingresó el parámetro de nombre de grupo"
    exit 1
fi

# Configuración de directorio base del administrador LDAP
dir_Base="/home/administrador-ldap"

# Búsqueda de archivos LDIF de grupos existentes
archivos=$(find ./Grupos -maxdepth 1 -name "*G.ldif" -type f)

# Extracción de GIDs existentes o inicialización
if [[ -n "$archivos" ]]; then
    array=$(grep -h "gidNumber: " $archivos | awk '{print $2}' | sort -n)
else
    array=(0)
fi

# Obtención de GIDs actuales en LDAP
Valores=$(ldapsearch -x -LLL -b "ou=Groups,dc=luthor,dc=corp" gidNumber | grep "gidNumber:" | awk '{print $2}')

# Configuración de rango de GIDs disponibles
inicio=2000
fin=2999

# Obtención del SambaSID base del dominio
sambagen=$(ldapsearch -LLL -x -b "ou=Groups,dc=luthor,dc=corp" sambaSID | grep "sambaSID:" | head -1 | awk '{print $2}')

# Búsqueda de GID disponible dentro del rango especificado
for ((gid=inicio; gid<fin; gid++)); do
    if [[ ! "${Valores[@]}" =~ "$gid" && ! "${array[@]}" =~ "$gid" ]]; then
      	echo "GID libre encontrado: $gid"
    
      	# Generación de RID para Samba (GID * 2 + 1000)
      	rid=$((gid * 2 + 1000))
    
    	# Construcción del SambaSID completo
    	sambaid="${sambagen}-${rid}"
    	break
    fi
done

# Generación del archivo LDIF mediante sustitución de plantilla
sed -e "s/{id-grupo}/$1/g" -e "s/{grupo-id}/$gid/g" -e "s/{sid}/$sambaid/g"  $dir_Base/Plantillas/groupPlantilla.ldif > $dir_Base/Grupos/$1.ldif

# Nota: El archivo LDIF generado contiene la definición completa del grupo
# con todos los atributos LDAP y Samba necesarios para su creación
