# Maintainer: chosenundead <https://github.com/ch0senundead>
pkgname=linux-firmware-telefunken-fix
pkgver=1.0
pkgrel=1
pkgdesc="Parche EDID permanente para corregir el color magenta en TV Telefunken (RX 560) en modo BIOS"
arch=('any')
url="https://github.com/ch0senundead/telefunkenFix"
license=('GPL')
provides=('linux-firmware-telefunken-fix')
# Apuntamos a la carpeta edid/ para que makepkg lo encuentre
source=("edid/telefunken_fixed.bin")
sha256sums=('SKIP')

package() {
    install -d "${pkgdir}/usr/lib/firmware/edid"
    # Copiamos el archivo desde la subcarpeta de compilación
    install -m644 "${srcdir}/telefunken_fixed.bin" "${pkgdir}/usr/lib/firmware/edid/telefunken_fixed.bin"
}
