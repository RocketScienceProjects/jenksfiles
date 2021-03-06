node('windows') {
    checkout([$class: 'GitSCM', branches: [[name: '*/master']], doGenerateSubmoduleConfigurations: false, extensions: [[$class: 'CloneOption', noTags: false, reference: '', shallow: true]], submoduleCfg: [], userRemoteConfigs: [[credentialsId: 'a97b10b1-5869-465d-8616-7231c95df9ac', url: 'git@github.com:RocketScienceProjects/BlueKing.git']]])

   //7zip the webcontent folder
   stage name: 'Zipping', concurrency: 1
   env.PATH="C:\\Program Files\\7-Zip;C:\\Program Files\\Git\\usr\\bin;${env.PATH}"
   bat 'rmdir %cd%\\artifacts'
   bat 'mkdir %cd%\\artifacts'
    def list = ["webcontent", "src"]
      for (int i = 0; i < list.size(); i++) {
        def thingie = list.get(i);
          bat "7z a %cd%\\artifacts\\${thingie}.zip ${thingie}"
          }


   //extract the zip file
   stage name: 'ExtractingAndDeleting', concurrency: 1

     for (int i = 0; i < list.size(); i++) {
       def thingie = list.get(i);
         bat "7z x %cd%\\artifacts\\${thingie}.zip -o\\\\WIN-RATABIECTJ2\\App -y"
          //bat "del %cd%\\artifacts\\${thingie}.zip"
         }

}
