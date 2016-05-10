$Webclient = New-Object System.Net.WebClient
$Nexusurl  = "https://<nexus_url>/nexus/content/repositories/releases/BuildOutput/testsourcing/1.0.0.100"
$Webclient.DownloadFile($Nexusurl,"testsourcing")
