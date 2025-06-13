class Nave {
    var velocidad = 0
    var direccion = 0
    var combustible = 0

    method acelerar(cuanto) {velocidad = (velocidad + cuanto).min(100000)}
    method desacelerar(cuanto) {velocidad = (velocidad - cuanto).max(0)}

    method irHaciaElSol() {direccion = 10}
    method escaparDelSol() {direccion = -10}
    method ponerseParaleloAlSol() {direccion = 0}

    method acercarseUnPocoAlSol() {direccion = (direccion + 1).min(10)}
    method alejarseUnPocoAlSol() {direccion = (direccion - 1).max(-10)}

    method cargarCombustible(cuanto) {combustible = combustible + cuanto}
    method descargarCombustible(cuanto) {combustible = (combustible - cuanto).max(0)}

    method estaTranquila() = (4000 < combustible) and (velocidad <= 12000)

    method estaRelajada() = self.estaTranquila()
}

class NaveBaliza inherits Nave {
    var cantCambiosBaliza = 0
    
    var color

    method cambiarColorDeBaliza(colorNuevo) {
        if(not vialidadEspacial.coloresValidos.contains(colorNuevo)){
            self.error(colorNuevo.toString() + " no es un color válido")
        }
        color = colorNuevo
        cantCambiosBaliza += 1
    }

    method prepararViaje() {
        self.cargarCombustible(30000)
        self.cambiarColorDeBaliza("verde")
        self.ponerseParaleloAlSol()
        self.acelerar(5000)
    }

    override method estaTranquila() = super() and (! color == "rojo")

    method recibirAmenaza() {
        self.escapar()
        self.avisar()
    }
    method escapar() {self.irHaciaElSol()}
    method avisar() {self.cambiarColorDeBaliza("rojo")}

    override method estaRelajada() = super() and cantCambiosBaliza < 1
}

object vialidadEspacial {
    const property coloresValidos = ["Verde", "rojo", "azul"]
}

class NavePasajeros inherits Nave {
    var cantRacionesComidaServidas = 0

    const pasajeros
    var racionesComida = 0
    var racionesBebida = 0

    method cargarComida(unaCant) {racionesComida = racionesComida + unaCant}
    method descargarComida(unaCant) {racionesComida = (racionesComida - unaCant).max(0)}
    method servirComida(unaCant) {
        self.descargarComida(unaCant)
        cantRacionesComidaServidas += unaCant
    }

    method cargarBebida(unaCant) {racionesBebida = racionesBebida + unaCant}
    method descargarBebida(unaCant) {racionesBebida = (racionesBebida - unaCant).max(0)}

    method prepararViaje() {
        self.cargarCombustible(30000)
        self.cargarComida(4 * pasajeros)
        self.cargarBebida(6 * pasajeros)
        self.acercarseUnPocoAlSol()
        self.acelerar(5000)
    }

    method recibirAmenaza() {
        self.escapar()
        self.avisar()
    }
    method escapar() {self.acelerar(velocidad)}
    method avisar() {
        self.servirComida(pasajeros)
        self.descargarBebida(pasajeros * 2)
    }

    override method estaRelajada() = super() and cantRacionesComidaServidas < 50
}

class NaveCombate inherits Nave {
    var estaVisible = true
    var misilesDesplegados = false
    const mensajes = []

    method ponerseVisible() {estaVisible = true}
    method ponerseInvisible() {estaVisible = false}
    method estaVisible() = estaVisible

    method desplegarMisiles() {misilesDesplegados = true}
    method replegarMisiles() {misilesDesplegados = false}
    method misilesDesplegados() = misilesDesplegados

    method emitirMensaje(mensaje) {mensajes.add(mensaje)}
    method mensajesEmitidos() = mensajes
    method primerMensajeEmitido() = mensajes.first()
    method ultimoMensajeEmitido() = mensajes.last()
    method esEscueta() = mensajes.all{x=>x.lenght() < 30}
    method emitioMensaje(mensaje) = mensajes.any{x=>x == mensaje}

    method prepararViaje() {
        self.cargarCombustible(30000)
        self.emitirMensaje("Saliendo en misión")
        self.acelerar(5000)
        self.ponerseVisible()
        self.replegarMisiles()
        self.acelerar(15000)
    }

    override method estaTranquila() = super() and not misilesDesplegados

    method recibirAmenaza() {
        self.escapar()
        self.avisar()
    }
    method escapar() {
        self.acercarseUnPocoAlSol()
        self.acercarseUnPocoAlSol()
    }
    method avisar() {self.emitirMensaje("Amenaza recibida")}
}

class NaveHospital inherits NavePasajeros {
    var quirofanosPreparados = false

    method prepararQuirofanos() {quirofanosPreparados = true}

    override method estaTranquila() = super() and not quirofanosPreparados

    override method recibirAmenaza() {
        super()
        self.prepararQuirofanos()
    }
}

class NaveCombateSigilosa inherits NaveCombate {
    override method estaTranquila() = super() and estaVisible

    override method escapar() {
        super()
        self.desplegarMisiles()
        self.ponerseInvisible()
    }
}