#import AD module
Import-Module ActiveDirectory

#import Log-file function script
. "C:\Scripts\Write-Log.ps1"

#get date for log file
$DateTime = Get-Date -Format ‘MM-dd-yy’

#import aspen export csv file
$ADUsers = Import-csv "C:\Scripts\userExport.csv"

#import automated Groups txt file
$Groups = Get-Content "C:\Scripts\Groups.txt"

#Loop to remove automated memberships
foreach ($User in $ADUsers)
{
    $email = $User.EmailPrimary
    $userName,$domain = $email.split('@')

    #Check to see if the user already exists in AD
	if (Get-ADUser -Filter {mail -eq $email})
	{

	    #User exists in AD, proceed to assigning memberships
		
        #Remove all automated group memberships from user
        Write-Host "Removing Automated Groups from $userName"
        Write-Log -Message "Removing Automated Groups from $userName" -Severity Information
	    ForEach ($Group In $Groups)
	    {
		    Remove-ADGroupMember -Identity $Group -Members $userName -Confirm:$false
	    }
    }
	else
	{
		#If user does not exist, give a warning
        Write-Warning "A user account with username $userName does not exist in Active Directory." 
        Write-Log -Message "A user account with username $userName does not exist in Active Directory." -Severity Error
	}
}


#Loop to add automated memberships 
foreach ($User in $ADUsers)
{
	#Read user data from each field in each row and assign the data to a variable as below
	$email = $User.EmailPrimary
    $userName,$domain = $email.split('@')
	$jobCode = $User.JobCode
	$grade = $User.Grade
	$department = $User.Department
	$role = $User.Role
	$school = $User.School

	#Check to see if the user exists in AD
	if (Get-ADUser -Filter {mail -eq $email})
	{
		
        <#
        #check school and dump into group
        if ($school -like "Amherst") {
			Write-Host "This is an amherst user"
			#Add-ADGroupMember -Identity "Grade 1 Teachers" -Members $userName
		} 
		elseif ($school -like "Bicentennial") {
			Write-Host "This is an bicentennial user"
			#Add-ADGroupMember -Identity "Grade 2 Teachers" -Members $userName
		} 
        else {"I have no idea what my name is?"}
        #>


		#Add group memberships to username
		if ($grade -eq "1" -and $role -eq "Teacher") {
			Write-Host "ADDING $userName TO Grade 1 Teachers"
            Write-Log -Message "ADDING $userName TO Grade 1 Teachers" -Severity Information
			Add-ADGroupMember -Identity "Grade 1 Teachers" -Members $userName
		} 
		elseif ($grade -eq "2" -and $role -eq "Teacher") {
			Write-Host "ADDING $userName TO Grade 2 Teachers"
            Write-Log -Message "ADDING $userName TO Grade 2 Teachers" -Severity Information
			Add-ADGroupMember -Identity "Grade 2 Teachers" -Members $userName
		} 
		elseif ($grade -eq "3" -and $role -eq "Teacher") {
			Write-Host "ADDING $userName TO Grade 3 Teachers"
            Write-Log -Message "ADDING $userName TO Grade 3 Teachers" -Severity Information
			Add-ADGroupMember -Identity "Grade 3 Teachers" -Members $userName
		}
		elseif ($grade -eq "4" -and $role -eq "Teacher") {
			Write-Host "ADDING $userName TO Grade 4 Teachers"
            Write-Log -Message "ADDING $userName TO Grade 4 Teachers" -Severity Information
			Add-ADGroupMember -Identity "Grade 4 Teachers" -Members $userName
		} 
		elseif ($grade -eq "5" -and $role -eq "Teacher") {
			Write-Host "ADDING $userName TO Grade 5 Teachers"
            Write-Log -Message "ADDING $userName TO Grade 5 Teachers" -Severity Information
			Add-ADGroupMember -Identity "Grade 5 Teachers" -Members $userName
		} 
		else {"I have no idea what my name is?"}
	}
	else
	{
		#User does not exist in AD, give a warning
        Write-Warning "A user account with username $userName does not exist in Active Directory." 
        Write-Log -Message "A user account with username $userName does not exist in Active Directory." -Severity Error
	}
}

