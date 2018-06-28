module ArkEcosystem
  module Crypto
    module Models
      class Transaction
        @@serialiseHandlers = [
          'Transfer',
          'SecondSignatureRegistration',
          'DelegateRegistration',
          'Vote',
          'MultiSignatureRegistration',
          'Ipfs',
          'TimelockTransfer',
          'MultiPayment',
          'DelegateResignation'
        ]

        def initialize(transaction)
          @transaction = transaction
        end

        def serialise
          type = @@serialiseHandlers[@transaction[:type]]

          Object.const_get("ArkEcosystem::Crypto::Serialisers::#{type}").new(@transaction).serialise
        end

        def deserialise
          type = @@serialiseHandlers[@transaction[:type]]

          Object.const_get("ArkEcosystem::Crypto::Deserialisers::#{type}").new(@transaction).deserialise
        end
      end
    end
  end
end