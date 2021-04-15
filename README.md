## zkSync demo

An application demonstrating the use of [zkSync](https://zksync.io/) technology for ethereum scalability.

## Development

## Tutorial

The tools (`zargo`, `znc` and `zvm`) can be downloaded from https://github.com/matter-labs/zinc/releases
The Zinc language description can be found at https://zinc.zksync.io/

### Step by step

1. Create new Zinc smart contract project with `zargo new --type contract invoices`
2. Edit the logic (language reference https://zinc.zksync.io/)
3. Build & test `zargo test --manifest-path=invoices/Zargo.toml`
4. Deploy
  - put in place `contracts/invoices/private_key`
  - edit values in `contracts/invoices/data/input.json` for constructor arguments
  - you should see something like
      ```
      ❯ zargo publish --instance default --network rinkeby --manifest-path=./contracts/invoices/Zargo.toml
         Compiling invoices v0.1.1
          Finished release [optimized] target
         Uploading the instance `default` of `invoices v0.1.1` to network `rinkeby`
           Address 0xbaf52e3e7bfec76d3a9cadf88f097ae9f89c8072
        Account ID 128579
      ```
5. Interact with the contract
  - the contract method call arguments will be taken from `contracts/invoices/data/input.json`, so make sure they're there first
  - raise an invoice
      ```
      ❯ zargo call --address=0xbaf52e3e7bfec76d3a9cadf88f097ae9f89c8072 --manifest-path=./contracts/invoices/Zargo.toml --network=rinkeby --method=raiseInvoice
           Calling method `raiseInvoice` of the contract `invoices v0.1.1` with address 0xbaf52e3e7bfec76d3a9cadf88f097ae9f89c8072 on network `rinkeby`
      {
        "output": {
          "result": null,
          "root_hash": "0x0"
        }
      }
      ```
  - query invoice
      ```
      ❯ zargo query --address=0xbaf52e3e7bfec76d3a9cadf88f097ae9f89c8072 --manifest-path=./contracts/invoices/Zargo.toml --network=rinkeby --method=getInvoice
          Querying method `getInvoice` of the contract `invoices v0.1.1` with address 0xbaf52e3e7bfec76d3a9cadf88f097ae9f89c8072 on network `rinkeby`
      {
        "output": {
          "id": "1",
          "issuer": "0x74af123ef7013e821733259f2a01558a4fabf26b",
          "payer": "0xc238fa6ccc9d226e2c49644b36914611319fc3ff",
          "amount": "100000000000000000",
          "cancelled": false
        }
      }
      ```
6. Check the data on blockchain: https://rinkeby.zkscan.io/explorer/accounts/0xbaf52e3e7bfec76d3a9cadf88f097ae9f89c8072
