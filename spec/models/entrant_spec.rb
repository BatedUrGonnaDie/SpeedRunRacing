require 'rails_helper'

RSpec.describe Entrant, type: :model do
  context 'on an open race' do
    it 'parts the race' do
      entrant = FactoryBot.build(:entrant)
      expect(entrant.place).to eq nil
      entrant.part
      expect(entrant.destroyed?).to eq true
    end
  end

  context 'on a race in progress' do
    context 'while still running' do
      let(:entrant) { FactoryBot.create(:entrant, start_race: true) }

      it 'abandons a race that has started' do
        expect(entrant).not_to be_finished
        entrant.part
        expect(entrant.place).to eq(-1)
      end

      it 'finishes the race' do
        expect(entrant).not_to be_finished
        entrant.done
        expect(entrant.place).to eq 1
        expect(entrant).to be_finished
      end
    end

    context 'after finishing the race' do
      let(:entrant) { FactoryBot.create(:entrant, completed: true, start_race: true) }

      it 'rejoins a race in progress after abandoning' do
        entrant.rejoin
        expect(entrant.place).to eq nil
      end

      it 'rejoins the race after finishing' do
        expect(entrant.place).to eq 1
        entrant.rejoin
        expect(entrant.place).to eq nil
        expect(entrant.finish_time).to eq nil
      end
    end
  end
end
