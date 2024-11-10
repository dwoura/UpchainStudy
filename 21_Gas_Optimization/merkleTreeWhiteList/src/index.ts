import { toHex, encodePacked, keccak256 } from 'viem';
import { MerkleTree } from "merkletreejs";

const wlAddrs = [
    { address: "0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266"}, //buyer
    { address: "0x70997970C51812dc3A010C7d01b50e0d17dc79C8"},
    { address: "0x3C44CdDdB6a900fa2b585dd299e03d12FA4293BC"},
    { address: "0x90F79bf6EB2c4f870365E785982E1f101E93b906"},
  ];
  
const leafNodes = wlAddrs.map(addr => keccak256(addr.address as `0x${string}`));
const merkleTree = new MerkleTree(leafNodes, keccak256,{ sortPairs: true }); // sortPairs: true to sort leaf nodes

const root = merkleTree.getHexRoot();
console.log("root:" + root);

const leaf = leafNodes[0]; // first leaf node
const proof = merkleTree.getHexProof(leaf);
console.log("proof:" +proof);