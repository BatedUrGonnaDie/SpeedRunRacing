require 'rails_helper'

RSpec.describe Api::V1::UsersController do
  describe '#show' do
    context 'with an invalid username' do
      subject { get :show, params: {username: 'zzzzzzzzzzzzzzzzzzz'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end
    end

    context 'with a valid username' do
      let(:user) { FactoryBot.create(:user) }
      subject { get :show, params: {username: user.username} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a user schema' do
        expect(subject.body).to match_json_schema(:user)
      end
    end
  end
end
