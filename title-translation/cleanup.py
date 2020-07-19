import sys, pandas, regex, opencc

p = regex.compile(r'\p{So}')
converter_tw2s = opencc.OpenCC('tw2s.json')
converter_t2s = opencc.OpenCC('t2s.json')
converter_hk2s = opencc.OpenCC('hk2s.json')

for line in sys.stdin:
    line = line.replace('\n', ' ')
    line = line.replace('\"', ' ')
    line = line.replace(',', ' ')
    line = p.sub(" ", line)
    line = converter_tw2s.convert(line)
    line = converter_t2s.convert(line)
    line = converter_hk2s.convert(line)
    print(u'%s' % line)
