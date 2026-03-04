import sys,os
import shutil

import math
import numpy as np



class DINAParameter:
  def __init__(self, value, name=''):
    self.value = value
    self.name = name
    if type(value) == str:
      if value.isdigit():
        self.value = int(value)
      else:
        self.value = float(value)
    else:
      self.value = value



def ReadRow(f):
  dataStr = f.readline().rstrip().split()
  data = []
  for i in range(len(dataStr)):
    if dataStr[i].isdigit():
      data.append(int(dataStr[i]))
    else:
      data.append(float(dataStr[i]))
  
  return data



def ReadParameters(f, nrow:int=1):
  data = []
  for i in range(nrow):
    names = f.readline().rstrip()
    params = f.readline().rstrip().split()
    nparams = len(params)
    names = names.replace(',',' ').replace(' (','(').split(' ',nparams-1)
    DINAParams = []
    if len(names) < nparams:
      names = nparams*[" "]
    for j in range(nparams):
      DINAParams.append(DINAParameter(params[j], names[j]))
    data.append(DINAParams)
  return data

def WriteParameters(data, title=None):
  s = ""
  nrow = len(data)
  for i in range(nrow):
    for p in data[i]:
      s += (p.name + "  ")
    if title and i==0:
      s += (" !" + title)
    s += ('\n')
    for p in data[i]:
      s += (str(p.value) + "   ")
    s += ('\n')
  return s



def ReadParametersCol(f, nrow:int=1):
  data = []
  DINAParams = []
  for i in range(nrow):
    line = f.readline().strip().split()
    value = line[0]
    name = line[1]
    DINAParams.append(DINAParameter(value, name))
  data.append(DINAParams)
  return data

def WriteParametersCol(data, title=None):
  s = ""
  params = data[0]
  nrow = len(params)
  for i in range(nrow):
    s += "  "
    s += str(params[i].value)
    s += "  "
    s += params[i].name
    if title and i==0:
      s += (" !" + title)
    s += ('\n')
  return s


def ReadTimeTable(f):
  output = {}
  
  line = f.readline().rstrip()
  if not line:
    print("Unexpected end of file")
    return
  
  header = line.split("!")
  params = header[0]
  names1 = params.split()
  print(names1)
  output['headers1'] = names1
  if len(header) > 1:
    output['title'] = header[1].strip()
  else:
    output['title'] = None
  
  datant = ReadRow(f)
  if len(datant) == 0:
    return []
  nt = datant[0]

  if len(datant) > 1:
    output['params'] = datant[1:]
  else:
    output['params'] = []
  
  names2 = f.readline().rstrip().split()
  output['headers2'] = names2
  
  items = []
  nd = 0
  for it in range(nt):
    row = ReadRow(f)
    if nd != len(row)-1 and nd != 0:
      print("Bad timetable format")
    nd = len(row)-1
    items.append([x for x in row])
  
  
  output['items'] = items
  
  t = np.zeros(nt)
  wf = []
  for j in range(nd):
    wf.append(np.zeros(nt))
  for i in range(nt):
    t[i] = items[i][0]
    for j in range(nd):
      wf[j][i] = items[i][j+1]
  
  output['time'] = t
  output['data'] = wf
  
  return output



def WriteTimeTable(record):
  s = ""
  # Headers 1
  for x in record['headers1']:
    s += ("  " + str(x))
  if record['title']:
    s += ("  !" + record['title'])
  s += "\n"
  
  # nt and params
  nt = len(record['time'])
  s += "  " + str(nt)
  for x in record['params']:
    s += ("  " + str(x))
  s += "\n"
  
  # Headers 2
  for x in record['headers2']:
    s += ("  " + str(x))
  s += "\n"
  
  # Data
  nd = len(record['data'])
  for it in range(nt):
    s += f"{(record['time'][it]):15e}"
    for j in range(nd):
      s += ("  " + f"{(record['data'][j][it]):15e}")
    s += "\n"
  
  return s



def ReadScrData(f):
  output = {}
  
  line = f.readline().rstrip()
  if not line:
    print("Unexpected end of file")
    return
  
  headers2 = line.split()
  output['headers2'] = headers2
  
  items = []
  nd = 0
  while True:
    line = f.readline()
    if not line:
      break
    dataStr = line.rstrip().split()
    if nd == 0:
      nd = len(dataStr)-1
    if len(dataStr)-1 == nd:
      items.append([float(s) for s in dataStr])
    else:
      print(line)
  
  output['items'] = items
  
  
  nt = len(items)
  t = np.zeros(nt)
  wf = []
  for j in range(nd):
    wf.append(np.zeros(nt))
  for i in range(nt):
    t[i] = items[i][0]
    for j in range(nd):
      wf[j][i] = items[i][j+1]
  
  output['time'] = t
  output['data'] = wf
  
  return output



def WriteScrData(record):
  s = ""
  # Headers 2
  for x in record['headers2']:
    s += ("  " + str(x))
  s += "\n"
  
  # Data
  nd = len(record['data'])
  nt = len(record['data'][0])
  for it in range(nt):
    s += f"{(record['time'][it]):15e}"
    for j in range(nd):
      s += ("  " + f"{(record['data'][j][it]):15e}")
    s += "\n"
  
  return s



def RescaleTimeTable(record, tmult=1.0, fmult=1.0):
  record['time'] *= tmult
  for j in range(len(record['data'])):
    record['data'][j] *= fmult



def CopyWaveformData(wf_to, wf_from):
  wf_to['time'] = wf_from['time']
  wf_to['data'] = wf_from['data']

