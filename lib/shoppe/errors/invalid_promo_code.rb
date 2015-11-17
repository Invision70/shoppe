module Shoppe
  module Errors
    class InvalidPromoCode < Error
      def order
        @options[:order]
      end
    end
  end
end
