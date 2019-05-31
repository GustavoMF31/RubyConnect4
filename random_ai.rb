class RandomAI
    def get_move(board, player_num)
        board.valid_cols_indexes.sample
    end
end