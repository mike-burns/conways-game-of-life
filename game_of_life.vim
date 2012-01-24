function! Transition(cell, numberOfLiveNeighbors)
  if a:cell == "*" && (a:numberOfLiveNeighbors == 2 || a:numberOfLiveNeighbors == 3)
    return "*"
  elseif a:cell == "o" && a:numberOfLiveNeighbors == 3
    return "*"
  else
    return "o"
  endif
endfunction

function! At(matrix, x, y)
  if a:x < 0 || a:y < 0
    return "o"
  else
    return get(get(a:matrix, a:x, []), a:y, "o")
  endif
endfunction

function! NeighboringCells(board, x, y)
  return [ At(a:board, a:y-1, a:x-1), At(a:board, a:y-1, a:x), At(a:board, a:y-1, a:x+1), At(a:board, a:y, a:x-1), At(a:board, a:y, a:x+1), At(a:board, a:y+1, a:x-1), At(a:board, a:y+1, a:x), At(a:board, a:y+1, a:x+1) ]
endfunction

function! LiveNeighborsCount(board, x, y)
  let l:neighbors = NeighboringCells(a:board, a:x, a:y)
  return count(l:neighbors, "*")
endfunction

function! CellTick(cell, board, x, y)
  let l:neighborsCount = LiveNeighborsCount(a:board, a:x, a:y)
  return Transition(a:cell, l:neighborsCount)
endfunction

function! RowTick(row, board, x, y)
  if a:row == []
    return []
  else
    let l:cell = a:row[0]
    let l:cells = a:row[1:]
    let l:transitionedCell = CellTick(l:cell, a:board, a:x, a:y)
    return [l:transitionedCell] + RowTick(l:cells, a:board, a:x+1, a:y)
  endif
endfunction

function! RowsTick(y, rs, board)
  if a:rs == []
    return []
  else
    let l:row = a:rs[0]
    let l:rows = a:rs[1:]
    let l:transitionedRow = RowTick(l:row, a:board, 0, a:y)
    return [l:transitionedRow] + RowsTick(a:y+1, l:rows, a:board)
  endif
endfunction

function! Tick(board)
  return RowsTick(0, a:board, a:board)
endfunction

function! UITick()
  let l:board = []
  for unparsedRow in getbufline(bufnr('%'), 1, '$')
    let l:parsedRow = split(unparsedRow, ' ')
    let l:board = add(l:board, l:parsedRow)
  endfor

  let l:nextBoard = Tick(l:board)

  let l:nextBuffer = []
  for nextRow in l:nextBoard
    let l:nextLine = join(nextRow, ' ')
    let l:nextBuffer = add(l:nextBuffer, l:nextLine)
  endfor

  normal! ggdG
  exe "normal! i".join(l:nextBuffer, "\<cr>")."\<esc>"
endfunction

function! RunGameOfLife()
  while 1
    call UITick()
    redraw
    sleep 1
  endwhile
endfunction
