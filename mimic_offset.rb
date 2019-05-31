class MimicOffset
    def get_move(board, player_num)
        if board.moves_history != [] && board.moves_history.length >= 2
            return board.moves_history[-3]
        else
            return board.valid_cols_indexes.sample
        end
    end
end
