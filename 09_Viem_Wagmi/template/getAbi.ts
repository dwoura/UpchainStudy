const axios = require('axios');
const { ethers } = require('ethers');

const getAbi = async (address:string, apiKey:string) => {
    const url = `https://api.etherscan.io/api?module=contract&action=getabi&address=${address}&apikey=${apiKey}`
    const infuraUrl = ''

    const res = await axios.get(url)
    const abi = JSON.parse(res.data.result)
    // console.log(abi)

    const provider = new ethers.providers.JsonRpcProvider(infuraUrl)
    const contract = new ethers.Contract(
        address,
        abi,
        provider
    )

    const name = await contract.name()
    const totalSupply = await contract.totalSupply()

    console.log(name)
    console.log(totalSupply.toString())
}

getAbi()