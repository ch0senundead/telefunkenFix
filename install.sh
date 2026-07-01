#!/usr/bin/env bash

# Detener el script si algo falla
set -e

echo "=== Iniciando automatización del Fix de Color para Telefunken ==="

# 1. Compilar e instalar el paquete nativo de Arch
echo "-> Compilando e instalando el firmware modificado..."
makepkg -si --noconfirm

# 2. Modificar /etc/mkinitcpio.conf si no está configurado
echo "-> Configurando mkinitcpio..."
if ! grep -q "telefunken_fixed.bin" /etc/mkinitcpio.conf; then
    # Insertar el módulo amdgpu y el archivo si están vacíos o por defecto
    sudo sed -i 's/^MODULES=(/MODULES=(amdgpu /' /etc/etc/mkinitcpio.conf 2>/dev/null || true
    sudo sed -i 's|^FILES=(|FILES=(/usr/lib/firmware/edid/telefunken_fixed.bin |' /etc/mkinitcpio.conf
    echo "-> Configuración añadida a mkinitcpio.conf."
else
    echo "-> mkinitcpio.conf ya estaba configurado."
fi

# Regenerar la imagen del Kernel Zen (o el que esté activo)
sudo mkinitcpio -P

# 3. Configurar parámetros en el GRUB
echo "-> Configurando parámetros de arranque en GRUB..."
if ! grep -q "drm.edid_firmware=HDMI-A-1:edid/telefunken_fixed.bin" /etc/default/grub; then
    # Inserta el parámetro dentro de las comillas de GRUB_CMDLINE_LINUX_DEFAULT
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="/GRUB_CMDLINE_LINUX_DEFAULT="drm.edid_firmware=HDMI-A-1:edid\/telefunken_fixed.bin /' /etc/default/grub
    echo "-> Parámetro añadido a /etc/default/grub."
else
    echo "-> El parámetro de GRUB ya existía."
fi

# Actualizar el menú del GRUB
echo "-> Actualizando grub.cfg..."
sudo grub-mkconfig -o /boot/grub/grub.cfg

echo "=== ¡Todo listo! Reiniciá para aplicar los cambios sin magenta ==="
