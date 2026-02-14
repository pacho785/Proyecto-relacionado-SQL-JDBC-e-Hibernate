<#
run.ps1 - Helper script para ejecutar la aplicación desde PowerShell.

Uso (PowerShell):
  .\run.ps1            # ejecuta con valores por defecto (no crea la DB)
  $env:DB_USER='appuser'; $env:DB_PASS='apppass'; .\run.ps1
  # Para ver el comando para crear la BD (no lo ejecuta):
  .\run.ps1 -ShowCreateCommand

Para crear la base de datos y el usuario (manual), copia el comando mostrado por -ShowCreateCommand
y ejecútalo en tu cliente mysql (o Workbench). El script no ejecuta la creación automáticamente por seguridad.
#>
param(
    [switch]$ShowCreateCommand,
    [switch]$UseP6Spy
)

# Valores por defecto (puedes exportarlos antes o pasarlos como variables de entorno)
$dbUser = if ($env:DB_USER) { $env:DB_USER } else { 'appuser' }
$dbPass = if ($env:DB_PASS) { $env:DB_PASS } else { 'apppass' }
$dbHost = if ($env:DB_HOST) { $env:DB_HOST } else { 'localhost' }
$dbPort = if ($env:DB_PORT) { $env:DB_PORT } else { '3306' }
$dbName = if ($env:DB_NAME) { $env:DB_NAME } else { 'world' }

# Driver selection: por defecto usamos driver MySQL directo para desarrollo (menos capas)
if ($UseP6Spy) {
    $dbDriver = 'com.p6spy.engine.spy.P6SpyDriver'
    $dbUrl = "jdbc:p6spy:mysql://$dbHost:$dbPort/$dbName?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC"
} else {
    $dbDriver = if ($env:DB_DRIVER) { $env:DB_DRIVER } else { 'com.mysql.cj.jdbc.Driver' }
    $dbUrl = if ($env:DB_URL) { $env:DB_URL } else { "jdbc:mysql://$dbHost:$dbPort/$dbName?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC" }
}

Write-Host "Ejecución con configuración:"
Write-Host "  DB_DRIVER = $dbDriver"
Write-Host "  DB_URL    = $dbUrl"
Write-Host "  DB_USER   = $dbUser"
Write-Host "  DB_NAME   = $dbName"
Write-Host ""

if ($ShowCreateCommand) {
    Write-Host "Comando sugerido para crear la base de datos y el usuario (ejecutar en una consola con el cliente mysql):" -ForegroundColor Yellow
    $createCmd = "mysql -u root -p -e \"CREATE DATABASE IF NOT EXISTS $dbName CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci; CREATE USER IF NOT EXISTS '$dbUser'@'localhost' IDENTIFIED BY '$dbPass'; GRANT ALL PRIVILEGES ON $dbName.* TO '$dbUser'@'localhost'; FLUSH PRIVILEGES;\""
    Write-Host $createCmd
    Write-Host "(NOTA: sustituye 'root' por el usuario administrador si procede)" -ForegroundColor Yellow
    exit 0
}

# Ejecutar la aplicación Java con las variables en el entorno para esta sesión
Write-Host "Ejecutando Main con las variables de entorno para esta sesión..." -ForegroundColor Green
$env:DB_DRIVER = $dbDriver
$env:DB_URL = $dbUrl
$env:DB_USER = $dbUser
$env:DB_PASS = $dbPass

# Compilar si no existe target/classes o si quieres rebuild rápido
if (-not (Test-Path -Path "target/classes")) {
    Write-Host "Compilando el proyecto (mvn package -DskipTests)..." -ForegroundColor Cyan
    mvn -DskipTests package
}

# Ejecutar
Write-Host "-------------------------------------------"
Write-Host "Comando que se ejecutará: java -cp \"target/classes;target/dependency/*\" Main"
Write-Host "-------------------------------------------"
java -cp "target/classes;target/dependency/*" Main

# Fin


