function! AssertEqual(actual, expected)
  if a:actual == a:expected
    echon "."
  else
    echom "Expected " . a:expected . " but got " . a:actual
  end
endfunction
