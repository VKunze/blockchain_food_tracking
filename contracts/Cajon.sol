// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/math.sol";
//import "github.com/Arachnid/solidity-stringutils/strings.sol";

contract Cajon is ERC721, Ownable {
    address duenio = 0xf2d516456CF57796029cA68310E075d0c3b5277C; 

    struct UnidadCajon {
        uint256 id;
        string tipoContenido;
        bool exists;
        puntoCadena[] trayecto;
    }

    struct puntoCadena{
        address addressLector;
        uint256 fecha;
        string nombreComercial;
    }

    mapping(address => string) whitelistProductores;
    mapping(address => bool) whitelistPuntosVenta;
    mapping(address => bool) whitelistDistribuidores;
    mapping(uint256 => UnidadCajon) items;

    constructor() ERC721("My ERC721 Token", "MET1")  public {
        
    }

    modifier soloDuenio(){
        require(msg.sender == duenio,"only owner can call this function");
        _;
    }

    modifier isInWhitelistProductores(){
        require(keccak256(abi.encodePacked(whitelistProductores[msg.sender])) != keccak256(abi.encodePacked("")), "is not in the whitelistProductores");
        _;
    }

    modifier isInWhitelistComerciantes(){
        require(whitelistDistribuidores[msg.sender]==true || whitelistPuntosVenta[msg.sender]==true || keccak256(abi.encodePacked(whitelistProductores[msg.sender])) != keccak256(abi.encodePacked("")), "is not in the WhitelistComerciantes");
        _;
    }

    modifier isInWhitelistPuntosVenta(){
        require(whitelistPuntosVenta[msg.sender]==true, "is not in the whitelistPuntosVenta");
        _;
    }

    modifier isInWhitelistDistribuidores(){
        require(whitelistDistribuidores[msg.sender]==true, "is not in the whitelistDistribuidores");
        _;
    }

    function crearCajon(address addressProductor, uint256 tokenId, string memory tipoContenido, uint256 fecha) isInWhitelistProductores public {
        _mint(addressProductor, tokenId);
        items[tokenId].id = tokenId;
        items[tokenId].tipoContenido = tipoContenido;
        items[tokenId].exists = true;
        string memory nombreComercialProductor = whitelistProductores[addressProductor];
        agregarPuntoCadena(tokenId, addressProductor, nombreComercialProductor, fecha);
    }


    function obtenerCajon(uint256 tokenId) public view returns(uint256, string memory, address[] memory,
        uint256[] memory, string[] memory) {
        require(items[tokenId].exists, "the token doesn't exists");

        address[] memory addrs = new address[](items[tokenId].trayecto.length);
        uint[] memory fechas = new uint[](items[tokenId].trayecto.length);
        string[] memory nombres = new string[](items[tokenId].trayecto.length);

        for(uint i=0; i<items[tokenId].trayecto.length; i++){
            puntoCadena storage ptoCadena = items[tokenId].trayecto[i];
            addrs[i] = ptoCadena.addressLector;
            fechas[i] = ptoCadena.fecha;
            nombres[i] = ptoCadena.nombreComercial;
        }
        return (items[tokenId].id, items[tokenId].tipoContenido, addrs, fechas, nombres);
    }

    function destruirCajon(uint256 tokenId) isInWhitelistPuntosVenta public {
        require(ownerOf(tokenId) == msg.sender, "is not the owner");
        _burn(tokenId);
        items[tokenId].id = 0;
        items[tokenId].tipoContenido = '';
        delete items[tokenId].trayecto;
        items[tokenId].exists = false;
    }

    function agregarPuntoCadena(uint256 tokenId, address addressLector, string memory nombreComercial, uint256 fecha) isInWhitelistComerciantes public {
        puntoCadena memory nuevoPuntoCadena = puntoCadena({addressLector: addressLector, fecha: fecha, nombreComercial: nombreComercial});
        items[tokenId].trayecto.push(nuevoPuntoCadena);
    }

    function addToWhitelistProductores(address account, string memory nombreComercial) soloDuenio public{
        whitelistProductores[account] = nombreComercial;

    }

    function addToWhitelistPuntosVenta(address account) soloDuenio public{
        whitelistPuntosVenta[account] = true;
    }
    
    function addToWhitelistDistribuidores(address account) soloDuenio public{
        whitelistDistribuidores[account] = true;
    }

     function removeFromWhitelistProductores(address account) soloDuenio public{
        whitelistProductores[account] = "";
    }

    function removeFromWhitelistPuntosVenta(address account) soloDuenio public{
        whitelistPuntosVenta[account] = false;
    }

    function removeFromWhitelistDistribuidores(address account) soloDuenio public{
        whitelistDistribuidores[account] = false;
    }
    
}
