# frozen_string_literal: true

module Users
  module Resource
    include Croods::Resource

    use_for_authentication!

    public :index, :show
  end
end
