prioritized = ['INBOX', '_Read', 'Sent']

def mycmp(x, y):
  for prefix in prioritized:
    xsw = getattr(x, 'name', x).startswith(prefix)
    ysw = getattr(y, 'name', y).startswith(prefix)
    if xsw and ysw:
      return cmp(x, y)
    elif xsw:
      return -1
    elif ysw:
      return +1
  return cmp(x, y)

def test_mycmp():
  import os, os.path
  folders=os.listdir(os.path.expanduser('~/Mail'))
  folders.sort(mycmp)
  print folders
