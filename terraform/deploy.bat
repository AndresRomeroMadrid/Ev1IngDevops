@echo off
echo ==============================================
echo Iniciando despliegue de infraestructura (PROD)...
echo ==============================================

:: 1. CONFIGURACION DE CREDENCIALES AWS ACADEMY 
set AWS_ACCESS_KEY_ID=TU_ACCESS_KEY_AQUI
set AWS_SECRET_ACCESS_KEY=TU_SECRET_KEY_AQUI
set AWS_SESSION_TOKEN=TU_SESSION_TOKEN_AQUI
:: Cambiar al directorio de produccion
cd enviroment\prod

echo [1/3] Ejecutando Terraform Init...
terraform init

echo.
echo [2/3] Ejecutando Terraform Plan...
terraform plan

echo.
echo [3/3] Ejecutando Terraform Apply...
terraform apply -auto-approve

echo.
echo ==============================================
echo Despliegue completado exitosamente.
echo ==============================================
echo.
echo IP PUBLICA DE TU APLICACION NODE.JS:
terraform output ec2_public_ip
echo ==============================================
echo Copia la IP que sale arriba y agregale el puerto 8085 en tu navegador. 
echo Ejemplo: http://LA-IP-QUE-SALIO:8085
echo.
echo Espera un par de minutos a que la instancia se configure e instale todo.
echo ==============================================
pause
