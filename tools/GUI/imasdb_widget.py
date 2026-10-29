import os
import imasdb
import imas
import xml.etree.ElementTree as ET
from PySide6 import QtWidgets
from PySide6.QtWidgets import QWidget, QFileDialog


class IMASDB_Widget(QWidget):
  def __init__(self, title):
    super().__init__()
    self.ui = imasdb.Ui_IMASDB()
    self.ui.setupUi(self)
    self.ui.groupBox.setTitle(title)
    self.ui.pushButton_SelectPath.clicked.connect(self.SelectPath)
  
  
  def GetDBEntry(self, opt = 'a'):
    
    uri = self.GetURI()
    if uri != '':
      return imas.DBEntry(uri, opt)
    
    return None
    
  
  def GetDBMetadata(self):
    ret = {}
    
    ret['uri'] = self.ui.lineEditURI.text()
    ret['path'] = self.ui.lineEditPath.text()
    ret['user'] = self.ui.lineEditUser.text()
    ret['database'] = self.ui.lineEditDatabase.text()
    ret['shot'] = self.ui.lineEditShot.text()
    ret['run'] = self.ui.lineEditRun.text() 
    ret['data_version'] = self.ui.lineEditVersion.text()
    
    return ret
  
  
  def GetIDS(self, ids_names, occurrence:int = 0):
    imas_obj = self.GetDBEntry('r')
    
    if imas_obj:
      imas_obj.open()
      
      ids_list = [imas_obj.get(name, occurrence = occurrence) for name in ids_names]
      
      imas_obj.close()
      
      return ids_list
    
    return []
  
  
  def SelectPath(self):
      path_start = self.ui.lineEditPath.text()
      if not os.path.isdir(path_start):
        path_start = os.getenv('HOME')
      dirTmp = QtWidgets.QFileDialog.getExistingDirectory(self, "Select folder with IMAS database files...", path_start)

      if dirTmp:
        self.ui.lineEditPath.setText(dirTmp)
    
    
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
    
    uri = ""
    node_uri = root.find('uri')
    if node_uri != None:
      uri = node_uri.text

    path = ""
    node_path = root.find('path')
    if node_path != None:
      path = node_path.text

    database = ""
    node_database = root.find('database')
    if node_database != None:
      database = node_database.text

    if uri != "":
      self.ui.tabWidget.setCurrentWidget(self.ui.tabURI)
    elif path != "":
      self.ui.tabWidget.setCurrentWidget(self.ui.tabPath)
    elif database != "":
      self.ui.tabWidget.setCurrentWidget(self.ui.tabKeys)

    self.SetUITextFromXML(self.ui.lineEditURI, root.find('uri'), "")
    self.SetUITextFromXML(self.ui.lineEditPath, root.find('path'), "")
    self.SetUITextFromXML(self.ui.lineEditUser, root.find('user'), "")
    self.SetUITextFromXML(self.ui.lineEditDatabase, root.find('database'), "")
    self.SetUITextFromXML(self.ui.lineEditShot, root.find('pulse'), "")
    self.SetUITextFromXML(self.ui.lineEditRun, root.find('run'), "")
    self.SetUITextFromXML(self.ui.lineEditVersion, root.find('data_version'), "3")


  def GetURI(self):
    currentTab = self.ui.tabWidget.currentWidget()

    if currentTab == self.ui.tabURI:
      uri = self.ui.lineEditURI.text()
      return uri
    elif currentTab == self.ui.tabPath:
      m = self.GetDBMetadata()
      if m['path'] != '':
        backend_text = self.ui.comboBoxBackend_Path.currentText()
        backends_uri = {'MDS+':'mdsplus', 'HDF5':'hdf5', 'ASCII':'ascii'}
        uri = 'imas:' + backends_uri[backend_text] + '?path=' + m['path']
        return uri
    elif currentTab == self.ui.tabKeys:
      m = self.GetDBMetadata()
      if m['shot'] != '' and m['database'] != '':
        backend_text = self.ui.comboBoxBackend_Legacy.currentText()
        backends_id = {'MDS+':imas.imasdef.MDSPLUS_BACKEND, 'HDF5':imas.imasdef.HDF5_BACKEND, 'ASCII':imas.imasdef.ASCII_BACKEND}
        uri = imas.DBEntry.build_uri_from_legacy_parameters(backend_id = backends_id[backend_text], 
                                 pulse = int(m['shot']), 
                                 run = int(m['run']), 
                                 db_name = m['database'], 
                                 user_name = m['user'], 
                                 data_version = m['data_version'])
        return uri
    return ""


  def SetURI(self, uri):
    self.ui.lineEditURI.setText(uri)
  

  def GetXML(self):

    root = ET.Element("root")
    node = ET.SubElement(root, "uri")
    node.text = self.GetURI()

    return root


