require 'spec_helper'

describe Coursewareable::Api::V1::UsersController do
  describe 'routing' do
    it 'for profile' do
      get('/v1/users/me').should route_to('coursewareable/api/v1/users#me')
    end
  end
end