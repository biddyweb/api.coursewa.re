require 'spec_helper'

describe Coursewareable::Api::V1::ClassroomsController do

  routes { Coursewareable::Engine.routes }

  let(:classroom) { Fabricate('coursewareable/classroom') }
  let(:token) do
    double(:accessible? => true, :resource_owner_id => classroom.owner.id)
  end

  before do
    controller.stub(:doorkeeper_token) { token }
  end

  describe '#index' do
    before do
      get(:index)
    end

    context 'authenticated' do
      its(:status) { should eq(200) }
      it 'should give information about classroom' do
        body = JSON.parse(response.body)
        body['classrooms'].first['title'].should eq(classroom.title)
      end
    end

    context 'not authenticated' do
      let(:token) { double(:accessible? => false) }

      its(:status) { should eq(401) }
    end
  end

  describe '#show' do
    before do
      get(:show, :id => classroom.id)
    end

    context 'authenticated' do
      its(:status) { should eq(200) }

      it 'should give information about requested classroom' do
        body = JSON.parse(response.body)
        body['classroom']['title'].should eq(classroom.title)
      end
    end

    context 'not authenticated' do
      let(:token) { double(:accessible? => false) }

      its(:status) { should eq(401) }
    end
  end

  describe '#timeline' do
    before do
      get(:timeline, :classroom_id => classroom.id)
    end

    context 'authenticated' do
      its(:status) { should eq(200) }

      it 'should render timeline for requested classroom' do
        body = JSON.parse(response.body)
        body['activities'].first['id'].should eq(classroom.all_activities.first.id)
      end
    end

    context 'not authenticated' do
      let(:token) { double(:accessible? => false) }

      its(:status) { should eq(401) }
    end
  end

  describe '#collaborators' do
    let(:collaboration) do
      Fabricate('coursewareable/collaboration', :classroom => classroom)
    end

    before do
      get(:collaborators, :classroom_id => collaboration.classroom.id)
    end

    context 'authenticated' do
      its(:status) { should eq(200) }

      it 'should render collaborators' do
        body = JSON.parse(response.body)['collaborators']
        body.first['email'].should eq(collaboration.user.email)
      end
    end

    context 'not authenticated' do
      let(:token) { double(:accessible? => false) }

      its(:status) { should eq(401) }
    end
  end
end
