require 'rails_helper'

RSpec.describe Api::V1::RacesController do
  describe '#show' do
    context 'for a nonexistent race' do
      subject { get :show, params: {race_id: '0'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end
    end

    context 'for an existing race' do
      let(:race) { FactoryBot.create(:race) }
      subject { get :show, params: {race_id: race.id} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a race schema' do
        expect(subject.body).to match_json_schema(:race)
      end
    end
  end
end
