#!/bin/bash

# =====================================================
# CONFIGURADOR DE SID SAMBA - SCRIPT DE PRODUCCIÓN
# Generación de SIDs para grupos integrados de Samba LDAP
# =====================================================

# Configuración de directorio base del administrador LDAP
dir_base="/home/administrador-ldap"

# Obtención del SID del dominio Samba desde el servidor
sambasid=$(sudo net getdomainsid 2>/dev/null | awk '{print $7}')

# Generación de SIDs para grupos integrados de Samba:
# -513: Grupo de usuarios del dominio
# -512: Grupo de administradores del dominio
sambalsid="${sambasid}-513"
sambahsid="${sambasid}-512"

# Sustitución de SIDs en plantilla LDIF y generación de archivo final
# Nota: Reemplaza marcadores de posición con SIDs generados
sed -e "s/{sidU}/$sambaUsid/g" -e "s/{sidU}/$sambaAsid/g" $dir_base/samba_ldap.ldif > $dir_base/Grupos/SambaG.ldif

# El archivo generado contiene la configuración LDAP para integración Samba-AD
# con los SIDs apropiados para grupos de dominio
