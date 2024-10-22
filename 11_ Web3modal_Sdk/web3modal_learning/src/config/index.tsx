
// config/index.tsx

import { cookieStorage, createStorage } from '@wagmi/core'
import { WagmiAdapter } from '@reown/appkit-adapter-wagmi'
import { mainnet, sepolia } from '@reown/appkit/networks'

// Get projectId from https://cloud.reown.com
export const projectId = '0925f809245f004812c057b040367ff1'

if (!projectId) {
  throw new Error('Project ID is not defined')
}

export const networks = [mainnet, sepolia]

//Set up the Wagmi Adapter (Config)
export const wagmiAdapter = new WagmiAdapter({
  storage: createStorage({
    storage: cookieStorage
  }),
  ssr: true,
  projectId,
  networks
})

export const config = wagmiAdapter.wagmiConfig