# Imagen base de .NET para ejecutar la aplicación
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

# Imagen para compilar la aplicación
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src
COPY ["AwsFargateApp.csproj", "./"]
RUN dotnet restore "./AwsFargateApp.csproj"

COPY . .
RUN dotnet publish "./AwsFargateApp.csproj" -c Release -o /app/publish

# Imagen final para ejecutar la aplicación
FROM base AS final
WORKDIR /app
COPY --from=build /app/publish .
ENTRYPOINT ["dotnet", "AwsFargateApp.dll"]
