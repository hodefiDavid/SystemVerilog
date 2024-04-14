
a = y >> 1`b1
// y = 1 1 0 1 -> 1 1 0 -> add a zero to the msb -> 0 1 1 0
b = y >>> 1`b1
// y = 1 1 0 1 -> 1 1 0 -> add a one to the msb acorrding to the sign bit -> 1 1 1 0

