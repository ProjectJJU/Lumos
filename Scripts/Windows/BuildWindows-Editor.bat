set msBuildDir=C:\Program Files\Microsoft Visual Studio\2022\Community\MSBuild\Current\Bin
cd build
"%msBuildDir%\MSBuild.exe" /p:Platform=x64 /p:Configuration=Release /p:DisableFastUpToDateCheck=1 -m Lumos.sln