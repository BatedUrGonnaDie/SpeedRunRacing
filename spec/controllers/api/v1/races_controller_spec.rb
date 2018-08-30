require 'rails_helper'

RSpec.describe Api::V1::RacesController do
  describe '#index' do
    context 'for an invalid race type' do
      subject { get :index, params: {race_status: 'blah'} }

      it 'returns a 400' do
        expect(subject).to have_http_status 400
      end
    end

    context 'for no race type' do
      let(:races) { FactoryBot.create_list(:race, 5) }
      subject { get :index }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a race array schema' do
        expect(subject.body).to match_json_schema(:races)
      end
    end

    context 'for the "active" race type' do
      let(:races) { FactoryBot.create_list(:race, 5) }
      subject { get :index, params: {race_status: 'active'} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a race array schema' do
        expect(subject.body).to match_json_schema(:races)
      end
    end

    context 'for the "completed" race type' do
      let(:races) { FactoryBot.create_list(:race, 5, :completed, :with_entrants) }
      subject { get :index, params: {race_status: 'completed'} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a race array schema' do
        expect(subject.body).to match_json_schema(:races)
      end
    end
  end

  describe '#show' do
    context 'for a nonexistent race' do
      subject { get :show, params: {race_id: '0'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end
    end

    context 'for an existing race' do
      context 'with no entrants' do
        let(:race) { FactoryBot.create(:race) }
        subject { get :show, params: {race_id: race.id} }

        it 'returns a 200' do
          expect(subject).to have_http_status 200
        end

        it 'renders a race schema' do
          expect(subject.body).to match_json_schema(:race)
        end
      end

      context 'with entrants' do
        let(:race) { FactoryBot.create(:race, :with_entrants) }
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
end
