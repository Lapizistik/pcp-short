#!/usr/bin/ruby -w
# coding: utf-8

# A solver for the PCP in few lines :-)

##
# For a given instance a solution is returned if it is found within the
# given depth
# instance :: [[x0,y0], [x1,y1], …, [xn,yn]]
# depth :: maximum search depth
def solve(instance, solution=[], x='', y='', depth: 30)
  instance.each.with_index do |p,i|
    (xx,yy) = [x,y].zip(p).map { |s,w| s+w }
    l = [xx.length, yy.length].min
    return [*solution, i] if xx == yy # found it. Get outta here
    if (xx[0...l] == yy[0...l]) && # hm, possible solution?
       (s=solve(instance, [*solution, i], xx[l..-1], yy[l..-1], depth: depth-1))
      return s # ha, found one somewhere deeper
    end
  end && nil if depth > 0
end

# Usage examples:
p1 = [['1','101'], ['10','00'], ['011','11']]
solution = solve(p1)
puts "Solution for #{p1.inspect}: #{solution.inspect}"

p2 = [['001','0'], ['01','011'], ['01','101'],['10','001']]
solution = solve(p2)
puts "Solution for #{p2.inspect}: #{solution.inspect}"

# we need to increase depth:

solution = solve(p2, depth: 80)
puts "Solution for #{p2.inspect}: #{solution.inspect}"
