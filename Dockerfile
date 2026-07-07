FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build
WORKDIR /src

# copy csproj and restore first for better layer caching
COPY ParkingManagement.csproj ./
RUN dotnet restore "ParkingManagement.csproj"

# copy the rest and publish
COPY . .
RUN dotnet publish "ParkingManagement.csproj" -c Release -o /app/publish /p:UseAppHost=false

FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

ENV ASPNETCORE_URLS="http://+:80"
EXPOSE 80
ENTRYPOINT ["dotnet","ParkingManagement.dll"]
