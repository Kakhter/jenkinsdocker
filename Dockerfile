#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /App
EXPOSE 80
EXPOSE 443
EXPOSE 14041
EXPOSE 5000
EXPOSE 5001
ENV ASPNETCORE_ENVIRONMENT=Development
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["webapidocker.csproj", "."]
RUN dotnet restore "./webapidocker.csproj"
COPY . .
WORKDIR "/src/."
RUN dotnet build "webapidocker.csproj" -c Release -o /App/build

FROM build AS publish
RUN dotnet publish "webapidocker.csproj" -c Release -o /App/publish

FROM base AS final
WORKDIR /App
COPY --from=publish /App/publish .
ENTRYPOINT ["dotnet", "webapidocker.dll"]
