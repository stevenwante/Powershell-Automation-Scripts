# PS script to remove account expiration for each username listed in file below

$a = Get-Content C:\Scripts\accountList.txt; #list of account names separated by newline

foreach ($i in $a)
{
	$user = Get-ADUser $i;
	Set-ADUser -identity $user.SamAccountName -AccountExpirationDate $null;
	$user.SamAccountName + " has been set to not expire.";
}