
# Deploy via Capistrano.

log "################################# This is where you need to install Gitlab. #################################" do
  not_if { FileTest.exists?("/home/gitlab/gitlab") }
end