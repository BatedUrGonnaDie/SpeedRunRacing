class Api::V1::ApplicationSerializer < ActiveModel::Serializer
  delegate :cache_key, to: :object
end
