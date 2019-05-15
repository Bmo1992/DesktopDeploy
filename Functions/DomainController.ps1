Configuration DomainController
{
    Import-DscResource -ModuleName PSDesiredStateConfiguration

    Node GCSO-DC
    {
	      # Install Directory Domain Services and any subfeatures
        WindowsFeature ADDSInstall
		    {
		        Ensure = 'Present'
			      Name = 'AD-Domain-Services'
			      IncludeAllSubFeature = $True
		    }
		
		    # Install all GUI tools
		    WindowsFeature ADDSTools
		    {
		        DependsOn = '[WindowsFeature]ADDSInstall'
		        Ensure = 'Present'
			      Name = 'RSAT-AD-Tools'
			      IncludeAllSubFeature = $True
		    }
		
		    # Install the DHCP server roles
		    WindowsFeature DHCPInstall
		    {
		        Ensure = 'Present'
			      Name = 'DHCP'
			      IncludeAllSubFeature = $True
		    }
		
		    # Install the GUI tools for managing DHCP
		    WindowsFeature DHCPTools
		    {
		        DependsOn = '[WindowsFeature]DHCPInstall'
			      Ensure = 'Present'
		  	    Name = 'RSAT-DHCP'
	          IncludeAllSubFeature = $True
	    	}
		
	    	# Install the DNS server role
	    	WindowsFeature DNSInstall
	    	{
		        Ensure = 'Present'
	    	  	Name = 'DNS'
	    	  	IncludeAllSubFeature = $True
	    	}
		
		    # Install the DNS GUI management tools
		    WindowsFeature DNSTools
        {
		        DependsOn = '[WindowsFeature]DNSInstall'
		        Ensure = 'Present'
			      Name = 'RSAT-DNS-Server'
			      IncludeAllSubFeature = $True
		    }
    }
}

DomainController
