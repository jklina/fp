class Admin::BaseController < ApplicationController

  before_filter :request_admin_authentication

end
