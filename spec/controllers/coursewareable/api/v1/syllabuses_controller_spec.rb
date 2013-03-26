require 'spec_helper'

describe Coursewareable::Api::V1::SyllabusesController do
  let(:syllabus) { Fabricate('coursewareable/syllabus') }
  let(:token) do
    stub :accessible? => true,
    :response_owner_id => syllabus.classroom.owner.id
  end

  describe '#show' do
    before do
      controller.stub(:doorkeeper_token) { token }
      get(:show, :id => syllabus.id)
    end

    context 'authenticated' do
      its(:status) { should eq(200) }
      it 'should render requested syllabus' do
        body = JSON.parse(response.body)
        body['syllabus']['title'].should eq(syllabus.title)
      end
    end

    context 'not authenticated' do
      let(:token) { stub(:accessible? => false) }

      its(:status) { should eq(401) }
    end
  end
end
