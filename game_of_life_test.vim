source test_unit.vim
source game_of_life.vim

call AssertEqual(Transition("*", 2), "*" )
call AssertEqual(Transition("*", 3), "*" )
call AssertEqual(Transition("o", 3), "*" )
call AssertEqual(Transition("*", 4), "o" )

call AssertEqual(At([["a","b"],["c","d"]], 4, 5), "o")
