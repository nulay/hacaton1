@echo off
set CATALINA_HOME=D:\raznoe\progi\apache-tomcat-9.0.116
echo Stopping Tomcat...
call "%CATALINA_HOME%\bin\shutdown.bat"
timeout /t 5 /nobreak >nul
echo Tomcat stopped.
