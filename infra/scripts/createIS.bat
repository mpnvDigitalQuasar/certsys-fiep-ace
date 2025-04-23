@echo off

REM ############################################################################
REM ## CERTSYS
REM ## Script para criação e configuração de novos Integration Servers no ACE.
REM ## Autora: Melina Pereira Nalia Viana
REM ## Criação: 07/02/2025
REM ##
REM ## Uso: 
REM ## createIS.bat IntNode IntServer PortaHTTPS PortaHTTP PortaDEBUG
REM ## EX: createIS.bat IN_DEV01 IS_Saude 7843 7803 9999
REM ## 
REM ## IntNode - Nome do Integration Node
REM ## IntServer - Nome do Integration Server
REM ## PortaHTTPS - Porta HTTPS
REM ## PortaHTTP - Porta HTTP
REM ## PortaDEBUG - Porta DEBUG
REM ##
REM ############################################################################

REM Enables delayed expansion
setlocal enabledelayedexpansion

REM Verificar se os parâmetros foram passados
if "%1"=="" (
    echo ERRO: O parâmetro IntNode nao foi fornecido.
    echo Uso: createIS.bat IntNode IntServer PortaHTTPS PortaHTTP PortaDEBUG
    exit /B 1
)

if "%2"=="" (
    echo ERRO: O parâmetro IntServer nao foi fornecido.
    echo Uso: createIS.bat IntNode IntServer PortaHTTPS PortaHTTP PortaDEBUG
    exit /B 1
)

if "%3"=="" (
    echo ERRO: O parâmetro PortaHTTPS nao foi fornecido.
    echo Uso: createIS.bat IntNode IntServer PortaHTTPS PortaHTTP PortaDEBUG
    exit /B 1
)

if "%4"=="" (
    echo ERRO: O parâmetro PortaHTTP nao foi fornecido.
    echo Uso: createIS.bat IntNode IntServer PortaHTTPS PortaHTTP PortaDEBUG
    exit /B 1
)

if "%5"=="" (
    echo ERRO: O parâmetro PortaDEBUG nao foi fornecido.
    echo Uso: createIS.bat IntNode IntServer PortaHTTPS PortaHTTP PortaDEBUG
    exit /B 1
)

REM Iniciando as váriaveis
set "IntNode=%1"
set "IntServer=%2"
set "PortaHTTPS=%3"
set "PortaHTTP=%4"
set "PortaDEBUG=%5"
REM Váriaveis iniciadas

REM ############### REGISTRANDO A DATA/HORA ###################
set "timestamp=%DATE% %TIME%"

REM ############### LOGGING INICIAL ###################
echo [%timestamp%] Iniciando o processamento.

echo.
echo *********************************************************************
echo Iniciando a criação Integration Server %IntServer% no Integration Node %IntNode%
echo.
echo mqsicreateexecutiongroup %IntNode% -e %IntServer%
mqsicreateexecutiongroup %IntNode% -e %IntServer%
echo.
echo Finalizado a criação Integration Server %IntServer% no Integration Node %IntNode%

echo.
echo *********************************************************************
echo Iniciando a configuração o HeapSize do Integration Server %IntServer% no Integration Node %IntNode%
echo.
echo mqsichangeproperties %IntNode% -e %IntServer% -o ComIbmJVMManager -n jvmMinHeapSize -v 33554432
mqsichangeproperties %IntNode% -e %IntServer% -o ComIbmJVMManager -n jvmMinHeapSize -v 33554432
echo.
echo mqsichangeproperties %IntNode% -e %IntServer% -o ComIbmJVMManager -n jvmMinHeapSize -v 268435456
mqsichangeproperties %IntNode% -e %IntServer% -o ComIbmJVMManager -n jvmMinHeapSize -v 268435456
echo.
echo Finalizando a configuração o HeapSize do Integration Server %IntServer% no Integration Node %IntNode%

echo.
echo *********************************************************************
echo Iniciando a configuração do Basic Authentication do Integration Server %IntServer% no Integration Node %IntNode%
echo.
echo mqsichangeproperties %IntNode% -e %IntServer% -o ComIbmSocketConnectionManager -n preemptiveAuthType -v 'Basic'
mqsichangeproperties %IntNode% -e %IntServer% -o ComIbmSocketConnectionManager -n preemptiveAuthType -v 'Basic'
echo.
echo Finalizando a configuração do Basic Authentication do Integration Server %IntServer% no Integration Node %IntNode%

echo.
echo *********************************************************************
echo Iniciando a configuração da Porta HTTP e Porta HTTPS do Integration Server %IntServer% no Integration Node %IntNode%
echo.
echo mqsichangeproperties %IntNode% -e %IntServer% -o HTTPConnector -n ListenerPort -v %PortaHTTP%
mqsichangeproperties %IntNode% -e %IntServer% -o HTTPConnector -n ListenerPort -v %PortaHTTP%
echo.
echo mqsichangeproperties %IntNode% -e %IntServer% -o HTTPSConnector -n ListenerPort -v %PortaHTTPS%
mqsichangeproperties %IntNode% -e %IntServer% -o HTTPSConnector -n ListenerPort -v %PortaHTTPS%
echo.
echo Finalizando a configuração da Porta HTTP e Porta HTTPS do Integration Server %IntServer% no Integration Node %IntNode%

echo.
echo *********************************************************************
echo Iniciando a configuração do Embedded Listener do Integration Server %IntServer% no Integration Node %IntNode%
echo.
echo mqsichangeproperties %IntNode% -e %IntServer% -o ExecutionGroup -n httpNodesUseEmbeddedListener -v true
mqsichangeproperties %IntNode% -e %IntServer% -o ExecutionGroup -n httpNodesUseEmbeddedListener -v true
echo.
echo mqsichangeproperties %IntNode% -e %IntServer% -o ExecutionGroup -n soapNodesUseEmbeddedListener -v true
mqsichangeproperties %IntNode% -e %IntServer% -o ExecutionGroup -n soapNodesUseEmbeddedListener -v true
echo.
echo Finalizando a configuração do Embedded Listener do Integration Server %IntServer% no Integration Node %IntNode%

echo.
echo *********************************************************************
echo Iniciando a configuração do File-Based Permissions do Integration Server %IntServer% no Integration Node %IntNode%
echo.
echo mqsichangefileauth %IntNode% -e %IntServer% -o Data -r viewrole -p read+
mqsichangefileauth %IntNode% -e %IntServer% -o Data -r viewrole -p read+
echo.
echo mqsichangefileauth %IntNode% -r iibAdmins -e %IntServer% -p read+,write+,execute+
mqsichangefileauth %IntNode% -r iibAdmins -e %IntServer% -p read+,write+,execute+
echo.
echo mqsichangefileauth %IntNode% -r swaggerui -e %IntServer% -p read+
mqsichangefileauth %IntNode% -r swaggerui -e %IntServer% -p read+
echo.
echo Finalizando a configuração do File-Based Permissions do Integration Server %IntServer% no Integration Node %IntNode%

echo.
echo *********************************************************************
echo Iniciando o Restart do Integration Server %IntServer% no Integration Node %IntNode%
echo.
echo mqsistop %IntNode% -e %IntServer%
mqsistop %IntNode% -e %IntServer%
echo.
echo mqsistart %IntNode% -e %IntServer%
mqsistart %IntNode% -e %IntServer%
echo.
echo Finalizando o Restart do Integration Server %IntServer% no Integration Node %IntNode%

REM ############### LOGGING FINAL ###################
echo [%timestamp%] Finalizado o processamento.
exit /B 0