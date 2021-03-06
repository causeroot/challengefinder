require 'mechanize'

class Admin::ProxyController < Admin::AdminController
  skip_before_filter :require_login
  skip_before_filter  :verify_authenticity_token

  # GET /proxies/url
  # GET /proxies/url.json
  def show
    agent = Mechanize.new
    page = agent.get params[:url]
    @html = page.content 
    render :layout => false, :text => @html
  end
end
