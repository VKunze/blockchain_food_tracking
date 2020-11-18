lastIndex = 0

if (window.ethereum) {
    window.web3 = new Web3(window.ethereum);
    window.ethereum.enable();
 
    window.cajon = new window.web3.eth.Contract(abi, '0xDbd130C0010CB3948fc7e38Bbc0afE1d93a33cf8');

    window.cajon.events.Transfer({}, function(error, event) {
        console.log(event);
    });
    console.log(obtenerCuentas())

}

async function obtenerCuentas() {
    var cuentas = await window.web3.eth.getAccounts();
    return cuentas; 
}

async function agregarAWhitelist(address, tipoWhitelist) {
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

function agregarPuntoCadena(tokenId, nombreComercial) {
    cuenta = await obtenerCuentas()
    window.cajon.methods.agregarPuntoCadena(tokenId, cuenta[1], nombreComercial)
}

function obtenerIndex(){
    lastIndex= lastIndex+1
    return lastIndex
}