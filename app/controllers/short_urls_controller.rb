class ShortUrlsController < ApplicationController

    before_action :find_url, only: [:show, :shortened]
    skip_before_action :verify_authenticity_token

    def index
        @url = ShortUrl.new
    end

    def show
        @url.visitors.create(ip_address: request.remote_ip)
        redirect_to @url.sanitize_url
    end

    def create
        @url = ShortUrl.new
        @url.original_url = params[:original_url]
        @url.sanitize
        if @url.new_url?
            if @url.save
                redirect_to shortened_path(@url.short_url)
            else
                flash[:error] = "Some error occured"
                render :index
            end
        else
            flash[:notice] = "Short url for this url already exist"
            redirect_to shortened_path(@url.check_for_duplicate_url)
        end
    end 
 
    def shortened
        @url = ShortUrl.find_by_short_url(params[:short_url])
        host = request.host_with_port
        @original_url = @url.sanitize_url
        @short_url = host + "/" + @url.short_url
        @visitors_count = @url.visitors.count
    end 

    def fetch_original_url
        fetch_url = ShortUrl.find_by_short_url(params[:short_url])
        redirect_to fetch_url.sanitize_url
    end

    private

    def find_url
        @url = ShortUrl.find_by_short_url(params[:short_url])
    end

    def url_params
        params.require(:url).permit(:original_url)
    end
end
