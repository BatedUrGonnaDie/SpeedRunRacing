require 'rails_helper'

RSpec.describe Api::V1::Games::CategoriesController do
  describe '#races' do
    context 'for an invalid game' do
      context 'for a invalid category' do
        subject { get :races, params: {shortname: 'zzzzzzzzzzzzzzzzzzz', category_id: 0} }

        it 'returns a 404' do
          expect(subject).to have_http_status 404
        end

        it 'correctle 404s on the game' do
          expect(JSON.parse(subject.body)['error']).to start_with('No game')
        end
      end

      context 'for a valid category' do
        let(:category) { FactoryBot.create(:category) }
        subject { get :races, params: {shortname: 'zzzzzzzzzzzzzzzzzzz', category_id: category.id} }

        it 'returns a 404' do
          expect(subject).to have_http_status 404
        end

        it 'correctly 404s on the game' do
          expect(JSON.parse(subject.body)['error']).to start_with('No game')
        end
      end
    end

    context 'for a valid game' do
      let(:game) { FactoryBot.create(:game) }

      context 'for an invalid category' do
        subject { get :races, params: {shortname: game.shortname, category_id: 0} }

        it 'returns a 404' do
          expect(subject).to have_http_status 404
        end

        it 'correctly 404s on the category' do
          expect(JSON.parse(subject.body)['error']).to start_with('No category')
        end
      end

      context 'for a valid category' do
        let(:category) { FactoryBot.create(:category, :with_races, game: game) }
        subject { get :races, params: {shortname: game.shortname, category_id: category.id} }

        it 'returns a 200' do
          expect(subject).to have_http_status 200
        end

        it 'renders a race array schema' do
          expect(subject.body).to match_json_schema(:races)
        end
      end
    end
  end
end
