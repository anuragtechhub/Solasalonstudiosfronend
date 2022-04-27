# frozen_string_literal: true

# TODO: https://github.com/rails-api/active_model_serializers/issues/2333
#
# ActiveModelSerializers::LookupChain::BY_NAMESPACE demodulizes classes which results to
# same Profiles serializer being used for both Profile and Public::Profile models

ActiveModelSerializers::LookupChain::BY_PARENT_SERIALIZER_CUSTOM = lambda do |resource_class, serializer_class, _namespace|
  return if serializer_class == ActiveModel::Serializer

  "#{serializer_class}::#{resource_class.name}Serializer"
end

ActiveModelSerializers::LookupChain::BY_NAMESPACE_CUSTOM = lambda do |resource_class, _serializer_class, namespace|
  if namespace
    namespace_chain     = namespace.name.split('::')
    resource_name_chain = resource_class.name.split('::')

    if (resource_name_chain.size > 1) && (namespace_chain.last == resource_name_chain.first)
      namespace_chain.pop
    end

    "#{(namespace_chain + resource_name_chain).join('::')}Serializer"
  end
end

ActiveModelSerializers.config.serializer_lookup_chain = [
  ActiveModelSerializers::LookupChain::BY_PARENT_SERIALIZER_CUSTOM,
  ActiveModelSerializers::LookupChain::BY_NAMESPACE_CUSTOM,
  # ActiveModelSerializers::LookupChain::BY_NAMESPACE, # unnecessary
  ActiveModelSerializers::LookupChain::BY_RESOURCE_NAMESPACE,
  ActiveModelSerializers::LookupChain::BY_RESOURCE
]

ActiveModelSerializers.config.adapter                         = :json
ActiveModelSerializers.config.key_transform                   = :unaltered
ActiveModelSerializers.config.jsonapi_resource_type           = :singular
ActiveModelSerializers.config.jsonapi_include_toplevel_object = false
