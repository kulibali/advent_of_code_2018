
use "ponytest"

actor Main is TestList

  new create(env: Env) =>
    PonyTest(env, this)

  fun tag tests(test: PonyTest) =>
    test(_Day01Step01("data/day_01_01.txt"))
    test(_Day01Step02("data/day_01_01.txt"))