// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.7.0;
pragma experimental ABIEncoderV2;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/math/math.sol";

contract Cajon is ERC721, Ownable {

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

    mapping(address => bool) whitelistProductores;
    mapping(address => bool) whitelistPuntosVenta;
    mapping(address => bool) whitelistDistribuidores;
    mapping(uint256 => UnidadCajon) items;

    constructor() ERC721("My ERC721 Token", "MET1")  public {
        
    }

    modifier isInWhitelistProductores(){
        require(whitelistProductores[msg.sender]==true, "is not in the whitelistProductores");
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

    function crearCajon(address addressProductor, uint256 tokenId, string memory tipoContenido, string memory nombreComercialProductor) isInWhitelistProductores public {
        _mint(addressProductor, tokenId);
        items[tokenId].id = tokenId;
        items[tokenId].tipoContenido = tipoContenido;
        items[tokenId].exists = true;
        agregarPuntoCadena(tokenId,addressProductor,nombreComercialProductor);
    }

    function obtenerCajon(uint256 tokenId) public view returns(uint256, string memory, puntoCadena[] memory) {
        require(items[tokenId].exists, "the token doesn't exists");
        return (items[tokenId].id, items[tokenId].tipoContenido,items[tokenId].trayecto);
    }

    function destruirCajon(uint256 tokenId) isInWhitelistPuntosVenta public {
        require(ownerOf(tokenId) == msg.sender, "is not the owner");
        _burn(tokenId);
        items[tokenId].id = 0;
        items[tokenId].tipoContenido = '';
        delete items[tokenId].trayecto;
        items[tokenId].exists = false;
    }

    function agregarPuntoCadena(uint256 tokenId, address addressLector, string memory nombreComercial) isInWhitelistDistribuidores isInWhitelistPuntosVenta public {
        uint256 fecha = now;
        puntoCadena memory nuevoPuntoCadena = puntoCadena({addressLector: addressLector, fecha: fecha, nombreComercial: nombreComercial});
        items[tokenId].trayecto.push(nuevoPuntoCadena);
    }

    function addToWhitelistProductores(address account) onlyOwner public{
        whitelistProductores[account] = true;
    }

    function addToWhitelistPuntosVenta(address account) onlyOwner public{
        whitelistPuntosVenta[account] = true;
    }
    
    function addToWhitelistDistribuidores(address account) onlyOwner public{
        whitelistDistribuidores[account] = true;
    }

     function removeFromWhitelistProductores(address account) onlyOwner public{
        whitelistProductores[account] = false;
    }

    function removeFromWhitelistPuntosVenta(address account) onlyOwner public{
        whitelistPuntosVenta[account] = false;
    }

    function removeFromWhitelistDistribuidores(address account) onlyOwner public{
        whitelistDistribuidores[account] = false;
    }
    
}
