@echo off

REM ############################################################################
REM ## CERTSYS
REM ## Script para criação de Security Profile no ACE.
REM ## Autora: Melina Pereira Nalia Viana
REM ## Criação: 10/02/2025
REM ##
REM ## Uso: 
REM ## createSP.bat IntNode DBName user password SPName
REM ## EX: createSP.bat IN_DEV01 CREDLEMONTECH 5bd477dd5bd17c50e99b54f85061e439 e6bdb3cf70aa12e33757ab954852aaa2 SEGCREDLEMONTECH
REM ##
REM ## IntNode - Nome do Integration Node
REM ## DBName - Nome do DBParms
REM ## user - Usuario
REM ## password - Senha
REM ## SPName - Nome do Security Profile
REM ##
REM ############################################################################

REM Enables delayed expansion
setlocal enabledelayedexpansion
REM Verificar se os parâmetros foram passados

if "%1"=="" (
    echo ERRO: O parâmetro IntNode nao foi fornecido.
    echo Uso: createSP.bat IntNode DBName user password SPName
    exit /B 1
)

if "%2"=="" (
    echo ERRO: O parâmetro DBName nao foi fornecido.
    echo Uso: createSP.bat IntNode DBName user password SPName
    exit /B 1
)

if "%3"=="" (
    echo ERRO: O parâmetro user nao foi fornecido.
    echo Uso: createSP.bat IntNode DBName user password SPName
    exit /B 1
)

if "%4"=="" (
    echo ERRO: O parâmetro password nao foi fornecido.
    echo Uso: createSP.bat IntNode DBName user password SPName
    exit /B 1
)

if "%5"=="" (
    echo ERRO: O parâmetro SPName nao foi fornecido.
    echo Uso: createSP.bat IntNode DBName user password SPName
    exit /B 1
)

REM Iniciando as váriaveis
set "IntNode=%1"
set "DBName=%2"
set "user=%3"
set "password=%4"
set "SPName=%5"
REM Váriaveis iniciadas

REM ############### REGISTRANDO A DATA/HORA ###################
set "timestamp=%DATE% %TIME%"

REM ############### LOGGING INICIAL ###################
echo [%timestamp%] Iniciando o processamento.

echo.
echo *********************************************************************
echo Iniciando a criação do DBParms %DBName% no Integration Node %IntNode%
echo.
echo mqsisetdbparms %IntNode% -n %DBName% -u "%user%" -p "%password%"
mqsisetdbparms %IntNode% -n %DBName% -u "%user%" -p "%password%"
echo.
echo Finalizado a criação do DBParms %DBName% no Integration Node %IntNode%

echo.
echo *********************************************************************
echo Iniciando a criação do Security Profile %SPName% no Integration Node %IntNode%
echo.
echo mqsicreateconfigurableservice %IntNode% -c SecurityProfiles -o %SPName% -n mapping,rejectBlankpassword,propagation,passwordValue,keyStore,authorizationConfig,authenticationConfig,idToPropagateToTransport,trustStore,authentication,authorization,mappingConfig,transportPropagationConfig -v "NONE","TRUE","TRUE","PLAIN","Reserved for future use","","","STATIC ID","Reserved for future use","NONE","NONE","","%DBName%"

mqsicreateconfigurableservice %IntNode% -c SecurityProfiles -o %SPName% -n mapping,rejectBlankpassword,propagation,passwordValue,keyStore,authorizationConfig,authenticationConfig,idToPropagateToTransport,trustStore,authentication,authorization,mappingConfig,transportPropagationConfig -v "NONE","TRUE","TRUE","PLAIN","Reserved for future use","","","STATIC ID","Reserved for future use","NONE","NONE","","%DBName%"
echo.
echo Finalizado a criação do Security Profile %SPName% no Integration Node %IntNode%

REM ############### LOGGING FINAL ###################
echo [%timestamp%] Finalizado o processamento.
exit /B 0