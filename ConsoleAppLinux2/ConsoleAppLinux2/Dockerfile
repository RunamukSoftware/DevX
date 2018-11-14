FROM microsoft/dotnet:2.1-runtime AS base
WORKDIR /app

FROM microsoft/dotnet:2.1-sdk AS build
WORKDIR /src
COPY ConsoleAppLinux2/ConsoleAppLinux2.csproj ConsoleAppLinux2/
RUN dotnet restore ConsoleAppLinux2/ConsoleAppLinux2.csproj
COPY . .
WORKDIR /src/ConsoleAppLinux2
RUN dotnet build ConsoleAppLinux2.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish ConsoleAppLinux2.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "ConsoleAppLinux2.dll"]
