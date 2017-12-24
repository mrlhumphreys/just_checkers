require 'minitest/spec'
require 'minitest/autorun'
require 'just_checkers/piece'

describe JustCheckers::Piece do
  describe 'promote!' do
    let(:piece) { JustCheckers::Piece.new(player_number: 1) }

    it 'turns the piece into a king' do
      piece.promote
      assert piece.king?
    end
  end
end
