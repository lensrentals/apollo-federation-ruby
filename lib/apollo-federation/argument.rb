# frozen_string_literal: true

require 'apollo-federation/has_directives'

module ApolloFederation
  module Argument
    include HasDirectives

    VERSION_2_DIRECTIVES = %i[tags inaccessible authenticated].freeze

    def initialize(*args, **kwargs, &block)
      add_v2_directives(**kwargs)

      # Remove the custom kwargs
      kwargs = kwargs.delete_if do |k, _|
        VERSION_2_DIRECTIVES.include?(k)
      end

      # Pass on the default args:
      super(*args, **kwargs, &block)
    end

    private

    def add_v2_directives(tags: [], inaccessible: nil, authenticated: nil, **_kwargs)
      tags.each do |tag|
        add_directive(
          name: 'tag',
          arguments: [
            name: 'name',
            values: tag[:name],
          ],
        )
      end

      add_directive(name: 'inaccessible') if inaccessible
    end
  end
end
