import Data.Maybe

data Cell = Alive | Dead deriving (Eq, Show)

tick board = rowsTick 0 board board

rowsTick _ [] _ = []
rowsTick rowNumber (row:rows) board =
  (rowTick row board rowNumber 0):(rowsTick (rowNumber+1) rows board)

rowTick [] _ _ _ = []
rowTick (cell:cells) board rowNumber columnNumber =
  tickedCell:(rowTick cells board rowNumber (columnNumber+1))
  where tickedCell = cellTick cell board rowNumber columnNumber

cellTick cell board rowNumber columnNumber =
  transition cell $ liveNeighborsCount board rowNumber columnNumber

liveNeighborsCount board rowNumber columnNumber =
  length $ filter (Alive==) neighboringCells
  where neighboringCells = [
          board `at` (rowNumber-1,columnNumber-1),
          board `at` (rowNumber-1,columnNumber),
          board `at` (rowNumber-1,columnNumber+1),
          board `at` (rowNumber, columnNumber-1),
          board `at` (rowNumber, columnNumber+1),
          board `at` (rowNumber+1, columnNumber-1),
          board `at` (rowNumber+1, columnNumber),
          board `at` (rowNumber+1, columnNumber+1)]

transition Alive 2 = Alive
transition Alive 3 = Alive
transition Dead  3 = Alive
transition _     _ = Dead

at board (rowNumber, columnNumber)
  | rowNumber < 0 || columnNumber < 0 = Dead
  | otherwise = maybe Dead id foundCell
    where
      foundCell =
        (listToMaybe $ drop rowNumber board) >>=
          listToMaybe . drop columnNumber


inputBoard = [
  [Alive,Alive,Dead ,Dead ]
 ,[Dead ,Alive,Dead ,Dead ]
 ,[Alive,Alive,Dead ,Alive]
 ,[Dead ,Dead ,Dead ,Dead ]
  ]

outputBoard = [
  [Alive,Alive,Dead ,Dead ]
 ,[Dead ,Dead ,Dead ,Dead ]
 ,[Alive,Alive,Alive,Dead ]
 ,[Dead ,Dead ,Dead ,Dead ]
  ]

main = putStrLn $ show $ tick inputBoard == outputBoard
