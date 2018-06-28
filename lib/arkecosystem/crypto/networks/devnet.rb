module ArkEcosystem
  module Crypto
    module Networks
      class Devnet
        def self.version
          '1e'
        end

        def self.message_prefix
          "DARK message:\n"
        end

        def self.nethash
          '578e820911f24e039733b45e4882b73e301f813a0d2c31330dafda84534ffa23'
        end

        def self.wif
          170
        end
      end
    end
  end
end