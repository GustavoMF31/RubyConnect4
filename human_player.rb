class Human
    def get_move(board, player_num)
        puts board.to_s
        print "\nWhat column to play in?: "

        col_index = gets

        while col_index == "\n"
            print "What column to play in?: "
            col_index = gets
        end
        
        puts "\n"
        col_index.to_i
    end
end