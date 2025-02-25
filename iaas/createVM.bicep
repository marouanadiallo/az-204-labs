param vmName string

resource labVm 'Microsoft.DevTestLab/labs/virtualmachines@2018-09-15' = {
  name: vmName
  properties: {
    
  }
}
