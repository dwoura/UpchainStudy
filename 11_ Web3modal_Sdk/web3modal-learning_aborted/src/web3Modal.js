import { createWeb3Modal } from "@web3modal/wagmi/react";
import { defaultWagmiConfig } from "@web3modal/wagmi/react/config";

import { WagmiProvider } from "wagmi";
import { arbitrum, mainnet } from "wagmi/chains";
import { QueryClient, QueryClientProvider} from "@tanstack/react-query";

const queryClient = new QueryClient();

const projectId = '0925f809245f004812c057b040367ff1';

const metadata = {
  name: 'Web3Modal',
  description: 'Web3Modal Example',
  url: 'https://example.com',
  icons: ["https://avatars.githubusercontent.com//3778488"],
  keywords: ['web3', 'decentralized', 'next.js', 'react'],
};

const chains = [mainnet, arbitrum];
const config = defaultWagmiConfig({
  chains,
  projectId,
  metadata
})

createWeb3Modal({
  WagmiConfig: config,
  projectId
})

function Web3ModalProvider({ children}){
  return (
      <WagmiProvider config={config}>
          <QueryClientProvider client={queryClient}>{children} </QueryClientProvider>
      </WagmiProvider>
  );
}

export default function LoginWithWeb3Modal() {
  return (
    <>
      <Web3ModalProvider>
        <w3m-button/>
      </Web3ModalProvider>
    </>
  );
}


