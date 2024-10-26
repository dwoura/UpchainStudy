import { defineConfig } from '@wagmi/cli'
import { etherscan } from '@wagmi/cli/plugins' // 引入插件

import dotenv from 'dotenv'

dotenv.config() // 读取.env 文件

export default defineConfig({
  out: 'src/generated.ts',
  contracts: [],
  plugins: [
    etherscan({
      apiKey: process.env.ETHERSCAN_API_KEY as string,
      chainId: 1,
      contracts: [
        {
          name: 'USDCimpl',
          address: '0x43506849D7C04F9138D1A2050bbF3A0c054402dd',
        },
      ],
    }),
  ],
})
