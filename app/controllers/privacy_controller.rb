class PrivacyController < ApplicationController
  skip_before_filter :require_login
  def index
  end
end
