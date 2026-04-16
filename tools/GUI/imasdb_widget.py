import imasdb
import imas
import xml.etree.ElementTree as ET
from PySide6.QtWidgets import QWidget


class IMASDB_Widget(QWidget):
  def __init__(self, title):
    super().__init__()
    self.ui = imasdb.Ui_IMASDB()
    self.ui.setupUi(self)
    self.ui.groupBox.setTitle(title)
  
  
  def GetDBEntry(self, opt = 'a'):
    
    uri = self.GetURI()
    if uri != '':
      return imas.DBEntry(uri, opt)
    
    return None
    
  
  def GetDBMetadata(self):
    ret = {}
    
    ret['uri'] = self.ui.lineEditURI.text()
    ret['user'] = self.ui.lineEditUser.text()
    ret['database'] = self.ui.lineEditDatabase.text()
    ret['shot'] = self.ui.lineEditShot.text()
    ret['run'] = self.ui.lineEditRun.text()
    ret['data_version'] = self.ui.lineEditVersion.text()
    
    backend_text = self.ui.comboBoxBackend.currentText()
    backends = {'MDS+':imas.imasdef.MDSPLUS_BACKEND, 'HDF5':imas.imasdef.HDF5_BACKEND, 'ASCII':imas.imasdef.ASCII_BACKEND}
    ret['backend'] = backends[backend_text]
    
    return ret
  
  
  def GetIDS(self, ids_names, occurrence:int = 0):
    imas_obj = self.GetDBEntry('r')
    
    if imas_obj:
      imas_obj.open()
      
      ids_list = [imas_obj.get(name, occurrence = occurrence) for name in ids_names]
      
      imas_obj.close()
      
      return ids_list
    
    return []
  
  
  def PutIDS(self, ids_list, occurrence:int = 0):
    imas_obj = self.GetDBEntry('w')
    
    if imas_obj:
      imas_obj.open()
      
      for ids in ids_list:
        imas_obj.put(ids, occurrence = occurrence)
      
      imas_obj.close()
  

  def SetUITextFromXML(self, lineEdit, node, defaultText=""):
    if node != None:
      lineEdit.setText(node.text)
    else:
      lineEdit.setText(defaultText)


  def SetXML(self, root):
    if (root == None):
      return
    
    n_uri = root.find('uri')
    uri = ''
    if n_uri != None:
      uri = n_uri.text
    self.SetUITextFromXML(self.ui.lineEditUser, root.find('user'), "")
    self.SetUITextFromXML(self.ui.lineEditDatabase, root.find('database'), "")
    self.SetUITextFromXML(self.ui.lineEditShot, root.find('pulse'), "")
    self.SetUITextFromXML(self.ui.lineEditRun, root.find('run'), "")
    self.SetUITextFromXML(self.ui.lineEditVersion, root.find('data_version'), "3")

    if (uri == ''):
      m = self.GetDBMetadata()
      if m['shot'] != '' and m['database'] != '':
        uri = imas.DBEntry.build_uri_from_legacy_parameters(backend_id = m['backend'], 
                                 pulse = int(m['shot']), 
                                 run = int(m['run']), 
                                 db_name = m['database'], 
                                 user_name = m['user'], 
                                 data_version = m['data_version'])

    self.ui.lineEditURI.setText(uri)


  def GetURI(self):
    uri = self.ui.lineEditURI.text()
    if (uri == ''):
      m = self.GetDBMetadata()
      if m['shot'] != '' and m['database'] != '':
        uri = imas.DBEntry.build_uri_from_legacy_parameters(backend_id = m['backend'], 
                                 pulse = int(m['shot']), 
                                 run = int(m['run']), 
                                 db_name = m['database'], 
                                 user_name = m['user'], 
                                 data_version = m['data_version'])
    
    return uri


  def SetURI(self, uri):
    self.ui.lineEditURI.setText(uri)
  

  def GetXML(self):

    root = ET.Element("root")
    node = ET.SubElement(root, "uri")
    node.text = self.GetURI()

    return root


