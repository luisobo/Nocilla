
clone = (x) ->
  JSON.parse JSON.stringify x


timeoutSet = (ms, f) ->
  setTimeout f, ms


dictionaries_equal = (d1, d2) ->
  d1 = clone d1
  for own k of d2
    return false if d1[k] != d2[k]
    delete d1[k]
  return false if _.keys(d1).length != 0
  true


pretty_json_stringify = (x) ->
  JSON.stringify x, null, '  '


re_escape = (s) ->
  s.replace /([\[\]\\$()*+.?^{|}-])/g, '\\$1'


regex_from_glob = (s) ->
  regex_arr = []
  for fragment in s.split /(\*)/
    regex_arr.push if fragment == '*' then '(.*)' else re_escape fragment
  "^#{regex_arr.join ''}$"


matches_glob = (s, glob) ->
  !! s.match new RegExp regex_from_glob glob


module.exports = {clone, timeoutSet, dictionaries_equal, pretty_json_stringify, re_escape, regex_from_glob, matches_glob}
