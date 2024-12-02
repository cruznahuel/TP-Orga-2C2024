# El Asalto

Trabajo en contexto de TP-Orga-2C2024.

Se debe instalar la versión 2.16.01 de NASM.

Actualización de los repositorios de la distribución y actualización de la distribución.
```sh
sudo apt-get update
sudo apt-get upgrade
```

Debido a que la version 2.16.1 no se encuentra en el repositorio de paquetes de ubuntu 22.04, se debe instalar su archivo rpm.
Para instalar un gestor de paquetes rpm.
```sh
sudo apt install alien
```
Descarga de archivo rpm.
```sh
wget https://www.nasm.us/pub/nasm/releasebuilds/2.16.01/linux
/nasm-2.16.01-0.fc36.x86_64.rpm
```
Para instalar el paquete:
```sh
sudo alien -i nasm-2.16.01-0.fc36.x86_64.rpm
```

- Para ensamblar con NASM 2.16.01:
```sh
nasm asalto.asm -f elf64 -g
```

- Para compilar:
```sh
gcc asalto.o -no-pie -o asalto
```

- Para ejecutar:
```sh
./asalto 
```
