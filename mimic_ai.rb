class MimicAI
    def get_move(board, player_num)

        if board.moves_history != []
            return board.moves_history[-1]
        else
            return board.valid_cols_indexes.sample
        end

    end
end