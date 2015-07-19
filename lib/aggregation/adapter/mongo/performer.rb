module Aggregation
  module Adapter
    module Mongo
      class Performer
        attr_reader :collection, :params

        def initialize(collection, **kwargs)
          @collection = collection
          @params = kwargs.with_indifferent_access
        end

      protected
        def to_variable(*args)
          if args.empty? || args.any?(&:nil?)
            nil
          else
            "$#{args.join('.')}"
          end
        end
      end
    end
  end
end