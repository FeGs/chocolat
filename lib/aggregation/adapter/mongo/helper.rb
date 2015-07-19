module Aggregation
  module Adapter
    module Mongo
      module Helper
        def group_by(params)
          if params[:group_by]
            "$#{params[:group_by]}"
          else
            nil
          end
        end
      end
    end
  end
end