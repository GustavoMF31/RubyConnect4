class Human
    def get_move(board, player_num)
        puts board.to_s
        puts "\n"
        print "What column to play in?: "
        col_index = gets.to_i
        while col_index == ""
            print "What column to play in?: "
            col_index = gets.to_i
        end
        puts "\n"
        col_index
    end
end