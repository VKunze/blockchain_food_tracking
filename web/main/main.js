lastIndex = 0

exports.arrancarSmartContract = (abi) => {
    
}

async function obtenerCuentas() {
    var cuentas = await window.web3.eth.getAccounts();
    return cuentas; 
}

async function agregarAWhitelist(address, tipoWhitelist) {
    console.log("in main")
    if(tipoWhitelist == "productores"){
        window.cajon.methods.addToWhitelistProductores(address).send();
    } else if(tipoWhitelist == "distribuidores"){
        window.cajon.methods.addToWhitelistDistribuidores(address).send();    
    } else if(tipoWhitelist == "puntosVenta"){
        window.cajon.methods.isInWhitelistPuntosVenta(address).send();    
    }
}

// Productor: 0

async function crearCajon(tipoContenido, nombreComercialProductor) {
    cuenta = await obtenerCuentas()
    window.cajon.methods.crearCajon(cuenta[0], obtenerIndex(), tipoContenido, nombreComercialProductor)
    console.log("ee")
}

async function obtenerCajon(tokenId){
    (id, tipoContenido, trayecto) = await window.cajon.methods.obtenerCajon(tokenId)
    return (id, tipoContenido, trayecto)
}

async function agregarPuntoCadena(tokenId, nombreComercial) {
    cuenta = await obtenerCuentas()
    window.cajon.methods.agregarPuntoCadena(tokenId, cuenta[1], nombreComercial)
}

function obtenerIndex(){
    lastIndex= lastIndex+1
    return lastIndex
}

document.addEventListener("DOMContentLoaded", async function(event) {
    document.querySelector("#registrarProductor").addEventListener("click", async function() {
    console.log("LLLLLLEEEEEEEEGGGGGGGGGGGOOOOOOOOOOOOOOOOOOOOOOOOOOOOOo")
        var address = document.getElementById("address").value
        var tipoWhitelist = document.getElementById("rubro").value
        console.log("in agregar prod")
        await agregarAWhitelist(address, tipoWhitelist)
        console.log("SUCCESS!")
    });

    document.addEventListener("#agregarUbicacion").addEventListener("click", async function() {
        tokenId = document.getElementById("???").innerHTML
        nombreComercial =  document.getElementById("???").innerHTML
        await agregarPuntoCadena(tokenId, nombreComercial)

    });

    document.querySelector("#buscarLote").addEventListener("click", async function() {
        var tokenId = document.getElementById("idToken").value
        /* await obtenerCajon(tokenId) */
        document.getElementById("detallesCajon").style.display = "block"
        
    });
})

