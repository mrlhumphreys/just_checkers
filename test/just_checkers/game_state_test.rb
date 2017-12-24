require 'minitest/spec'
require 'minitest/autorun'
require 'just_checkers/game_state'

describe JustCheckers::GameState do
  describe 'default' do
    let(:game_state) { JustCheckers::GameState.default }

    it 'must have a current player should be 1' do
      assert_equal(game_state.current_player_number, 1)
    end

    it 'must have 12 player 1 pieces' do
      assert_equal(12, game_state.squares.where(piece: {player_number: 1}).size)
    end

    it 'must have 12 player 2 pieces' do
      assert_equal(12, game_state.squares.where(piece: {player_number: 2}).size)
    end

    it 'must have no errors' do
      assert_empty(game_state.errors)
    end
  end

  describe 'performing a successful move' do
    let(:player_number) { 1 }

    let(:from_x) { 0 }
    let(:from_y) { 0 }
    let(:to_x) { 2 }
    let(:to_y) { 2 }
    let(:between_x) { 1 }
    let(:between_y) { 1 }

    let(:from_position) { { x: from_x, y: from_y } }
    let(:between_position) { { x: between_x, y: between_y } }
    let(:to_position) { { x: to_x, y: to_y } }

    let(:from_id) { 1 }
    let(:to_id) { 3 }

    let(:from) { JustCheckers::Square.new(id: from_id, x: from_x, y: from_y, piece: {player_number: player_number}) }
    let(:between) { JustCheckers::Square.new(id: 2, x: between_x, y: between_y, piece: {player_number: 2}) }
    let(:to) { JustCheckers::Square.new(id: to_id, x: to_x, y: to_y) }
    let(:game_state) { JustCheckers::GameState.new(current_player_number: player_number, squares: [from, between, to]) }

    it 'must empty the from square' do
      game_state.move(player_number, from_position, [to_position])
      square = game_state.squares.find_by_x_and_y(from_x, from_y)
      assert square.unoccupied?
    end

    it 'must move the piece to to square' do
      game_state.move(player_number, from_position, [to_position])
      square = game_state.squares.find_by_x_and_y(to_x, to_y)
      refute square.unoccupied?
    end

    it 'must empty the between square' do
      game_state.move(player_number, from_position, [to_position])
      square = game_state.squares.find_by_x_and_y(between_x, between_y)
      assert square.unoccupied?
    end

    it 'must have no errors' do
      game_state.move(player_number, from_position, [to_position])
      assert_empty(game_state.errors)
    end

    it 'must be able to accept square ids' do
      result = game_state.move(player_number, from_id, [to_id])
      assert result
    end

    it 'must set the last change attribute' do
      game_state.move(player_number, from_id, [to_id])
      last_change = { type: 'move', data: { player_number: player_number, from: from_id, to: [to_id] } }
      assert_equal last_change, game_state.last_change
    end
  end

  describe 'a piece has possible jump' do
    let(:player_number) { 1 }

    let(:jumper_position) { { x: 0, y: 0 } }
    let(:landing_position) { { x: 2, y: 2 } }
    let(:not_jumper_position) { { x: 4, y: 0 } }
    let(:empty_position) { { x: 5, y: 1 } }

    let(:jumper) { JustCheckers::Square.new(id: 1, x: jumper_position[:x], y: jumper_position[:y], piece: {player_number: player_number}) }
    let(:enemy) { JustCheckers::Square.new(id: 2, x: 1, y: 1, piece: {player_number: 2}) }
    let(:landing) { JustCheckers::Square.new(id: 3, x: landing_position[:x], y: landing_position[:y]) }
    let(:not_jumper) { JustCheckers::Square.new(id: 4, x: not_jumper_position[:x], y: not_jumper_position[:y], piece: {player_number: player_number}) }
    let(:empty) { JustCheckers::Square.new(id: 5, x: empty_position[:x], y: empty_position[:y]) }

    let(:game_state) { JustCheckers::GameState.new(current_player_number: player_number, squares: [jumper, enemy, landing, not_jumper, empty]) }

    describe 'with that piece that can jump' do
      it 'must be able to move' do
        assert game_state.move(player_number, jumper_position, [landing_position])
      end
    end

    describe 'with another piece that cannot jump' do
      it 'must not be able to move' do
        refute game_state.move(player_number, not_jumper_position, [empty_position])
      end

      it 'must set an error' do
        game_state.move(player_number, not_jumper_position, [empty_position])
        assert game_state.errors.first, 'Another piece must capture first.'
      end
    end
  end

  describe 'no piece has a possible jump' do
    let(:player_number) { 1 }

    let(:mover_position) { { x: 4, y: 0} }
    let(:empty_position) { { x: 5, y: 1} }

    let(:mover) { JustCheckers::Square.new(id: 1, x: mover_position[:x], y: mover_position[:y], piece: {player_number: player_number}) }
    let(:empty) { JustCheckers::Square.new(id: 2, x: empty_position[:x], y: empty_position[:y]) }

    let(:game_state) { JustCheckers::GameState.new(current_player_number: player_number, squares: [mover, empty]) }

    describe 'with a piece moving to an empty square' do
      it 'must be a valid move' do
        assert game_state.move(player_number, mover_position, [empty_position])
      end
    end
  end

  describe 'when it is not the players turn' do
    let(:current_player_number) { 1 }
    let(:not_current_player_number) { 2 }

    let(:from_x) { 4 }
    let(:from_y) { 4 }
    let(:to_x) { 3 }
    let(:to_y) { 3 }

    let(:from_position) { { x: from_x, y: from_y } }
    let(:to_position) { { x: to_x, y: to_y } }

    let(:from_square) { JustCheckers::Square.new(id: 1, x: from_x, y: from_y, piece: {player_number: 2}) }
    let(:to_square) { JustCheckers::Square.new(id: 2, x: to_x, y: to_y) }

    let(:game_state) { JustCheckers::GameState.new(squares: [from_square, to_square], current_player_number: current_player_number) }

    it 'must not allow player the player to move' do
      game_state.move(not_current_player_number, from_position, [to_position])

      from_square_after_move = game_state.squares.find_by_x_and_y(from_x, from_y)
      to_square_after_move = game_state.squares.find_by_x_and_y(to_x, to_y)

      refute from_square_after_move.unoccupied?
      assert to_square_after_move.unoccupied?
    end

    it 'must return false' do
      refute game_state.move(not_current_player_number, from_position, [to_position])
    end

    it 'must set an error' do
      game_state.move(not_current_player_number, from_position, [to_position])
      assert game_state.errors.first, "It is not that player's turn."
    end

    it 'must not pass the turn' do
      game_state.move(not_current_player_number, from_position, [to_position])
      assert_equal current_player_number, game_state.current_player_number
    end
  end

  describe 'moving a piece that does not exist' do
    let(:game_state) { JustCheckers::GameState.default }

    it 'must return false' do
      refute game_state.move(1, {x: 0, y: 0}, [{x: 1, y: 1}])
    end

    it 'must set an error' do
      game_state.move(1, {x: 0, y: 0}, [{x: 1, y: 1}])
      assert game_state.errors.first, "There is no piece there."
    end
  end

  describe 'when it is the players turn' do
    let(:current_player_number) { 2 }
    let(:not_current_player_number) { 1 }

    let(:from_x) { 4 }
    let(:from_y) { 4 }
    let(:to_x) { 3 }
    let(:to_y) { 3 }
    let(:behind_x) { 2 }
    let(:behind_y) { 2 }

    let(:from_position) { { x: from_x, y: from_y } }
    let(:to_position) { { x: to_x, y: to_y } }
    let(:behind_position) { { x: behind_x, y: behind_y } }

    let(:from_square) { JustCheckers::Square.new(id: 1, x: from_x, y: from_y, piece: {player_number: 2}) }
    let(:to_square) { JustCheckers::Square.new(id: 2, x: to_x, y: to_y) }
    let(:behind_square) { JustCheckers::Square.new(id: 3, x: behind_x, y: behind_y) }

    let(:game_state) { JustCheckers::GameState.new(squares: [from_square, to_square, behind_square], current_player_number: current_player_number) }

    describe 'with a valid move' do
      it 'must allow the player to move' do
        game_state.move(current_player_number, from_position, [to_position])

        from_square_after_move = game_state.squares.find_by_x_and_y(from_x, from_y)
        to_square_after_move = game_state.squares.find_by_x_and_y(to_x, to_y)

        assert from_square_after_move.unoccupied?
        refute to_square_after_move.unoccupied?
      end

      it 'must return true' do
        assert game_state.move(current_player_number, from_position, [to_position])
      end

      it 'must pass the turn' do
        game_state.move(current_player_number, from_position, [to_position])
        assert_equal not_current_player_number, game_state.current_player_number
      end
    end

    describe 'with an invalid move' do
      it 'must not allow player the player to move' do
        game_state.move(current_player_number, from_position, [behind_position])

        from_square_after_move = game_state.squares.find_by_x_and_y(from_x, from_y)
        to_square_after_move = game_state.squares.find_by_x_and_y(behind_x, behind_y)

        refute from_square_after_move.unoccupied?
        assert to_square_after_move.unoccupied?
      end

      it 'must return false' do
        refute game_state.move(current_player_number, from_position, [behind_position])
      end

      it 'must set an error' do
        game_state.move(current_player_number, from_position, [behind_position])
        assert game_state.errors.first, 'That piece cannot move like that.'
      end

      it 'must not pass the turn' do
        game_state.move(current_player_number, from_position, [behind_position])
        assert_equal current_player_number, game_state.current_player_number
      end
    end
  end

  describe 'double jump' do
    let(:current_player_number) { 1 }

    let(:jumper_x) { 1 }
    let(:jumper_y) { 0 }

    let(:first_landing_x) { 3 }
    let(:first_landing_y) { 2 }

    let(:second_landing_x) { 1 }
    let(:second_landing_y) { 4 }

    let(:jumper_position) { { x: jumper_x, y: jumper_y } }
    let(:first_landing_position) { { x: first_landing_x, y: first_landing_y } }
    let(:second_landing_position) { { x: second_landing_x, y: second_landing_y} }

    let(:jumper) { JustCheckers::Square.new(id: 1, x: jumper_x, y: jumper_y, piece: {player_number: 1}) }
    let(:first_enemy) { JustCheckers::Square.new(id: 2, x: 2, y: 1, piece: {player_number: 2}) }
    let(:first_landing) { JustCheckers::Square.new(id: 3, x: first_landing_x, y: first_landing_y) }
    let(:second_enemy) { JustCheckers::Square.new(id: 4, x: 2, y: 3, piece: {player_number: 2}) }
    let(:second_landing) { JustCheckers::Square.new(id: 5, x: second_landing_x, y: second_landing_y) }

    let(:game_state) { JustCheckers::GameState.new(squares: [jumper, first_enemy, first_landing, second_enemy, second_landing], current_player_number: current_player_number) }

    it 'return true' do
      assert game_state.move(current_player_number, jumper_position, [first_landing_position, second_landing_position])
    end

    it 'must pass turn' do
      game_state.move(current_player_number, jumper_position, [first_landing_position, second_landing_position])
      refute_equal current_player_number, game_state.current_player_number
    end
  end

  describe 'moving to the last rank' do
    let(:current_player_number) { 1 }

    let(:last_rank_x) { 0 }
    let(:last_rank_y) { 7 }
    let(:last_rank_position) { {x: last_rank_x, y: last_rank_y} }
    let(:last_rank) { JustCheckers::Square.new(id: 1, x: last_rank_x, y: last_rank_y) }

    let(:moving_x) { 1 }
    let(:moving_y) { 6 }
    let(:moving_position) { {x: moving_x, y: moving_y} }
    let(:moving) { JustCheckers::Square.new(id: 2, x: moving_x, y: moving_y, piece: {player_number: 1}) }

    let(:game_state) { JustCheckers::GameState.new(squares: [moving, last_rank], current_player_number: current_player_number) }

    it 'must promote' do
      game_state.move(current_player_number, moving_position, [last_rank_position])
      last_rank_after_move = game_state.squares.find_by_x_and_y(last_rank_x, last_rank_y)
      assert last_rank_after_move.piece.king?
    end
  end

  describe 'a player has no pieces' do
    let(:player_one_square) { JustCheckers::Square.new(id: 1, x: 0, y: 0, piece: {player_number: 1}) }
    let(:empty_square) { JustCheckers::Square.new(id: 2, x: 1, y: 1) }
    let(:game_state) { JustCheckers::GameState.new(current_player_number: 1, squares: [player_one_square, empty_square]) }

    it 'makes the other player the winner' do
      assert_equal 1, game_state.winner
    end
  end

  describe 'a player has no moves' do
    let(:player_one_square) { JustCheckers::Square.new(id: 1, x: 0, y: 0, piece: {player_number: 1}) }
    let(:empty_square) { JustCheckers::Square.new(id: 2, x: 1, y: 1) }
    let(:blocking_square) { JustCheckers::Square.new(id: 3, x: 6, y: 0, piece: {player_number: 1}) }
    let(:player_two_square) { JustCheckers::Square.new(id: 4, x: 7, y: 1, piece: {player_number: 2}) }
    let(:game_state) { JustCheckers::GameState.new(current_player_number: 1, squares: [player_one_square, empty_square, blocking_square, player_two_square]) }

    it 'makes the other player the winner' do
      assert_equal 1, game_state.winner
    end
  end

  describe 'both player has moves' do
    let(:player_one_square) { JustCheckers::Square.new(id: 1, x: 0, y: 0, piece: {player_number: 1}) }
    let(:empty_square) { JustCheckers::Square.new(id: 2, x: 1, y: 1) }
    let(:player_two_square) { JustCheckers::Square.new(id: 3, x: 2, y: 2, piece: {player_number: 2}) }
    let(:game_state) { JustCheckers::GameState.new(current_player_number: 1, squares: [player_one_square, empty_square, player_two_square]) }

    it 'makes the other player the winner' do
      assert_nil game_state.winner
    end
  end
end
