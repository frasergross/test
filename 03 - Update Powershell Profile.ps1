# Add environment variables to PowerShell profile
# Test for a profile, if not found create one!
if (-not (Test-Path $profile) ) {
    New-Item -Path $profile -ItemType File -Force
}

# Edit profile to add these lines
'$env:path = "$env:path;\C:\Program Files\OpenSSL-Win64\bin"' | Out-File $profile -Append
'$env:OPENSSL_CONF = "C:\setup\7 - OpenSSL\openssl.cnf"' | Out-File $profile -Append