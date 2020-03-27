# frozen_string_literal: true

module Croods
  module Resource
    module Attributes
      module Base
        def add_attribute(name, type, **options)
          attribute = Croods::Attribute.new(name, type, **options)
          additional_attributes[name.to_s] = attribute
        end

        def additional_attributes
          @additional_attributes ||= {}
        end

        def remove_attributes(*names)
          names.each do |name|
            ignored_attributes << name.to_s
          end
        end

        def ignored_attributes
          @ignored_attributes ||= []
        end

        alias remove_attribute remove_attributes
      end
    end
  end
end
