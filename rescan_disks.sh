#!/bin/bash

#Para discos existentes
# Escanear automáticamente todos los discos en el sistema

for dispositivo in $(ls /sys/class/block/ | grep -vE "loop|ram"); do
    dispositivo="/dev/$dispositivo"
    echo "Escaneando $dispositivo..."
    echo 1 > "/sys/class/block/${dispositivo##*/}/device/rescan"
    if [ $? -eq 0 ]; then
        echo "Escaneo del disco $dispositivo exitoso."
        echo "Nuevo tamaño del disco $dispositivo:"
        fdisk -l $dispositivo
    else
        echo "Error al escanear el disco $dispositivo."
    fi
done

##################################################################################################
#Para nuevos discos
# Escanear automáticamente todos los controladores SCSI para recargar la tabla de particiones

for host in /sys/class/scsi_host/host*/scan; do
  echo "- - -" > "$host"
done
 
echo "Recarga de tablas de particiones completada."
