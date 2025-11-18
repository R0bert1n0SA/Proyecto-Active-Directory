# 🧩 2. Proyecto Windows – Active Directory + DNS  
### **Implementación completa de un Dominio Active Directory profesional**

Este proyecto implementa un entorno corporativo en Windows Server con:

- **Active Directory Domain Services (AD DS)**
- **Servidor DNS autoritativo**
- **Estructura OU completa**
- **Creación de usuarios, grupos y políticas de seguridad**
- **Unión de clientes al dominio**
- **Recursos compartidos en red con permisos NTFS**
- **Buenas prácticas corporativas (nombres, IP estática, DSRM, niveles funcionales, etc.)**

Este proyecto está orientado a simular un entorno empresarial real, usando la convención:

- Dominio raíz del bosque: **ad.luthor.corp**  
- Servidor principal: **AD-01**  

### ✔️ Objetivos del proyecto
- Implementar un dominio desde cero siguiendo la metodología profesional.
- Configurar DNS para la resolución interna del dominio.
- Crear estructura organizativa escalable (OUs: Usuarios, Máquinas, Grupos).
- Aplicar GPOs con estándares corporativos (contraseñas, restricciones, etc.).
- Compartir carpetas con permisos adecuados (Share + NTFS).
- Validar acceso desde un cliente unido al dominio.

### 📘 Documentación principal
**`proyecto_active_directory_profesional.pdf`**  
Incluye:
- Configuración de red e IP estática  
- Instalación del rol AD DS  
- Promoción del servidor a DC  
- Configuración del dominio  
- Creación de OUs, usuarios y grupos  
- Anidación de grupos según AGDLP  
- Unión de cliente Windows al dominio  
- Aplicación de políticas y verificación  
- Implementación de recurso compartido con permisos correctos  

> No se incluyen scripts porque todo el proyecto se realizó mediante GUI, siguiendo el flujo normal de administración de Windows Server.
