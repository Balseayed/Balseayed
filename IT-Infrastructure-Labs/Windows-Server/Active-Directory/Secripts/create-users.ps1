Import-Module ActiveDirectory

$Users = Import-Csv "C:\users.csv"

foreach ($User in $Users) {

    $FullName = "$($User.FirstName) $($User.LastName)"
    $Password = ConvertTo-SecureString $User.Password -AsPlainText -Force

    New-ADUser `
        -Name $FullName `
        -GivenName $User.FirstName `
        -Surname $User.LastName `
        -SamAccountName $User.Username `
        -UserPrincipalName "$($User.Username)@Days.local" `
        -Path $User.OU `
        -AccountPassword $Password `
        -Enabled $true `
        -ChangePasswordAtLogon $true

    Add-ADGroupMember `
        -Identity $User.Group `
        -Members $User.Username
}
