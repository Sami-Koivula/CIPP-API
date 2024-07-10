function Invoke-CIPPStandardMessageExpiration {
    <#
    .FUNCTIONALITY
    Internal
    .APINAME
    MessageExpiration
    .CAT
    Exchange Standards
    .TAG
    "lowimpact"
    .HELPTEXT
    Sets the transport message configuration to timeout a message at 12 hours.
    .DOCSDESCRIPTION
    Expires messages in the transport queue after 12 hours. Makes the NDR for failed messages show up faster for users. Default is 24 hours.
    .ADDEDCOMPONENT
    .LABEL
    Lower Transport Message Expiration to 12 hours
    .IMPACT
    Low Impact
    .POWERSHELLEQUIVALENT
    Set-TransportConfig -MessageExpirationTimeout 12.00:00:00
    .RECOMMENDEDBY
    .DOCSDESCRIPTION
    Sets the transport message configuration to timeout a message at 12 hours.
    .UPDATECOMMENTBLOCK
    Run the Tools\Update-StandardsComments.ps1 script to update this comment block
    #>




    param($Tenant, $Settings)

    $MessageExpiration = (New-ExoRequest -tenantid $Tenant -cmdlet 'Get-TransportConfig').messageExpiration

    If ($Settings.remediate -eq $true) {
        Write-Host 'Time to remediate'
        if ($MessageExpiration -ne '12:00:00') {
            try {
                New-ExoRequest -tenantid $Tenant -cmdlet 'Set-TransportConfig' -cmdParams @{MessageExpiration = '12:00:00' }
                Write-LogMessage -API 'Standards' -tenant $tenant -message 'Set transport configuration message expiration to 12 hours' -sev Info
            } catch {
                $ErrorMessage = Get-NormalizedError -Message $_.Exception.Message
                Write-LogMessage -API 'Standards' -tenant $tenant -message "Failed to set transport configuration message expiration to 12 hours. Error: $ErrorMessage" -sev Debug
            }
        } else {
            Write-LogMessage -API 'Standards' -tenant $tenant -message 'Transport configuration message expiration is already set to 12 hours' -sev Info
        }

    }
    if ($Settings.alert -eq $true) {
        if ($MessageExpiration -ne '12:00:00') {
            Write-LogMessage -API 'Standards' -tenant $tenant -message 'Transport configuration message expiration is set to 12 hours' -sev Info
        } else {
            Write-LogMessage -API 'Standards' -tenant $tenant -message 'Transport configuration message expiration is not set to 12 hours' -sev Alert
        }
    }
    if ($Settings.report -eq $true) {
        if ($MessageExpiration -ne '12:00:00') { $MessageExpiration = $false } else { $MessageExpiration = $true }
        Add-CIPPBPAField -FieldName 'messageExpiration' -FieldValue $MessageExpiration -StoreAs bool -Tenant $tenant
    }
}




