@echo off

REM ############################################################################
REM ## CERTSYS
REM ## Script para stop e start de Integration Server.
REM ## Autora: Melina Pereira Nalia Viana
REM ## Criação: 10/02/2025
REM ##
REM ## Uso: 
REM ## stopStartIntServer.bat IntNode IntServer
REM ## EX: stopStartIntServer.bat IN_DEV01 IS_Saude
REM ##
REM ## IntNode - Nome do Integration Node
REM ## IntServer - Nome do Integration Server
REM ##
REM ############################################################################

REM Enables delayed expansion
setlocal enabledelayedexpansion

REM Verificar se os parâmetros foram passados
if "%1"=="" (
    echo ERRO: O parâmetro IntNode nao foi fornecido.
    echo Uso: stopStartIntNode.bat IntNode IntServer
    exit /B 1
)

if "%2"=="" (
    echo ERRO: O parâmetro IntServer nao foi fornecido.
    echo Uso: stopStartIntNode.bat IntNode IntServer
    exit /B 1
)

REM Iniciando as váriaveis
set "IntNode=%1"
set "IntServer=%2"
REM Váriaveis iniciadas

REM ############### REGISTRANDO A DATA/HORA ###################
set "timestamp=%DATE% %TIME%"

REM ############### LOGGING INICIAL ###################
echo [%timestamp%] Iniciando o processamento.

echo.
echo *********************************************************************
echo Iniciando o Stop do Integration Server %IntServer% no Integration Node %IntNode%
echo.
echo mqsistop %IntNode% -e %IntServer% 
mqsistop %IntNode% -e %IntServer% 
echo.
echo Finalizando o Stop do Integration Server %IntServer% no Integration Node %IntNode%

echo.
echo *********************************************************************
echo Iniciando o Start do Integration Server %IntServer% no Integration Node %IntNode%
echo.
echo mqsistart %IntNode% -e %IntServer% 
mqsistart %IntNode% -e %IntServer% 
echo.
echo Finalizando o Start do Integration Server %IntServer% no Integration Node %IntNode%

REM ############### LOGGING FINAL ###################
echo [%timestamp%] Finalizado o processamento.
exit /B 0

