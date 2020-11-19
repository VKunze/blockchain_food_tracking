lastIndex = 0


async function obtenerCuentas() {
    var cuentas = await window.web3.eth.getAccounts();
    return cuentas;
}

async function agregarAWhitelist(address, tipoWhitelist) {
    console.log("in main")
    if (tipoWhitelist == "productores") {
        window.cajon.methods.addToWhitelistProductores(address).send();
    } else if (tipoWhitelist == "distribuidores") {
        window.cajon.methods.addToWhitelistDistribuidores(address).send();
    } else if (tipoWhitelist == "puntosVenta") {
        window.cajon.methods.isInWhitelistPuntosVenta(address).send();
    }
}

// Productor: 0

async function crearCajon(tipoContenido, nombreComercialProductor) {
    cuenta = await obtenerCuentas()
    window.cajon.methods.crearCajon(cuenta[0], obtenerIndex(), tipoContenido, nombreComercialProductor)
    console.log("ee")
}

async function obtenerCajon(tokenId) {
    [id, tipoContenido, trayecto] = await window.cajon.methods.obtenerCajon(tokenId)
    return (id, tipoContenido, trayecto)
}

async function agregarPuntoCadena(tokenId, nombreComercial) {
    cuenta = await obtenerCuentas()
    window.cajon.methods.agregarPuntoCadena(tokenId, cuenta[1], nombreComercial)
}

function obtenerIndex() {
    lastIndex = lastIndex + 1
    return lastIndex
}

document.addEventListener("DOMContentLoaded", async function (event) {
    if (document.querySelector("#registrar")) {
        console.log("Entro")
        document.querySelector("#registrar").addEventListener("click", async function () {
            console.log("LLLLLLEEEEEEEEGGGGGGGGGGGOOOOOOOOOOOOOOOOOOOOOOOOOOOOOo")
            var address = document.getElementById("address").value
            var tipoWhitelist = document.getElementById("rubro").value
            console.log("in agregar prod")
            await agregarAWhitelist(address, tipoWhitelist)
            console.log("SUCCESS!")
        });
    }
    if(document.querySelector("#agregarUbicacion")){
        document.querySelector("#agregarUbicacion").addEventListener("click", async function() {
            tokenId = document.getElementById("???").innerHTML
            nombreComercial =  document.getElementById("???").innerHTML
            await agregarPuntoCadena(tokenId, nombreComercial)
    
        });
    }
    if(document.querySelector("#buscarLote")){
        document.querySelector("#buscarLote").addEventListener("click", async function() {
            console.log("HI")
            var tokenId = document.getElementById("idToken").value
            [id, tipoContenido, trayecto]= await obtenerCajon(tokenId)  
            document.getElementById("detallesCajon").style.display = "block"
            document.getElementById("tipoContenidoCajon").innerHTML= tipoContenido
            document.getElementById("trayectoCajon").innerHTML= trayecto
            
            
        });
    }
})

