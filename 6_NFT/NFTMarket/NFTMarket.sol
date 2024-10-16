// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;


import {IERC721} from "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import {IERC20} from "./IERC20.sol";


contract NFTMarket {
    address public owner;
    //address[] listing; // 已上架的nft地址
    mapping(address=>uint[]) listingNftId; // 已上架的指定 nft暂时没有按价格排序

    struct good{
        uint id;
        uint price; // nft挂单价格（单位：erc20）
        bool isListing; // nft上架状态
        address seller; // nft挂单的卖家
        address currency; // 使用的货币token
        uint listingIndex; // 上架区的索引
    }
    mapping(address=>mapping(uint=>good)) goods; //nft上架信息

    constructor(){
        owner = msg.sender;
    }

    function getListing(address nftAddr) public view returns(uint[] memory){
        return listingNftId[nftAddr];
    }

    function list(address nftAddr, uint nftId,address currency,uint price) public returns(bool){
        // 上架，挂单价格：xx个 token
        // 1. nft传入合约中
        // 2. listing中增加库存
        // 3. 上架状态
        require(price > 0,"price can not be set 0");
        require(!goods[nftAddr][nftId].isListing,"nft is listing");

        // 用户approve nft，市场进行 transferFrom
        IERC721 erc721 = IERC721(nftAddr);
        erc721.transferFrom(msg.sender, address(this), nftId); // 或者是可以加锁？
        //上架nft
        listingNftId[nftAddr].push(nftId);
        //打包货物
        goods[nftAddr][nftId] = good(
            nftId,
            price,
            true,
            msg.sender,
            currency,
            listingNftId[nftAddr].length-1
        );

        return true;
    }

    function buyNFT(address buyer,address wantedNftAddr, uint nftId) public returns(bool){
        // nft转出给购买人
        // listing 减少库存
        // 下架状态
        // 最后，市场转出nft给买家，市场转出token给卖家

        //IERC721 wantedNft = IERC721(wantedNftAddr);
        require(listingNftId[wantedNftAddr].length>0, "no listing nft now");
        good storage wantedNft = goods[wantedNftAddr][nftId];
        IERC20 erc20 = IERC20(wantedNft.currency);
        require(wantedNft.isListing, "this nft is unlisted");
        require(erc20.balanceOf(buyer) >= erc20.allowance(buyer, address(this)) && erc20.allowance(buyer, address(this)) >= wantedNft.price, "buyer has no enough erc20");
        // 卖出前先交换到末尾再删除
        uint[] storage listingNftIds = listingNftId[wantedNftAddr];
        (listingNftIds[wantedNft.listingIndex],listingNftIds[listingNftIds.length-1]) = (listingNftIds[listingNftIds.length-1], listingNftIds[wantedNft.listingIndex]);
        listingNftIds.pop();
        // 下架状态
        wantedNft.isListing = false;
        // 市场转出nft价格的token给卖家
        bool success = erc20.transferFrom(buyer, wantedNft.seller, wantedNft.price); // 暂未设置手续费
        require(success, "failed to transfer token to seller");
        // 市场转出 nft 给买家
        IERC721 erc721 = IERC721(wantedNftAddr);
        erc721.transferFrom(address(this),buyer,wantedNft.id);

        return true;
        // 怎么判断721有无转账成功？？
    }

    function tokensReceived(address buyerAddr,address wantedNftAddr,uint) public {
        //转账erc20给 market 合约，触发tokensReceived()进来自动购买，listing pop。
        uint[] memory listingNftIds = listingNftId[wantedNftAddr];
        buyNFT(buyerAddr,wantedNftAddr,listingNftIds[listingNftIds.length-1]); //暂时默认购买 listing 最后一个
    }
}
