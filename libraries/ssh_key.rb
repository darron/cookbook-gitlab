# From: https://gist.github.com/788178

class Chef
  class Recipe

    def generate_ssh_keys(user_account)
      username = user_account
  
      raise ":user_account should be provided." if username.nil?
  
      Chef::Log.debug("generate ssh skys for #{username}.")
  
      execute "generate ssh skys for #{username}." do
        group username
        user username
        creates "/home/#{username}/.ssh/id_dsa.pub"
        command "ssh-keygen -t dsa -q -f /home/#{username}/.ssh/id_dsa -P \"\"" 
        not_if { FileTest.exists?("/home/#{username}/.ssh/id_dsa") }
      end
    end
    
  end
end