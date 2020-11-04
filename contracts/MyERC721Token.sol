// SPDX-License-Identifier: MIT
pragma solidity >=0.4.25 <0.7.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract Cajon is ERC721, Ownable {

    struct UnidadCajon {
        uint256 id;
        string tipoContenido;
        uint256 idProductor;
        bool exists;
    }

    struct puntoCadena{
        uint256 idLector;
        uint256 fecha;
    }

    mapping(uint256 => MyTokenItem) items;

    constructor() ERC721("My ERC721 Token", "MET1")  public {
        
    }

    function createToken(address to, uint256 tokenId, string memory tipoContenido, uint256 idProductor) public {
        _mint(to, tokenId);
        items[tokenId].id = tokenId;
        items[tokenId].tipoContenido = tipoContenido;
        items[tokenId].idProductor = idProductor;
        items[tokenId].exists = true;
    }

    function getItem(uint256 tokenId) public view returns(uint256, string memory) {
        require(items[tokenId].exists, "the token doesn't exists");
        return (items[tokenId].id, items[tokenId].name);
    }

    function deleteToken(uint256 tokenId) public {
        require(ownerOf(tokenId) == msg.sender, "is not the owner");
        _burn(tokenId);
        items[tokenId].id = 0;
        items[tokenId].name = '';
        items[tokenId].exists = false;
    }

}
