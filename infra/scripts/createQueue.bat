@echo off

REM ############################################################################
REM ## CERTSYS
REM ## Script para criação de novas filas MQ.
REM ## Autora: Melina Pereira Nalia Viana
REM ## Criação: 10/02/2025
REM ##
REM ## Uso: 
REM ## createQueue.bat QM MQSC
REM ## EX: createQueue.bat QM.IIB01.DEV E:\artefatosImplantacao\filasMQ\ApiOmniSaudeV1_OS211.mqsc
REM ## 
REM ## QM - Nome da Queue Manager
REM ## MQSC - Caminho onde do arquivo.mqsc
REM ##
REM ############################################################################

REM Enables delayed expansion
setlocal enabledelayedexpansion

REM Verificar se os parâmetros foram passados
if "%1"=="" (
    echo ERRO: O parâmetro QM nao foi fornecido.
    echo Uso: createQueue.bat QM MQSC
    exit /B 1
)

if "%2"=="" (
    echo ERRO: O parâmetro MQSC nao foi fornecido.
    echo Uso: createQueue.bat QM MQSC
    exit /B 1
)

REM Iniciando as váriaveis
set "QM=%1"
set "MQSC=%2"
REM Váriaveis iniciadas

REM ############### REGISTRANDO A DATA/HORA ###################
set "timestamp=%DATE% %TIME%"

REM ############### LOGGING INICIAL ###################
echo [%timestamp%] Iniciando o processamento.

echo.
echo *********************************************************************
echo Iniciando a execução do script %MQSC% no Queue Manager %QM%
echo.
echo runmqsc %QM%  %MQSC%
runmqsc %QM%  %MQSC%
echo.
echo Finalizado a execução do script %MQSC% no Queue Manager %QM%
	
REM ############### LOGGING FINAL ###################
echo [%timestamp%] Finalizado o processamento.
exit /B 0
