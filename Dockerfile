FROM microsoft/dotnet-framework-build:latest

SHELL ["powershell", "-Command", "$ErrorActionPreference = 'Stop'; $ProgressPreference = 'SilentlyContinue';"]

RUN [Environment]::SetEnvironmentVariable('JAVA_PKG', 'java-9-openjdk-9.0.4-1.b11.ojdkbuild.windows.x86_64', [EnvironmentVariableTarget]::Machine)

RUN [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12 ;\
	 Invoke-WebRequest -Uri "https://github.com/ojdkbuild/ojdkbuild/releases/download/9.0.4-1/${env:JAVA_PKG}.zip" -OutFile 'openjdk.zip' -UseBasicParsing ; \
     Add-Type -AssemblyName System.IO.Compression.FileSystem ; \
     [System.IO.Compression.ZipFile]::ExtractToDirectory('.\openjdk.zip', 'C:\Program Files\'); \
     rm openjdk.zip;

RUN [Environment]::SetEnvironmentVariable('JAVA_HOME', $env:ProgramFiles + '\' + $env:JAVA_PKG, [EnvironmentVariableTarget]::Machine)
RUN [Environment]::SetEnvironmentVariable('Path', $env:Path + ';' + $env:JAVA_HOME + '\bin', [EnvironmentVariableTarget]::Machine)
