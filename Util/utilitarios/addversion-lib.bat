echo off

SET APP2=app2\
SET APP3=app3\
SET APP4=app4\
SET FULL_PATH_BAR_NAME=%1
SET BAR_NAME=%2
SET VERSAO=%3
SET WORKSPACE_LOCATION=%4

@echo off
	CALL echo $MQSI_VERSION=%VERSAO% MQSI$ > keywords.txt
	CALL mkdir %APP2%
	CALL copy %FULL_PATH_BAR_NAME% %APP2%
	CALL ren %APP2%%BAR_NAME%-%VERSAO%.bar %BAR_NAME%-%VERSAO%.zip
    CALL mkdir %APP3%
	CALL 7z x %APP2%%BAR_NAME%-%VERSAO%.zip -o%APP3%	
	CALL ren %APP3%%BAR_NAME%.shlibzip %BAR_NAME%.zip
	CALL mkdir %APP4%
	CALL 7z x %APP3%%BAR_NAME%.zip -o%APP4%
	CALL copy keywords.txt %APP4%META-INF
	CALL copy ..\deployedBars\LibFuncoesUtilsJava.jar %APP4%
	CALL del %APP3%%BAR_NAME%.zip
	CALL cd %APP4%
	CALL 7z a %BAR_NAME%.zip
	CALL cd..	
	CALL ren %APP4%%BAR_NAME%.zip %BAR_NAME%.shlibzip
	CALL copy %APP4%%BAR_NAME%.shlibzip %APP3%
	CALL del %APP2%%BAR_NAME%-%VERSAO%.zip
	CALL cd %APP3%
	CALL 7z a %BAR_NAME%.zip
	CALL cd..
	CALL ren %APP3%%BAR_NAME%.zip %BAR_NAME%-%VERSAO%.bar
	CALL copy %APP3%%BAR_NAME%-%VERSAO%.bar
	CALL rd %APP2% /s /q
	CALL rd %APP3% /s /q
	CALL rd %APP4% /s /q
	CALL del keywords.txt
	CALL move %BAR_NAME%-%VERSAO%.bar %WORKSPACE_LOCATION%	
@echo on
