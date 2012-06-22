#!/usr/bin/ruby

def out(m)
  m.size.times { |i| puts(m[i].map { |x| {1 => '#', -1 => '.'}[x] }.join) }
  puts
end

def flip(m)
  m.size.times { |i| m[i].map! { |x| -x } }
end

def copy(m)
  m.map { |x| x.dup }
end

def glue(a, b)
  a = copy(a)
  a.size.times { |i| a[i] += b[i] }
  a
end


h = [[1, -1], [1, 1]]

puts("h_1:")
out(h)

5.times do |i|
  puts("h_#{i+2}:")

  hf = copy(h)
  flip(hf)

  h2 = glue(h, h) + glue(h, hf)
  out(h2)
  h = h2
end
