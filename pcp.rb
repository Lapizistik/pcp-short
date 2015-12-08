#!/usr/bin/ruby -w
# coding: utf-8

# A solver for the PCP in few lines :-)
#
# Depth-first search was easier to implement. Challenge was to
# use only some few lines of code, therefore the given solution is rather
# compact and not optimized regarding readability.
#
# I added breadth-first search which is much faster as it goes
# for the shortest solution, as long as you have enough memory.
# E.g. solve_bfs([['10','1'],['10','0'],['01','1'],['01','0']])
# has exponential memory usage.
#
# Both approaches go brute force.

##
# Depth first search
#
# For a given instance a solution is returned if it is found within the
# given depth
# instance :: [[x0,y0], [x1,y1], …, [xn,yn]]
# depth :: maximum search depth
def solve_dfs(instance, solution=[], x='', y='', depth: 30)
  instance.each.with_index do |p,i|
    (xx,yy) = [x,y].zip(p).map { |s,w| s+w }
    l = [xx.length, yy.length].min
    return [*solution, i] if xx == yy # found it. Get outta here
    if (xx[0...l] == yy[0...l]) && # hm, possible solution?
       (s=solve_dfs(instance, [*solution, i], xx[l..-1], yy[l..-1], depth: depth-1))
      return s # ha, found one somewhere deeper
    end
  end && nil if depth > 0 # shouldn't use modifier after multi line block ;-)
end

##
# Breadth first search
#
# For a given instance a solution is returned if it is found within the
# given depth. If no solution is found within the given depth but it is
# possible that one may be found in the future nil is returned.
# If no solution is possible false is returned. The algorithm is not very
# intelligent and does not include extra analysis whether a solution is
# impossible but simply detects brute-force that the set of possible
# solutions runs empty. E.g.
# solve_bfs([['10','1'],['10','0']]) will give nil
# 
#
# instance :: [[x0,y0], [x1,y1], …, [xn,yn]]
# depth :: maximum search depth
def solve_bfs(instance, depth: 100)
  current=[['','',[]]]
  depth.times do |d|
    possible = []
    instance.each.with_index do |p,i|
      current.each do |x,y, solution|
        (xx,yy) = [x,y].zip(p).map { |s,w| s+w }
        l = [xx.length, yy.length].min
        return [*solution, i] if xx == yy # found it. Get outta here
        if (xx[0...l] == yy[0...l])       # hm, possible solution?
          possible << [xx[l..-1], yy[l..-1], [*solution, i]]
        end
      end
    end
    return false if possible.empty?
    warn "step #{d}: #{possible.length}"
    current = possible
  end
  return nil
end

# we choose which algorithm to use
alias solve solve_bfs

# Usage examples:
p1 = [['1','101'], ['10','00'], ['011','11']]
solution = solve(p1)
puts "Solution for #{p1.inspect}: #{solution.inspect}"

p2 = [['001','0'], ['01','011'], ['01','101'],['10','001']]
solution = solve(p2, depth: 30)
puts "Solution for #{p2.inspect}: #{solution.inspect}"

# we need to increase depth:

solution = solve(p2, depth: 80)
puts "Solution for #{p2.inspect}: #{solution.inspect}"

p3 = [['10','1'],['10','0']]
solution = solve(p3)
puts "Solution for #{p3.inspect}: #{solution.inspect}"

