@echo off

REM ############################################################################
REM ## CERTSYS
REM ## Script para stop e start de Integration Node.
REM ## Autora: Melina Pereira Nalia Viana
REM ## Criação: 10/02/2025
REM ##
REM ## Uso: 
REM ## stopStartIntNode.bat IntNode
REM ## EX: stopStartIntNode.bat IN_DEV01
REM ##
REM ## IntNode - Nome do Integration Node
REM ##
REM ############################################################################

REM Enables delayed expansion
setlocal enabledelayedexpansion

REM Verificar se o parâmetro foi passado
if "%1"=="" (
    echo ERRO: O parâmetro IntNode nao foi fornecido.
    echo Uso: stopStartIntNode.bat IntNode
    exit /B 1
)

REM Iniciando as váriaveis
set "IntNode=%1""
REM Váriaveis iniciadas

REM ############### REGISTRANDO A DATA/HORA ###################
set "timestamp=%DATE% %TIME%"

REM ############### LOGGING INICIAL ###################
echo [%timestamp%] Iniciando o processamento.

echo.
echo *********************************************************************
echo Iniciando o Stop do Integration Server %IntServer% no Integration Node %IntNode%
echo.
echo mqsistop %IntNode%
mqsistop %IntNode%
echo.
echo Finalizando o Stop do Integration Server %IntServer% no Integration Node %IntNode%

echo.
echo *********************************************************************
echo Iniciando o Start do Integration Server %IntServer% no Integration Node %IntNode%
echo.
echo mqsistart %IntNode%
mqsistart %IntNode%
echo.
echo Finalizando o Start do Integration Server %IntServer% no Integration Node %IntNode%

REM ############### LOGGING FINAL ###################
echo [%timestamp%] Finalizado o processamento.
exit /B 0