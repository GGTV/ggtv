echo off

set CLASSPATH=.;build\WEB-INF\classes

set LOCALCLASSPATH=%CLASSPATH%
for %%i in (".\lib\*.jar") do call ".\lcp.bat" %%i
set CLASSPATH=%LOCALCLASSPATH%

echo off

java -cp %CLASSPATH% -Xms128m -Xmx384m -XX:+UseParNewGC -XX:+UseConcMarkSweepGC %*