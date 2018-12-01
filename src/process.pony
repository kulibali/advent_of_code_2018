
use "files"
use "ponytest"

primitive Process[T: Any #share]
  fun apply(h: TestHelper, fname: String, loop: Bool, initial: T,
    proc: {(T, String iso): (T, Bool)}) : T
  =>
    var cur = initial
    try
      let path = FilePath(h.env.root as AmbientAuth, fname) ?
      repeat
        match OpenFile(path)
        | let file: File =>
          let lines = FileLines(file)
          for line in lines do
            (cur, let go_on) = proc(cur, consume line)
            if not go_on then
              return cur
            end
          end
          file.dispose()
        else
          h.fail("error opening file " + fname)
        end
      until not loop end
    else
      h.fail()
    end
    cur

primitive ProcessI64[T: Any #share]
  fun apply(h: TestHelper, fname: String, loop: Bool, initial: T,
    proc: {(T, I64): (T, Bool)}) : T
  =>
    Process[T](h, fname, loop, initial,
      {(cur: T, line: String iso): (T, Bool) =>
        if line.size() > 0 then
          line.lstrip("+")
          try
            let n = line.i64()?
            return proc(cur, n)
          else
            h.fail("could not parse I64 " + (consume line))
          end
        end
        (cur, false)
      })
