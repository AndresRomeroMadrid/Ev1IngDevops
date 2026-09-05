# Evaluacion 1 - Ingenieria DevOps

Este proyecto es una aplicacion web sencilla desarrollada en Node.js utilizando el framework Express. Su proposito principal es servir un formulario de registro donde los usuarios pueden ingresar su Nombre, Direccion y Comuna. Los datos ingresados se agregan dinamicamente a una lista en la misma pagina sin necesidad de recargarla, utilizando JavaScript en el lado del cliente (frontend).

Ademas de la aplicacion, el proyecto incluye toda la configuracion de infraestructura como codigo (IaC) necesaria para su despliegue automatico en Amazon Web Services (AWS). Para esto, se utiliza Terraform estructurado en modulos (Red y Servidor) junto con un script automatizado para facilitar la construccion del entorno.

## Estructura del Proyecto

*   **server.js**: Archivo principal del servidor Node.js que configura Express y atiende las peticiones en el puerto 8085.
*   **public/index.html**: Pagina web estatica que contiene el formulario y la logica de interaccion con el usuario.
*   **terraform/**: Carpeta que contiene la declaracion de infraestructura para AWS.
    *   **modules/vcp/**: Modulo de red que crea una Nube Virtual Privada (VPC), Subred Publica, Puerta de Enlace a Internet (IGW) y Tablas de Enrutamiento.
    *   **modules/ec2/**: Modulo de computo que aprovisiona una maquina virtual, configura los grupos de seguridad y ejecuta un script de inicio que instala y arranca la aplicacion automaticamente.
    *   **enviroment/prod/**: Entorno de produccion que hace uso de los modulos anteriores.
    *   **deploy.bat**: Script de Windows para ejecutar el despliegue de Terraform de manera automatizada.

## Estrategias y Convenciones de Desarrollo

Para gestionar el ciclo de vida del codigo de manera colaborativa, profesional y ordenada, se ha implementado la estrategia de ramas **GitFlow** acompañada de las siguientes normativas estrictas para el equipo:

### 1. Naming de Ramas (Nomenclatura)
El repositorio se divide en ramas protegidas (`main` y `develop`) y ramas efímeras. Las ramas nuevas deben seguir este formato de nombrado:
*   `feature/nombre-descriptivo`: Para nuevas funcionalidades o tareas (Ej. `feature/agregar-footer`). Nacen de `develop`.
*   `bugfix/nombre-del-error`: Para errores encontrados en desarrollo. Nacen de `develop`.
*   `hotfix/nombre-del-error`: Para parches de emergencia en producción. Nacen de `main`.
*   `release/vX.X.X`: Para congelar el código antes de un pase a producción. Nacen de `develop`.

### 2. Convenciones de Commits
El proyecto adopta el estandar **Conventional Commits** para mantener un historial limpio, legible y automatizable. Todos los mensajes de commit deben seguir la estructura `tipo(ambito): mensaje`:
*   `feat:` Para agregar una nueva característica (Ej. `feat(ui): agregar boton de eliminar`).
*   `fix:` Para solucionar un error (Ej. `fix(terraform): corregir puerto de seguridad`).
*   `docs:` Para cambios exclusivos en documentacion.
*   `chore:` Para tareas de mantenimiento que no afectan el codigo de produccion (actualizar dependencias, etc.).

### 3. Estrategias de Revision (Code Review)
Está estrictamente prohibido hacer push directo a las ramas `main` y `develop`. Todo cambio de codigo debe integrarse a través de un **Pull Request (PR)**.
*   Todo PR debe ser revisado y aprobado por al menos **1 revisor (Code Review)** antes de poder ser fusionado.
*   El pipeline de CI (Integracion Continua) configurado en GitHub Actions debe pasar con éxito (checks en verde) obligatoriamente antes de habilitar el boton de merge.

### 4. Flujos de Merge
Las fusiones de código se trataran de distinta manera según el destino para optimizar el historial:
*   **Hacia `develop`:** Los Pull Requests desde ramas `feature/*` se integrarán usando **Squash and Merge**. Esto colapsa todos los commits intermedios de la rama de trabajo en un único commit limpio en `develop`.
*   **Hacia `main`:** Los pases a producción desde `release/*` o `hotfix/*` se harán mediante un **Merge Commit (No Fast-Forward / `--no-ff`)**. Esto deja un "nudo" visible en el árbol de Git que marca exactamente cuándo ocurrió el lanzamiento.

### 5. Herramientas de Asistencia Inteligente
Para garantizar la calidad de la documentación y optimizar el proceso de integración, este proyecto se ha apoyado en el uso de **Antigravity** y **Claude**. Estas herramientas de inteligencia artificial y automatización se utilizaron específicamente para:
*   Mejorar la redacción, claridad y formato de este documento (README).
*   Facilitar y agilizar el flujo de trabajo de los Pull Requests.

## Como ejecutar de forma local

1. Asegurese de tener Node.js instalado.
2. Abra una terminal en la raiz del proyecto y ejecute `npm install` para instalar las dependencias.
3. Ejecute `node server.js`.
4. Abra su navegador web en `http://localhost:8085`.

## Como desplegar en AWS

1. Abra el archivo `terraform/deploy.bat` en un editor de texto.
2. Reemplace las variables temporales de acceso con sus propias credenciales provistas por AWS Academy.
3. Ejecute el script `deploy.bat` haciendo doble clic sobre el.
4. Al finalizar, la consola imprimira la direccion IP publica del servidor en la nube.
5. Ingrese esa IP en el navegador con el puerto 8085 (Ejemplo: http://1.2.3.4:8085).
