require 'rails_helper'

RSpec.describe Api::V1::GamesController do
  describe '#index' do
    context 'with no query' do
      subject { get :index }

      it 'returns a 400' do
        expect(subject).to have_http_status 400
      end
    end

    context 'with a query parameter' do
      let(:game) { FactoryBot.create(:game, :with_categories) }
      subject { get :index, params: {q: game.shortname} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a game array schema' do
        expect(subject.body).to match_json_schema(:games)
      end
    end
  end

  describe '#show' do
    context 'with an invalid shortname' do
      subject { get :show, params: {shortname: 'zzzzzzzzzzzzzzzzzzz'} }

      it 'returns a 404' do
        expect(subject).to have_http_status 404
      end
    end

    context 'with a valid game shortname' do
      let(:game) { FactoryBot.create(:game, :with_categories) }
      subject { get :show, params: {shortname: game.shortname} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a game schema' do
        expect(subject.body).to match_json_schema(:game)
      end
    end
  end

  describe '#races' do
    context 'for an invalid race type' do
      let(:game) { FactoryBot.create(:game) }
      subject { get :races, params: {shortname: game.shortname, race_status: 'blah'} }

      it 'returns a 400' do
        expect(subject).to have_http_status 400
      end
    end

    context 'for a valid request' do
      let(:game) { FactoryBot.create(:game, :with_races) }
      subject { get :races, params: {shortname: game.shortname} }

      it 'returns a 200' do
        expect(subject).to have_http_status 200
      end

      it 'renders a race array schema' do
        expect(subject.body).to match_json_schema(:races)
      end
    end
  end
end
