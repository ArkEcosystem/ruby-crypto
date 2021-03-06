require 'arkecosystem/crypto/identities/address'

module ArkEcosystem
  module Crypto
    module Transactions
      # The base deserializer for transactions.
      class Deserializer
        def initialize(serialized)
          @serialized = serialized
          @binary = BTC::Data.data_from_hex(@serialized)

          @handlers = %w[
          Transfer
          SecondSignatureRegistration
          DelegateRegistration
          Vote
          MultiSignatureRegistration
          Ipfs
          TimelockTransfer
          MultiPayment
          DelegateResignation
        ]
        end

        def deserialize
          transaction = ArkEcosystem::Crypto::Transactions::Transaction.new()
          transaction.version = @binary.unpack('C2').last
          transaction.network = @binary.unpack('C3').last
          transaction.type = @binary.unpack('C4').last
          transaction.timestamp = @binary.unpack('V2').last
          transaction.sender_public_key = @binary.unpack('H16H66').last
          transaction.fee = @binary.unpack('C41Q<').last

          vendor_field_length = @binary.unpack('C49C1').last

          if vendor_field_length > 0
            vendor_field_offset = (41 + 8 + 1) * 2
            vendor_field_take = vendor_field_length * 2

            transaction.vendor_field_hex = @binary.unpack("H#{vendor_field_offset}H#{vendor_field_take}").last
          end

          asset_offset = (41 + 8 + 1) * 2 + vendor_field_length * 2

          transaction = handle_type(asset_offset, transaction)

          transaction.amount = 0 unless transaction.amount

          if transaction.version == 1 || transaction.version.empty?
            transaction = handle_version_one(transaction)
          end

          transaction
        end

        private

        def handle_type(asset_offset, transaction)
          deserializer = @handlers[transaction.type]
          deserializer = Object.const_get("ArkEcosystem::Crypto::Transactions::Deserializers::#{deserializer}")
          deserializer.new(@serialized, @binary, asset_offset, transaction).deserialize
        end

        def handle_version_one(transaction)
          if transaction.second_signature
            transaction.sign_signature = transaction.second_signature
          end

          if transaction.type == ArkEcosystem::Crypto::Enums::Types::VOTE
            transaction.recipient_id = ArkEcosystem::Crypto::Identities::Address.from_public_key(transaction.sender_public_key, transaction.network)
          end

          if transaction.type == ArkEcosystem::Crypto::Enums::Types::MULTI_SIGNATURE_REGISTRATION
            transaction.asset[:multisignature][:keysgroup] = transaction.asset[:multisignature][:keysgroup].map! { |key| '+' + key }
          end

          if transaction.vendor_field_hex
            transaction.vendor_field = BTC::Data.data_from_hex(transaction.vendor_field_hex)
          end

          unless transaction.id
            transaction.id = transaction.get_id
          end

          if transaction.type == ArkEcosystem::Crypto::Enums::Types::SECOND_SIGNATURE_REGISTRATION
            transaction.recipient_id = ArkEcosystem::Crypto::Identities::Address.from_public_key(transaction.sender_public_key, transaction.network)
          end

          if transaction.type == ArkEcosystem::Crypto::Enums::Types::MULTI_SIGNATURE_REGISTRATION
            transaction.recipient_id = ArkEcosystem::Crypto::Identities::Address::from_public_key(transaction.sender_public_key, transaction.network);
          end

          transaction
        end
      end
    end
  end
end
