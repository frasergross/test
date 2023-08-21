#Version 2.5
# Specify folder containing certificates
$certFolder = "c:\certs"

# Setup default Password for unecrypting and encrypting PFX and key files
$pfx_Password_default = "Unisys1234!"
$key_Password_default = $pfx_Password_default

#Get-ChildItem C:\certs | Out-GridView -Title 'Choose a file' -PassThru | ForEach-Object { $_.FullName }
$fileList = @(Get-ChildItem $certFolder | Out-GridView -Title 'Choose a file' -PassThru)

if ($fileList.Count -gt 0) {

# Ask for PFX password (no entry use default)
$pfx_Password = Read-Host "Enter the password to decrypt the PKCS12 (.pfx) file (blank to use default)"
if ($pfx_Password.Length -eq 0) { $pfx_Password = $pfx_Password_default }

# Ask for KEY password (no entry use default)
$key_Password = Read-Host "Enter the password to encrypt the KEY (.key) file (blank to use existing PFX password)"
if ($key_Password.Length -eq 0) { $key_Password = $pfx_Password }

foreach ($file in $fileList) 
    {
    Write-Host ("Attempt to Extract Key and Cert from file:" + $file.Name)
    $outCertFileName = $file.BaseName + ".pem"
    $outKeyFileName = $file.BaseName + ".key"
    openssl pkcs12 -in $file.name -out $outCertFileName -clcerts -nokeys -passin pass:$pfx_Password
    openssl pkcs12 -in $file.name -out $outKeyFileName -nocerts -nodes -passin pass:$pfx_Password -passout pass:$key_Password

    }
}
