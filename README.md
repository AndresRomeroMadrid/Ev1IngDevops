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

## Flujo de Trabajo y Control de Versiones

Para gestionar el ciclo de vida del codigo en este proyecto, se ha tomado la decision de implementar la estrategia de ramas **GitFlow**.

La eleccion de GitFlow se fundamenta en que el proyecto requiere el uso de varias ramas de larga duracion, tales como la rama principal (main o master) y la rama de integracion continua (develop). Ademas, este flujo permite aislar y preparar correctamente versiones consolidadas mediante ramas de publicacion (release/*) y solucionar problemas urgentes en el entorno de produccion mediante ramas de correccion (hotfix/*).

Al utilizar GitFlow, logramos gestionar de manera ordenada las combinaciones de codigo extensas (merges grandes) y generamos entregas (releases) claras y explicitas, garantizando la estabilidad de la rama principal en todo momento.

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
