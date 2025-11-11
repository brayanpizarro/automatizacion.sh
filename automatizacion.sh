#!/bin/bash

mostrar_menu() {
    clear
    echo "==================================="
    echo "      ADMINISTRACION USUARIOS      "
    echo "==================================="
    echo "1. Crear usuario"
    echo "2. Crear contraseña"
    echo "3. Crear grupo"
    echo "4. Añadir usuario a grupo"
    echo "5. Ver datos usuario"
    echo "6. Borrar usuario"
    echo "7. Borrar grupo"
    echo "0. Salir"
    echo "==================================="
}

pausa() {
    read -p "Enter para continuar..."
}

crear_usuario() {
    read -p "Nombre usuario: " usuario
    if id "$usuario" &>/dev/null; then
        echo "Usuario ya existe"
    else
        sudo useradd "$usuario" && echo "Usuario creado" || echo "Error"
    fi
    pausa
}

crear_password() {
    read -p "Usuario: " usuario
    if id "$usuario" &>/dev/null; then
        sudo passwd "$usuario"
    else
        echo "Usuario no existe"
    fi
    pausa
}

crear_grupo() {
    read -p "Nombre grupo: " grupo
    if grep -q "^$grupo:" /etc/group; then
        echo "Grupo ya existe"
    else
        sudo groupadd "$grupo" && echo "Grupo creado" || echo "Error"
    fi
    pausa
}

añadir_a_grupo() {
    read -p "Usuario: " usuario
    read -p "Grupo: " grupo
    if id "$usuario" &>/dev/null && grep -q "^$grupo:" /etc/group; then
        sudo usermod -a -G "$grupo" "$usuario" && echo "Usuario añadido" || echo "Error"
    else
        echo "Usuario o grupo no existe"
    fi
    pausa
}

ver_datos_usuario() {
    read -p "Usuario: " usuario
    if id "$usuario" &>/dev/null; then
        id "$usuario"
        groups "$usuario"
    else
        echo "Usuario no existe"
    fi
    pausa
}

borrar_usuario() {
    read -p "Usuario a borrar: " usuario
    if id "$usuario" &>/dev/null; then
        read -p "¿Borrar? (s/n): " conf
        if [ "$conf" = "s" ]; then
            sudo userdel "$usuario" && echo "Usuario borrado" || echo "Error"
        else
            echo "Cancelado"
        fi
    else
        echo "Usuario no existe"
    fi
    pausa
}

borrar_grupo() {
    read -p "Grupo a borrar: " grupo
    if grep -q "^$grupo:" /etc/group; then
        read -p "¿Borrar? (s/n): " conf
        if [ "$conf" = "s" ]; then
            sudo groupdel "$grupo" && echo "Grupo borrado" || echo "Error"
        else
            echo "Cancelado"
        fi
    else
        echo "Grupo no existe"
    fi
    pausa
}

if [ "$EUID" -ne 0 ]; then
    echo "Ejecute con: sudo $0"
    exit 1
fi

while true; do
    mostrar_menu
    read -p "Opcion [0-7]: " opcion
    case $opcion in
        1) crear_usuario ;;
        2) crear_password ;;
        3) crear_grupo ;;
        4) añadir_a_grupo ;;
        5) ver_datos_usuario ;;
        6) borrar_usuario ;;
        7) borrar_grupo ;;
        0) exit 0 ;;
        *) echo "Opcion no valida" ;;
    esac
done