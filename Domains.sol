// SPDX-License-Identifier: UNLICENSED

pragma solidity 0.8.17;

import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import {StringUtils} from "./libraries/StringUtils.sol";
import "@openzeppelin/contracts/utils/Base64.sol";
import "hardhat/console.sol";

contract Domains is ERC721URIStorage {
    error Unauthorized();
    error AlreadyRegistered();
    error InvalidName(string name);

    using Counters for Counters.Counter;
    address payable public owner;

    Counters.Counter private _tokenIds;

    string public tld;

    string svgPartOne =
        '<svg width="254" height="278" viewBox="0 0 254 278" fill="none" xmlns="http://www.w3.org/2000/svg"><rect x="4" y="8" width="250" height="270" rx="20" fill="#252525"/><mask id="mask0_0_1" style="mask-type:alpha" maskUnits="userSpaceOnUse" x="4" y="8" width="250" height="270"><rect x="4" y="8" width="250" height="270" rx="20" fill="#252525"/></mask><g mask="url(#mask0_0_1)"><path d="M88.0078 253.4H102.607V268H88.0078V253.4ZM111.266 197.188C111.266 195.575 111.573 194.058 112.188 192.637C112.802 191.177 113.647 189.929 114.723 188.892C115.798 187.816 117.047 186.971 118.468 186.356C119.927 185.703 121.464 185.377 123.077 185.377H160.816C162.43 185.377 163.947 185.703 165.368 186.356C166.828 186.971 168.095 187.816 169.171 188.892C170.246 189.929 171.091 191.177 171.706 192.637C172.321 194.058 172.628 195.575 172.628 197.188V207.848H160.816V197.188H123.077V220.812H160.816C162.43 220.812 163.947 221.119 165.368 221.733C166.828 222.348 168.095 223.193 169.171 224.269C170.246 225.344 171.091 226.612 171.706 228.071C172.321 229.493 172.628 231.01 172.628 232.623V256.188C172.628 257.802 172.321 259.338 171.706 260.798C171.091 262.219 170.246 263.467 169.171 264.543C168.095 265.618 166.828 266.464 165.368 267.078C163.947 267.693 162.43 268 160.816 268H123.077C121.464 268 119.927 267.693 118.468 267.078C117.047 266.464 115.798 265.618 114.723 264.543C113.647 263.467 112.802 262.219 112.188 260.798C111.573 259.338 111.266 257.802 111.266 256.188V197.188ZM123.077 232.623V256.188H160.816V232.623H123.077ZM243.451 256.188C243.451 257.802 243.144 259.338 242.529 260.798C241.915 262.219 241.069 263.467 239.994 264.543C238.918 265.618 237.651 266.464 236.191 267.078C234.77 267.693 233.253 268 231.639 268H193.9C192.287 268 190.75 267.693 189.291 267.078C187.87 266.464 186.621 265.618 185.546 264.543C184.47 263.467 183.625 262.219 183.011 260.798C182.396 259.338 182.089 257.802 182.089 256.188V245.587H193.9V256.188H231.639V232.623H193.9C192.287 232.623 190.75 232.316 189.291 231.701C187.87 231.048 186.621 230.203 185.546 229.166C184.47 228.09 183.625 226.842 183.011 225.421C182.396 223.961 182.089 222.425 182.089 220.812V197.188C182.089 195.575 182.396 194.058 183.011 192.637C183.625 191.177 184.47 189.929 185.546 188.892C186.621 187.816 187.87 186.971 189.291 186.356C190.75 185.703 192.287 185.377 193.9 185.377H231.639C233.253 185.377 234.77 185.703 236.191 186.356C237.651 186.971 238.918 187.816 239.994 188.892C241.069 189.929 241.915 191.177 242.529 192.637C243.144 194.058 243.451 195.575 243.451 197.188V256.188ZM231.639 220.812V197.188H193.9V220.812H231.639Z" fill="#1C1C1C"/></g><path d="M56.9656 33.5783C56.4437 33.2759 55.8512 33.1166 55.248 33.1166C54.6448 33.1166 54.0522 33.2759 53.5303 33.5783L45.6488 38.2942L40.2933 41.3699L32.4118 46.0858C31.8899 46.3883 31.2974 46.5475 30.6942 46.5475C30.091 46.5475 29.4985 46.3883 28.9765 46.0858L22.7118 42.3949C22.1971 42.0861 21.7696 41.6513 21.4695 41.1315C21.1688 40.611 21.0053 40.0226 20.9942 39.4216V32.1429C20.9839 31.5376 21.1385 30.9409 21.4414 30.4166C21.7435 29.8932 22.1828 29.462 22.7118 29.1696L28.8757 25.5811C29.3976 25.2787 29.9901 25.1194 30.5933 25.1194C31.1965 25.1194 31.7891 25.2787 32.311 25.5811L38.4748 29.1696C38.9895 29.4784 39.4171 29.9133 39.7171 30.4331C40.0178 30.9536 40.1814 31.5419 40.1925 32.1429V36.8588L45.5479 33.6807V28.9648C45.5582 28.3595 45.4036 27.7628 45.1007 27.2386C44.7986 26.7151 44.3593 26.2839 43.8303 25.9916L32.4111 19.2249C31.8891 18.9225 31.2966 18.7632 30.6934 18.7632C30.0902 18.7632 29.4977 18.9225 28.9757 19.2249L17.3548 25.9916C16.8258 26.2839 16.3865 26.7151 16.0843 27.2386C15.7816 27.7628 15.627 28.3595 15.6371 28.9648V42.6005C15.6269 43.2058 15.7815 43.8025 16.0843 44.3268C16.3865 44.8502 16.8258 45.2814 17.3548 45.5738L28.9757 52.3404C29.4977 52.6428 30.0902 52.8021 30.6934 52.8021C31.2966 52.8021 31.8891 52.6428 32.4111 52.3404L40.2926 47.7269L45.648 44.5488L53.5295 39.9353C54.0515 39.6328 54.644 39.4736 55.2472 39.4736C55.8504 39.4736 56.4429 39.6328 56.9648 39.9353L63.1287 43.5238C63.6434 43.8326 64.0709 44.2674 64.371 44.7872C64.6717 45.3077 64.8352 45.8961 64.8463 46.4971V53.7766C64.8566 54.3819 64.702 54.9786 64.3991 55.5028C64.097 56.0263 63.6577 56.4575 63.1287 56.7498L56.9648 60.4408C56.4429 60.7432 55.8504 60.9025 55.2472 60.9025C54.644 60.9025 54.0515 60.7432 53.5295 60.4408L47.3657 56.8523C46.851 56.5435 46.4235 56.1086 46.1234 55.5888C45.8224 55.0685 45.6588 54.4801 45.648 53.879V49.1631L40.2926 52.3412V57.0571C40.2823 57.6624 40.4369 58.2591 40.7398 58.7834C41.0419 59.3068 41.4812 59.738 42.0102 60.0303L53.6312 66.797C54.1531 67.0994 54.7456 67.2587 55.3488 67.2587C55.952 67.2587 56.5446 67.0994 57.0665 66.797L68.6874 60.0303C69.2018 59.7203 69.6292 59.285 69.9297 58.7651C70.2302 58.2452 70.394 57.6575 70.4059 57.0571V43.4206C70.4161 42.8153 70.2615 42.2186 69.9587 41.6944C69.6565 41.1709 69.2172 40.7397 68.6882 40.4474L56.9664 33.5783H56.9656Z" fill="#FFC640"/><defs><style type="text/css">@import url("https://fonts.googleapis.com/css2?family=Rajdhani:wght@500");</style></defs><text x="50%" y="50%" dominant-baseline="middle" text-anchor="middle" fill="white" style="font: bold 30px Rajdhani, sans-serif;">';
    string svgPartTwo = "</text></svg>";

    mapping(string => address) public domains;
    mapping(string => string) public records;
    mapping(uint256 => string) public names;

    constructor(string memory _tld) payable ERC721("69 Name Service", "69") {
        owner = payable(msg.sender);
        tld = _tld;
        console.log("%s name service deployed", _tld);
    }

    function price(string calldata name) public pure returns (uint256) {
        uint256 len = StringUtils.strlen(name);
        require(len > 0);
        if (len == 3) {
            // return 5 * 10**17; // 5 MATIC = 5 000 000 000 000 000 000 (18 decimals). We're going with 0.5 Matic cause the faucets don't give a lot
            return 0.5 * 10**17;
        } else if (len == 4) {
            // return 3 * 10**17; // To charge smaller amounts, reduce the decimals. This is 0.3
            return 0.3 * 10**17;
        } else {
            // return 1 * 10**17;
            return 0.1 * 10**17;
        }
    }

    function register(string calldata name) public payable {
        if (domains[name] != address(0)) revert AlreadyRegistered();
        if (!valid(name)) revert InvalidName(name);

        uint256 _price = price(name);
        require(msg.value >= _price, "Not enough Matic paid");

        string memory _name = string(abi.encodePacked(name, ".", tld));
        string memory finalSvg = string(
            abi.encodePacked(svgPartOne, _name, svgPartTwo)
        );
        uint256 newRecordId = _tokenIds.current();
        uint256 length = StringUtils.strlen(name);
        string memory strLen = Strings.toString(length);

        console.log(
            "Registering %s.%s on the contract with tokenID %d",
            name,
            tld,
            newRecordId
        );

        string memory json = Base64.encode(
            abi.encodePacked(
                '{"name": "',
                _name,
                '", "description": "A domain on the 69 name service", "image": "data:image/svg+xml;base64,',
                Base64.encode(bytes(finalSvg)),
                '","length":"',
                strLen,
                '"}'
            )
        );

        string memory finalTokenUri = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        console.log(
            "\n--------------------------------------------------------"
        );
        console.log("Final tokenURI", finalTokenUri);
        console.log(
            "--------------------------------------------------------\n"
        );

        _safeMint(msg.sender, newRecordId);
        _setTokenURI(newRecordId, finalTokenUri);
        domains[name] = msg.sender;
        names[newRecordId] = name;

        _tokenIds.increment();
    }

    function valid(string calldata name) public pure returns (bool) {
        return StringUtils.strlen(name) >= 3 && StringUtils.strlen(name) <= 10;
    }

    function getAddress(string calldata name) public view returns (address) {
        return domains[name];
    }

    function setRecord(string calldata name, string calldata record) public {
        if (msg.sender != domains[name]) revert Unauthorized();
        records[name] = record;
    }

    function getRecord(string calldata name)
        public
        view
        returns (string memory)
    {
        return records[name];
    }

    modifier onlyOwner() {
        require(isOwner());
        _;
    }

    function isOwner() public view returns (bool) {
        return msg.sender == owner;
    }

    function withdraw() public onlyOwner {
        uint256 amount = address(this).balance;

        (bool success, ) = msg.sender.call{value: amount}("");
        require(success, "Failed to withdraw Matic");
    }

    function getAllNames() public view returns (string[] memory) {
        console.log("Getting all names from contract");
        string[] memory allNames = new string[](_tokenIds.current());
        for (uint256 i = 0; i < _tokenIds.current(); i++) {
            allNames[i] = names[i];
            console.log("Name for token %d is %s", i, allNames[i]);
        }

        return allNames;
    }
}
