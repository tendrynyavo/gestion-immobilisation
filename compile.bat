set TOMCAT_PATH=D:\Server-local\Tomcat-10.1

if exist "target" (
    rmdir /s /q .\target
)

@REM Build target for project
mkdir .\target
mkdir .\target\WEB-INF
mkdir .\target\WEB-INF\classes
mkdir .\target\WEB-INF\lib
mkdir .\target\assets
mkdir .\target\controller

Xcopy lib .\target\WEB-INF\lib /E /H /C /I /Y
copy .\web.xml .\target\WEB-INF\
copy .\config.xml .\target\WEB-INF\classes

@REM Copy Front-end
@REM Xcopy assets .\target\assets /E /H /C /I /Y
Xcopy view .\target\ /E /H /C /I /Y
Xcopy controller .\target\controller /E /H /C /I /Y

@REM  Compile all java file
dir src /b /s .\src\*.java > file.txt
findstr /i .java file.txt > sources.txt
javac -source 11 -target 11 -parameters -cp ./lib/* -d ./target/WEB-INF/classes/ @sources.txt
if %errorlevel% neq 0 ( exit /b %errorlevel% )
del "file.txt"
del "sources.txt"

@REM @REM Convert into .war
cd target
jar -cvf "immobilisation.war" *
move "immobilisation.war" "%TOMCAT_PATH%\webapps"
@REM scp ./poketra.war tendry@172.20.3.105:~/apache-tomcat-10.0.27/webapps
cd ..