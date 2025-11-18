
# 🧩 1. Proyecto Linux – Servidor LDAP con Samba  
### **Integración de Autenticación Centralizada en Linux usando LDAP + Samba + Winbind**

Este proyecto implementa desde cero un servidor Linux (Ubuntu) configurado para proveer autenticación corporativa usando:

- **OpenLDAP como backend principal**
- **Samba configurado como controlador de dominio (DC)**
- **Winbind para integración de usuarios/grupos**
- **NSS + PAM para login del cliente Linux**
- **Soporte de directorios personales automáticos**
- **Intento documentado de montar recursos CIFS**

### ✔️ Objetivos del proyecto
- Crear un **servidor LDAP funcional**, con estructura organizativa completa.
- Integrarlo con **Samba** para que actúe como controlador de dominio.
- Permitir que **máquinas Linux cliente** se autentiquen con usuarios del dominio.
- Validar funcionamiento mediante **inicio de sesión real** desde el cliente.
- Documentar fallas reales/limitaciones:  
  - En este caso: **error permanente `mount error(13): Permission denied`** durante el montaje CIFS.

### 📘 Documentación principal
**`implementacion_ldap_profesional.pdf`**  
Contiene:
- Instalación paso a paso  
- Justificación técnica del backend **HDB**  
- Configuración de Samba como DC  
- Carga manual del esquema LDAP para Samba  
- Creación de OUs, usuarios y grupos  
- Integración con cliente Linux vía NSS/PAM  
- Verificaciones (`getent`, login, sysvol/netlogon)  
- Sección completa de troubleshooting  
- Documentación formal de error no resuelto

### 📂 Scripts incluidos
Dentro de `/Linux-LDAP-Samba/scripts/` vas a encontrar:

- Automatización parcial de configuración LDAP/Samba  
- Scripts usados para pruebas de consulta (`ldapsearch`, `getent`, etc.)  
- Scripts auxiliares de verificación o manipulación

---