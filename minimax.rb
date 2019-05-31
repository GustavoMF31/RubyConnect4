class MiniMax
    DEPTH = 6
    INFINITY = Float::INFINITY

    def get_move(board, player_num)
        if player_num == 1
            pos_value, move = minimax(board, player_num, true, DEPTH)
        else
            pos_value, move = minimax(board, player_num, false, DEPTH)
        end

        return move

    end

    def minimax(board, player_num, maximize, depth)

        if depth == 0
            return [eval(board), nil]
        end

        if maximize
            best_move = [-INFINITY, board.valid_cols_indexes[0]]
        else
            best_move = [INFINITY, board.valid_cols_indexes[0]]
        end

        opponent = (player_num == 1)? 2:1


        # Iterate over the valid moves
        board.valid_cols_indexes.each do |col_index|
            # Get the board with the move applied to it
            test_board = board.test_move(player_num, col_index)

            # If the move wins the game, choose it
            if test_board.winner == player_num
                if maximize
                    return [INFINITY, col_index]
                else
                    return [-INFINITY, col_index]
                end
            end

            # See what's the opponents best response to this move
            pos_value, response_move = minimax(test_board, opponent, !maximize, depth - 1)

            # If the move is better than the current best move, save it
            if maximize
                if pos_value > best_move[0]
                    best_move = [pos_value, col_index]
                end
            else
                if pos_value < best_move[0]
                    best_move = [pos_value, col_index]
                end
            end

        end

        if best_move.include?(nil)
            puts "DEBUG"
            puts "board=#{board.to_s}"
            puts "best_move=#{best_move}"
            puts "maximize=#{maximize}"
            puts "depth=#{maximize}"
            puts "player_num=#{player_num}"

        end

        return best_move

    end

        def eval(board)
            # Tells how good the position is for Player1
            return 5
        end
end