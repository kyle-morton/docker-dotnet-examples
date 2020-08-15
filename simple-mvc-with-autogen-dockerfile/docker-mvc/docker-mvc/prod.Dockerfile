FROM mcr.microsoft.com/dotnet/core/aspnet:3.1 AS base
WORKDIR /app
EXPOSE 5000

FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /src
COPY ["docker-mvc.csproj", "./"]
RUN dotnet restore "./docker-mvc.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "docker-mvc.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "docker-mvc.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "docker-mvc.dll"]
