node('windows') {
    checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'CloneOption', noTags: false, reference: '', shallow: true, timeout: 2]], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'a97b10b1-5869-465d-8616-7231c95df9ac', url: 'git@github.com:RocketScienceProjects/testrobocopy.git']]])

   //7zip the webcontent folder
   stage name: 'Zipping', concurrency: 1
   env.PATH="C:\\Program Files\\7-Zip;C:\\Program Files\\Git\\usr\\bin;${env.PATH}"
   //bat 'rmdir /S /Q %cd%\\artifacts'
   bat '''IF EXIST "%cd%\\artifacts" (
   rmdir "%cd%\\artifacts" /s /q)'''

   bat 'mkdir %cd%\\artifacts'
    def list = ["folder1", "folder2", "folder3", "folder4"]
      for (int i = 0; i < list.size(); i++) {
        def thingie = list.get(i);
          bat "7z a %cd%\\artifacts\\${thingie}.zip %cd%\\${thingie}\\PackageTmp\\*"
          }

          // renaming the some zip folders to match the ones on the IIS nodes
          bat "move /Y %cd%\\artifacts\\folder1.zip %cd%\\artifacts\\ReserveNumber.Service.Api.zip"
          bat "move /Y %cd%\\artifacts\\folder2.zip %cd%\\artifacts\\Supplier.Service.Api.zip"
          bat "move /Y %cd%\\artifacts\\folder3.zip %cd%\\artifacts\\Web.zip"
          bat "move /Y %cd%\\artifacts\\folder4.zip %cd%\\artifacts\\Costcalculator.Api.zip"


    //Copying the zips and extracting on the sprint_a node itself - hardcoding the node for the time being
    stage name: 'CopyExtractDelete_Sprint_a', concurrency: 1
    def list_a = ["ReserveNumber.Service.Api", "Supplier.Service.Api", "Web", "Costcalculator.Api"]
        for (int i = 0; i < list_a.size(); i++) {
        def thingie = list_a.get(i);
        //bat '''IF EXIST "\\\\WIN-RATABIECTJ2\\App\\tmp" (
        //rmdir "\\\\WIN-RATABIECTJ2\\App\\tmp" /s /q)'''
        //bat 'mkdir \\\\WIN-RATABIECTJ2\\App\\tmp'
        bat "copy %cd%\\artifacts\\${thingie}.zip  \\\\WIN-RATABIECTJ2\\App"
        bat "7z x \\\\WIN-RATABIECTJ2\\App\\${thingie}.zip -o\\\\WIN-RATABIECTJ2\\App\\${thingie} -y"
        //bat "move /Y \\\\WIN-RATABIECTJ2\\App\\tmp\\PackageTmp \\\\WIN-RATABIECTJ2\\App\\${thingie}"
        bat "del /Q \\\\WIN-RATABIECTJ2\\App\\${thingie}.zip"
        }

}
